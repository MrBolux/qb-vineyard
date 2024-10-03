local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-vineyard:server:receiveItem', function(item, amount)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
	Player.Functions.AddItem(item, amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
end)

QBCore.Functions.CreateCallback('qb-vineyard:server:processingItem', function(source, cb, item, requiredItems, amount)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))

	if not exports['qb-inventory']:HasItem(source, requiredItems) then
		QBCore.Functions.Notify(source, 'Il vous manque des items', 'error', 7500)
		cb(false)
	end

	for name, removeAmount in pairs(requiredItems) do
		Player.Functions.RemoveItem(name, removeAmount)
		TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items[name], 'remove', removeAmount)
	end

	Player.Functions.AddItem(item, amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
	cb(true)
end)