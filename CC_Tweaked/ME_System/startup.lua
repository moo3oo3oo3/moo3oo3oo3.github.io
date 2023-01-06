--*Config*--
--This program requires SNBT.lua

--------------------------------------
-------Do not go pass this line-------
local SNBT = require("SNBT")

local chatBox = peripheral.find("chatBox")
local meBridge = peripheral.find("meBridge")
local chest = peripheral.find("inventory")
local inventoryManagers = { peripheral.find("inventoryManager") }

if chatBox == nil then error('Chat Box not detected!') end
if #inventoryManagers == 0 then error('Inventory Manager not detected!') end
if meBridge == nil then error('ME Bridge not detected!') end

local chestName = peripheral.getName(chest)
local prefix = textutils.serializeJSON({
	{text = 'ME System', color = 'blue'}
})
local managerSides = { 'left', 'right', 'back', 'front', 'top', 'bottom' }


function chat (msg, isGlobal, playerName)
	isGlobal = isGlobal or false
	
	if isGlobal then
		chatBox.sendMessage(msg, prefix)
	else chatBox.sendMessageToPlayer(msg, playerName, prefix) end
end


local function isArray (tbl)
	for k,v in pairs(tbl) do
		if type(k) == 'string' then return false end
	end
	
	return true
end


local function isEmpty (tbl)
	if next(tbl) then return false end
	return true
end


local function isValidPlayer (playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then return true end
	end
	
	return false
end


local function importFromManager (amount, slot, playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then
			for i, side in ipairs(managerSides) do
				inventoryManager.removeItemFromPlayer(side, amount, slot)
			end
			break
		end
	end
end


local function exportToManager (itemFingerprint, amount, playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then
			for i, side in ipairs(managerSides) do
				inventoryManager.addItemToPlayer(side, amount, 0, itemFingerprint)
			end
			break
		end
	end
end


local function getItems (playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then
			return inventoryManager.getItems()
		end
	end
	
	return {}
end


local function getArmor (playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then
			return inventoryManager.getArmor()
		end
	end
	
	return {}
end


local function getOffHand (playerName)
	for i, inventoryManager in ipairs(inventoryManagers) do
		if inventoryManager.getOwner() == playerName then
			return inventoryManager.getItemInOffHand()
		end
	end
	
	return {}
end


local function findMEItem (requestedItem, requestedAmount)
	local meItems = meBridge.listItems()
	
	for k,meItemData in pairs(meItems) do
		local itemDisplayName = string.lower(meItemData['displayName'])
		
		if requestedItem == itemDisplayName then return meItemData end
	end
	
	return nil
end


local function convertTable(tbl, customSNBT, isIndexed)
	
	if isIndexed then -- To preserve array order
		for i=0, #tbl+1 do
			local v = tbl[i]
			
			if type(v) == 'string' then
				customSNBT:resume()
				  :text(v)
				  :pause()
			end
			
			if type(v) == 'number' or type(v) == 'boolean' then
				customSNBT:resume()
				  :raw(v)
				  :pause()
			end
			
			if type(v) == 'table' and isArray(v) then
				customSNBT:resume()
				  :arr()
					:pause()
					  
					  convertTable(v, customSNBT, true)
					
					customSNBT:resume()
					:done()
					:pause()
			end
			
			if type(v) == 'table' and not isArray(v) then
				customSNBT:resume()
				  :tbl()
					:pause()
					  
					  convertTable(v, customSNBT)
					
					customSNBT:resume()
					:done()
					:pause()
			end
			
		end
	else
		for k,v in pairs(tbl) do
			
			if type(k) == 'string' then
				customSNBT:resume()
				  :key(k)
				  :pause()
			end
			
			if type(v) == 'string' then
				customSNBT:resume()
				  :text(v)
				  :pause()
			end
			
			if type(v) == 'number' or type(v) == 'boolean' then
				customSNBT:resume()
				  :raw(v)
				  :pause()
			end
			
			if type(v) == 'table' and isArray(v) then
				customSNBT:resume()
				  :arr()
					:pause()
					  
					  convertTable(v, customSNBT, true)
					
					customSNBT:resume()
					:done()
					:pause()
			end
			
			if type(v) == 'table' and not isArray(v) then
				customSNBT:resume()
				  :tbl()
					:pause()
					  
					  convertTable(v, customSNBT)
					
					customSNBT:resume()
					:done()
					:pause()
			end
			
		end
	end
end


local function getMeSNBT(itemData)
	if itemData['nbt'] == nil then return "\"\"" end
	
	local tags = itemData['nbt']['tag']
	if tags == nil then return "\"\"" end
	
	local customSNBT = SNBT:new()
	  :tbl()
		:pause()
		
		convertTable(tags, customSNBT)
		
		customSNBT = customSNBT:resume()
	    :done()
	  :allDone()
	
	return customSNBT
end

local function retrieveItem (requestedItem, requestedAmount, playerName)
	requestedAmount = tonumber(requestedAmount)
	
	if (requestedAmount ~= nil and requestedItem ~= nil) then -- Checks chat formatting
		local meItemData = findMEItem(string.lower(requestedItem), requestedAmount)
		
		if meItemData == nil then -- Trigger when item not found
			chat(requestedItem .. " not found!", true, playerName)
		elseif requestedAmount > meItemData['amount'] then -- Check if there is enough in the ME system
			chat('Requested ' .. requestedAmount .. ' of ' .. requestedItem .. ' but only ' .. meItemData['amount'] .. ' is available!', true, playerName)
		else
			--Sends item to player inventory
			local itemFingerprint = meItemData['fingerprint']
			meItemData['count'] = requestedAmount
			meBridge.exportItemToPeripheral(meItemData, chestName)
			exportToManager(itemFingerprint, requestedAmount, playerName)
			
			--Chat preview
			local snbt = getMeSNBT(meItemData)
			
			local jsonTbl = {{text = 'Delivered '},
						{text = '[' .. requestedAmount .. ' ' .. meItemData['displayName'] .. ']', hoverEvent =
							{action = 'show_item', contents =
								{id = meItemData['name'], count = 1, tag = snbt }}}}
			local jsonString = textutils.serializeJSON(jsonTbl, false)
			
			chatBox.sendFormattedMessage(jsonString, prefix)
			
			
			--[[ Alternative way without textutils
			chatBox.sendFormattedMessage('[{"text":"Delivered "},{"text":"[' .. requestedAmount .. ' ' .. meItemData['displayName'] ..
			  ']","hoverEvent":{"action":"show_item","contents":{"id":"' .. meItemData['name'] .. 
			  '","count":1,"tag":' .. snbt .. '}}}]', '[{"text":"ME System","color":"blue"}]')
			]]--
			
			--[[ Example on how to make custom object snbt
			local exampleSNBT = SNBT:new()
			  :tbl()
				:key('display')
				:tbl()
					:key('Name')
					:json({
						{text = '["Testing" Name]', color = 'dark_blue'},
						{text = 'aaaa', obfuscated = true}
					})
					:key('Lore')
					:arr()
						:json({text = 'Line 2', italic = true})
						:json({text = 'Line 1', color = 'red'})
						:done()
					:done()
				:done()
			  :allDone()
			]]--
			
		end
		
		sleep(0.5)
	end
end

local function getPlayerSNBT(nbt)
	
	if nbt == nil or isEmpty(nbt) then return "\"\"" end
	
	local customSNBT = SNBT:new()
	  :tbl()
		:pause()
		
		convertTable(nbt, customSNBT)
		
		customSNBT = customSNBT:resume()
	    :done()
	  :allDone()
	
	return customSNBT
end

local function clearSlot (slotNum, playerName)
	slotNum = tonumber(slotNum)
	
	if slotNum == nil then return end
	
	local item
	
	if slotNum <= 35 then
		for i, v in ipairs( getItems(playerName) ) do
			if v['slot'] == slotNum then item = v break end
		end

	elseif slotNum >= 36 and slotNum <= 39 then
		for i, v in ipairs( getArmor(playerName) ) do
			if v['slot'] - 64 == slotNum then -- Because AdvancedPeripherals is inconsistent in its implementation
				item = v
				break
			end
		end
	elseif slotNum == 40 then
		item = getOffHand(playerName)
		
	else chat(slotNum .. ' is an invalid slot number!')
	end
	
	if item == nil then return end
	
	local count = item['count'] or 0
	item['json'] = getPlayerSNBT(item['nbt'])
	item['nbt'] = nil
	importFromManager(count, slotNum, playerName)
	meBridge.importItemFromPeripheral(item, chestName)
	
	sleep(0.5)
end

local function clearItem (itemName, playerName)
	if itemName == nil then return end
	
	for i, v in ipairs( getItems(playerName) ) do
		local vName = string.match(v['displayName'], '^%s*%[(.+)%]$')
		if string.lower(vName) == string.lower(itemName) then
			importFromManager(v['count'], v['slot'], playerName)
			v['json'] = getPlayerSNBT(v['nbt'])
			v['nbt'] = nil
			meBridge.importItemFromPeripheral(v, chestName)
		end
	end
	
	for i, v in ipairs( getArmor(playerName) ) do
		local vName = string.match(v['displayName'], '^%s*%[(.+)%]$')
		if string.lower(vName) == string.lower(itemName) then
			local adjustedSlot = v['slot'] - 64
			importFromManager(v['count'], adjustedSlot, playerName)
			v['json'] = getPlayerSNBT(v['nbt'])
			v['nbt'] = nil
			meBridge.importItemFromPeripheral(v, chestName)
		end
	end
	
	local offHandItem = getOffHand(playerName)
	if offHandItem['displayName'] ~= nil then
		local offHandName = string.match(offHandItem['displayName'], '^%s*%[(.+)%]$')
		if string.lower(offHandName) == string.lower(itemName) then
			importFromManager(offHandItem['count'], 40, playerName)
			offHandItem['json'] = getPlayerSNBT(offHandItem['nbt'])
			offHandItem['nbt'] = nil
			meBridge.importItemFromPeripheral(offHandItem, chestName)
		end
	end
	
end




-- Main loop
while true do
    local e, playerName, message = os.pullEvent("chat")
    
	if isValidPlayer(playerName) then
	
		if string.match(message, '^get (%d+) (.+) pls$') then
			local requestedAmount, requestedItem = string.match(message, '^get (%d+) (.+) pls$')
			retrieveItem(requestedItem, requestedAmount, playerName)
		
		elseif string.match(message, '^clear .+ pls$') then
			
			if string.match(message, '^clear slot %d+ pls$') then
				local slotNum = string.match(message, '^clear slot (%d+) pls$')
				clearSlot(slotNum, playerName)
			
			elseif string.match(message, '^clear .+ pls$') then
				local itemName = string.match(message, '^clear (.+) pls$')
				clearItem(itemName, playerName)
			end
		
		end
	end
end

-- Slot info because the wiki is outdated
-- helmet(39) - boots(36) | 103-100 for .getArmor()
-- offhand(40)