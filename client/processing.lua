
-- processing
local insideProcessingZone = false
local processing = false
local processingRecipe = {}
local processingZone = nil
local menuProcessing = {}
processingBlip = nil


local function processingProgress()

    if not exports['qb-inventory']:HasItem(processingRecipe.details.requiredItems) then
        QBCore.Functions.Notify('Il vous manque des items', 'error', 5000)
        processing = false
        return
    end

    processing = true
    QBCore.Functions.Progressbar("processing_process", 'Traitement en cours...', math.random(6000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.processingAnim.animDict,
        anim = Config.processingAnim.anim,
        flags = 1,
    }, {}, {}, function() -- Terminé
        StopAnimTask(PlayerPedId(), Config.processingAnim.animDict, Config.processingAnim.anim, 1.0)
        QBCore.Functions.TriggerCallback('qb-vineyard:server:processingItem', function(finish)
            if finish then
                processingProgress()
            end
        end, processingRecipe.item, processingRecipe.details.requiredItems, math.random(processingRecipe.details.amount.min, processingRecipe.details.amount.max))

    end, function() -- Annuler
        StopAnimTask(PlayerPedId(), Config.processingAnim.animDict, Config.processingAnim.anim, 1.0)
        processing = false
        QBCore.Functions.Notify('Produit non traité', "error")
    end)
end

function createProcessingZones()
    processingBlip = exports['togolo_lib']:createBlip(Config.processingBlip, { job = 'vineyard' })

    processingZone = BoxZone:Create(Config.processingZones.coords, Config.processingZones.length, Config.processingZones.width, {
        name = 'ProcessingZoneVineyard',
        heading = Config.processingZones.heading,
        minZ = Config.processingZones.coords.z - 1,
        maxZ = Config.processingZones.coords.z + 1,
        debugPoly = Config.Debug,
    })

    processingZone:onPlayerInOut(function(isPointInside)
        insideProcessingZone = isPointInside
        if isPointInside then
            exports['okokTextUI']:Open('[E] Commencer le traitement', 'lightblue', 'right')
            CreateThread(function()
                while insideProcessingZone do
                    if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0, 38) and not processing then
                        exports['qb-menu']:openMenu(menuProcessing)
                        exports['okokTextUI']:Close()
                    end
                    Wait(1)
                end
            end)
        else
            exports['okokTextUI']:Close()
        end
    end)
end


local function initProcessing()
	menuProcessing = {
		{
			header = 'Traitement',
			isMenuHeader = true,
		}
	}

	for k, detail in pairs(Config.processingRecipe) do
		menuProcessing[#menuProcessing + 1] = {
			header = 'Tranformer '..QBCore.Shared.Items[k].label,
			params = {
				event = 'qb-vineyard:client:setProcessingRecipe',
                args = {
                    item = k,
                    details = detail,
                }
			}
		}

	end
    createProcessingZones()
end

Citizen.CreateThread(function()
    -- Todo Créer une fonction pour l'appeler quand on change de job et ajouter une vérification onDuty
    -- while PlayerData.job.name == 'vineyard' do
        local sleep = true
        local distance = #(GetEntityCoords(PlayerPedId()) - Config.processingZones.coords)
        if distance < 5.0 then
            sleep = false
            DrawMarker(27, Config.processingZones.coords.x, Config.processingZones.coords.y, Config.processingZones.coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 255, 255, false, true, 2, true, nil, false)
        end
        Citizen.Wait(sleep and 1000 or 1)
    -- end
end)


RegisterNetEvent('qb-vineyard:client:setProcessingRecipe', function(args)
    processingRecipe = args
    processingProgress()
end)

initProcessing()