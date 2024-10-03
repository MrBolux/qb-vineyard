
local currentProduction = nil
local productionMenu = nil
local recipeMenu = nil

local function createFermentationZones()
    local fermentationZones = {}
    for job, stashs in pairs(Config.Fermentation) do
        for key, stash in ipairs(stashs) do
            local zoneName = string.format("%s_%s_%s", 'fermentation', job, key)

            local zoneParams = {
                name = zoneName,
                heading = stash.box.heading,
                minZ = stash.box.minZ,
                maxZ = stash.box.maxZ,
                debugPoly = Config.debug
            }

            local options = {
                {
                    action = function()
                        currentProduction = zoneName
                        exports['qb-menu']:openMenu(productionMenu)
                    end,
                    icon = 'fas fa-ring',
                    label = 'Ouvrir',
                    job = job,
                }
            }

            local boxOptions = {
                options = options,
                distance = 1.5
            }

            local stashZone = exports['qb-target']:AddBoxZone(zoneName, stash.box.coords, stash.box.length, stash.box.width, zoneParams, boxOptions)
            table.insert(fermentationZones, stashZone.name)
        end
    end
    return fermentationZones
end

local function generateMenus()
    recipeMenu = {
        {
			header = 'Recette',
			isMenuHeader = true,
		},
    }

	for recipe, detail in pairs(Config.Recipe) do
        QBCore.Debug(recipe)
        QBCore.Debug(detail)
		recipeMenu[#recipeMenu + 1] = {
			header = 'Recette '..recipe,
			params = {
                event = 'qb-vineyard:client:setProductionRecipe',
                args = {
                    recipe = recipe,
                    detail = detail
                }
			}
		}
	end

    productionMenu = {
		{
			header = 'Production',
			isMenuHeader = true,
		},
        {
			header = 'Ouvrir',
			params = {
				event = 'qb-vineyard:client:openProduction',
			}
		},
        {
			header = 'Recette',
			params = {
                event = 'qb-vineyard:client:openRecipe'
			}
		},
        {
			header = 'Lancer',
			params = {
				event = 'qb-vineyard:client:startProduction',
			}
		}
	}

end


RegisterNetEvent('qb-vineyard:client:openProduction', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', currentProduction)
    TriggerEvent('inventory:client:SetCurrentStash', currentProduction)
end)

RegisterNetEvent('qb-vineyard:client:openRecipe', function()
    exports['qb-menu']:openMenu(recipeMenu)
end)

RegisterNetEvent('qb-vineyard:client:startProduction', function()
    QBCore.Debug('Start production')
end)

RegisterNetEvent('qb-vineyard:client:setProductionRecipe', function(args)
    QBCore.Debug(args.recipe)
    QBCore.Debug(args.detail)
end)


createFermentationZones()
generateMenus()