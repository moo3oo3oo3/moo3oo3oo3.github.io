--*Config*--
--This program requires SNBT.lua

--Chest relative cardinal direction to ME Bridge
local bridgeToChest = 'south'

--Chest relative directional direction to front of Inventory Manager
local managerToChest = 'left'

--------------------------------------
-------Do not go pass this line-------
local SNBT = require("SNBT")

local chatBox = peripheral.find("chatBox")
local inventoryManager = peripheral.find("inventoryManager")
local meBridge = peripheral.find("meBridge")

if chatBox == nil then error('Chat Box not detected!') end
if inventoryManager == nil then error('Inventory Manager not detected!') end
if meBridge == nil then error('ME Bridge not detected!') end

local prefix = textutils.serializeJSON({
	{text = 'ME System', color = 'blue'}
})


function chat (msg, isGlobal, playerName)
	isGlobal = isGlobal or false
	
	if isGlobal then
		chatBox.sendMessage(msg, prefix)
	else chatBox.sendMessageToPlayer(msg, playerName, prefix) end
end


local function findMEItem (requestedItem, requestedAmount)
	local meItems = meBridge.listItems()
	
	for k,meItemData in pairs(meItems) do
		local itemDisplayName = string.lower(meItemData['displayName'])
		
		if requestedItem == itemDisplayName then return meItemData end
	end
	
	return nil
end


local function isArray (tbl)
	for k,v in pairs(tbl) do
		if type(k) == 'string' then return false end
	end
	
	return true
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

local function retrieveItem (requestedItem, requestedAmount)
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
			meBridge.exportItem(meItemData, bridgeToChest)
			inventoryManager.addItemToPlayer(managerToChest, tonumber(requestedAmount), 0, itemfingerprint)
			
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
	
	local customSNBT = SNBT:new()
	  :tbl()
		:pause()
		
		convertTable(nbt, customSNBT)
		
		customSNBT = customSNBT:resume()
	    :done()
	  :allDone()
	
	return customSNBT
end

local function clearSlot (slotNum)
	slotNum = tonumber(slotNum)
	
	if slotNum == nil then return end
	
	local item
	
	if slotNum <= 35 then
		for i, v in ipairs( inventoryManager.getItems() ) do
			if v['slot'] == slotNum then item = v break end
		end

	elseif slotNum >= 36 and slotNum <= 39 then
		for i, v in ipairs( inventoryManager.getArmor() ) do
			if v['slot'] - 64 == slotNum then -- Because AdvancedPeripherals is inconsistent in its implementation
				item = v
				break
			end
		end
	elseif slotNum == 40 then
		item = inventoryManager.getItemInOffHand()
		
	else chat(slotNum .. ' is an invalid slot number!')
	end
	
	if item == nil then return end
	
	local count = item['count'] or 0
	item['json'] = getPlayerSNBT(item['nbt'])
	item['nbt'] = nil
	inventoryManager.removeItemFromPlayer(managerToChest, count, slotNum)
	meBridge.importItem(item, bridgeToChest)
	
	sleep(0.5)
end

local function clearItem (itemName)
	if itemName == nil then return end
	
	for i, v in ipairs( inventoryManager.getItems() ) do
		local vName = string.match(v['displayName'], '^%s*%[(.+)%]$')
		if string.lower(vName) == string.lower(itemName) then
			inventoryManager.removeItemFromPlayer(managerToChest, v['count'], v['slot'])
			v['json'] = getPlayerSNBT(v['nbt'])
			v['nbt'] = nil
			meBridge.importItem(v, bridgeToChest)
		end
	end
	
	for i, v in ipairs( inventoryManager.getArmor() ) do
		local vName = string.match(v['displayName'], '^%s*%[(.+)%]$')
		if string.lower(vName) == string.lower(itemName) then
			local adjustedSlot = v['slot'] - 64
			inventoryManager.removeItemFromPlayer(managerToChest, v['count'], adjustedSlot)
			v['json'] = getPlayerSNBT(v['nbt'])
			v['nbt'] = nil
			meBridge.importItem(v, bridgeToChest)
		end
	end
	
	local offHandItem = inventoryManager.getItemInOffHand()
	if offHandItem['displayName'] ~= nil then
		local offHandName = string.match(offHandItem['displayName'], '^%s*%[(.+)%]$')
		if string.lower(offHandName) == string.lower(itemName) then
			inventoryManager.removeItemFromPlayer(managerToChest, offHandItem['count'], 40)
			offHandItem['json'] = getPlayerSNBT(offHandItem['nbt'])
			offHandItem['nbt'] = nil
			meBridge.importItem(offHandItem, bridgeToChest)
		end
	end
	
end




-- Main loop
while true do
    local e, playerName, message = os.pullEvent("chat")
    
	if string.match(message, '^get (%d+) (.+) pls$') then
		local requestedAmount, requestedItem = string.match(message, '^get (%d+) (.+) pls$')
		retrieveItem(requestedItem, requestedAmount)
	
	elseif string.match(message, '^clear .+ pls$') then
		
		if string.match(message, '^clear slot %d+ pls$') then
			local slotNum = string.match(message, '^clear slot (%d+) pls$')
			clearSlot(slotNum)
		
		elseif string.match(message, '^clear .+ pls$') then
			local itemName = string.match(message, '^clear (.+) pls$')
			clearItem(itemName)
		end
	
	end
end

-- Slot info because the wiki is outdated
-- helmet(39) - boots(36) | 103-100 for .getArmor()
-- offhand(40)