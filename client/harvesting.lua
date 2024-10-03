missionsPed = {}
local menuHarvesting = {}
local harvestZone = {}
local taskingBlip = nil
local task = nil
local harvesting = false
local pickedCount = 0

local function harvestingProgress(item)
    QBCore.Functions.Progressbar("harvesting_process", 'Récolte en cours', math.random(6000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.recolte[item].animDict,
        anim = Config.recolte[item].anim,
        flags = 1,
    }, {}, {}, function() -- Terminé
        StopAnimTask(PlayerPedId(), Config.recolte[item].animDict, Config.recolte[item].anim, 1.0)
		TriggerServerEvent("qb-vineyard:server:receiveItem", item, math.random(Config.recolte[item].amount.min, Config.recolte[item].amount.max))
        QBCore.Functions.Notify('Produit récolté')
        task = nil
        exports['togolo_lib']:deleteBlip(taskingBlip)
		taskingBlip = nil
    end, function() -- Annuler
        StopAnimTask(PlayerPedId(), Config.recolte[item].animDict, Config.recolte[item].anim, 1.0)
        QBCore.Functions.Notify('Produit non récolté', "error")
    end)
end

function createHarvestZones()
    for fruit, details in pairs(Config.recolte) do
        harvestZone[fruit] = {} -- Création d'une sous-table pour chaque type de fruit
        for k, _ in pairs(details.locations) do
            local label = ("Harvest%sZone-%s"):format(fruit:gsub("^%l", string.upper), k)
            local zone = BoxZone:Create(details.locations[k], details.size.length, details.size.width, {
                name = label,
                heading = details.size.heading,
                minZ = details.locations[k].z - 1.0,
                maxZ = details.locations[k].z + 1.0,
                debugPoly = Config.Debug,
            })

            harvestZone[fruit][k] = zone -- Enregistrer la zone dans la table harvestZone

            harvestZone[fruit][k]:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    if k == task then
                        CreateThread(function()
                            while isPointInside and k == task do
                                exports['okokTextUI']:Open('[E] Commencer la récolte', 'lightblue', 'right')
                                if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0, 38) then
                                    harvestingProgress(fruit)
                                    exports['okokTextUI']:Close()
                                end
                                Wait(1)
                            end
                        end)
                    end
                else
                    exports['okokTextUI']:Close()
                end
            end)
        end
    end
end

local function drawMarker(coords)
    local color = {r = 255, g = 255, b = 255, a = 255}
    Citizen.CreateThread(function()
        while task and harvesting do

            local sleep = true
            local distance = #(GetEntityCoords(PlayerPedId()) - coords)
            if distance < 100.0 then
                sleep = false
                DrawMarker(32, coords.x, coords.y, coords.z + 2.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,1.0, color.r, color.g, color.b, color.a, true, true, 2, true, nil, false)
            end
            Citizen.Wait(sleep and 1000 or 1)
        end
    end)
end

local function nextTask(locations)
	if task then
		return
	end
	task = math.random(#locations)

    Config.defaultBlipHarvesting.coords = locations[task]
    taskingBlip = exports['togolo_lib']:createBlip(Config.defaultBlipHarvesting, { player = PlayerData.source })
    drawMarker(locations[task])
end

local function startHarvesting(harvestingData)
	local limitCollect = math.random(Config.limitCollect.min, Config.limitCollect.max)
    QBCore.Functions.Notify('Récolte et reviens me voir quand tu a fini')
	while harvesting do
		if task then
			Wait(6000)
		else
			if pickedCount < limitCollect then
				nextTask(harvestingData.locations)
				pickedCount += 1
			else
				harvesting = false
				pickedCount = 0
				QBCore.Functions.Notify('Il n\'y a plus rien à récolter')
			end
		end
		Wait(5)
	end
end


local function initScript()
	menuHarvesting = {
		{
			header = 'Récolte',
			isMenuHeader = true,
		}
	}

	for k, detail in pairs(Config.recolte) do

		local eventName = 'qb-vineyard:client:'..k..'Harvesting'

		RegisterNetEvent(eventName, function()
			harvesting = true
			startHarvesting(detail)
		end)

		menuHarvesting[#menuHarvesting + 1] = {
			header = 'Récolte '..QBCore.Shared.Items[k].label,
			params = {
				event = eventName,
			}
		}

	end

    menuHarvesting[#menuHarvesting + 1] = {
        header = 'Finir la récolte',
        params = {
            event = 'qb-vineyard:client:finishHarvesting',
        }
    }

	Config.pedStartWork.options = {{
		action = function()
			exports['qb-menu']:openMenu(menuHarvesting)
		end,
		icon = 'fas fa-sign-in-alt',
		label = 'Commencer la récolte',
		job = 'vineyard',

	}}

	missionsPed = exports['togolo_lib']:createInteractPed(Config.pedStartWork)

	createHarvestZones()
end

RegisterNetEvent('qb-vineyard:client:finishHarvesting', function()
    task = nil
    harvesting = false
    pickedCount = 0
    exports['togolo_lib']:deleteBlip(taskingBlip)
    taskingBlip = nil
end)

initScript()