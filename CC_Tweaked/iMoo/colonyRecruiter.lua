local utils = require('iMooUtils')
local colonyIntegrator

local colonyRecruiter = {}

local basalt
local colonyFrame
local homeRestart

local startFrame
local editorFrame
local notificationListFrame

local searchList

local notificationList = {}
local trackedVisitor
local trackingLabel

local isEditorOpen = false
local isNotificationOpen = false

local skills = {
	'Athletics', 'Dexterity', 'Strength', 'Agility', 'Stamina', 'Mana',
	'Adaptability', 'Focus', 'Creativity', 'Knowledge', 'Intelligence'
}

local function exitColony()
	homeRestart()
	colonyFrame:remove()
	basalt = nil
	colonyFrame = nil
	notificationList = {}
	trackedVisitor = nil
	trackingLabel = nil
end

local function addExit(frame)
	local exitButton = frame:addLabel()
		:setPosition(25, 1)
		:setForeground(colors.red)
		:setText('X')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.red)
			self:setBackground(false)
		end)
		:onClick(function(self, event, btn)
			if btn == 1 then exitColony() end
		end)
end

local function getData()
	if fs.exists('colonyRecruiterData.lua') then
		local file = fs.open('colonyRecruiterData.lua', 'rb')
		local contents = file.readAll()
		file.close()
		local savedData = textutils.unserialise(contents)
		return savedData
	else
		local file = fs.open('colonyRecruiterData.lua', 'w')
		file.write('{}')
		file.close()
		return {}
	end
end

local function writeData(data, index)
	local existingData = getData()
	
	if index == nil or index < 1 or index > #existingData+1 then
		index = #existingData+1
	end
	
	table.remove(existingData, index)
	table.insert(existingData, index, data)
	
	local file = fs.open('colonyRecruiterData.lua', 'wb')
	file.write( textutils.serialise(existingData ))
	file.close()
	
	updateSearchList()
end

local function removeData(index)
	local existingData = getData()
	
	table.remove(existingData, index)
	
	local file = fs.open('colonyRecruiterData.lua', 'wb')
	file.write( textutils.serialise(existingData ))
	file.close()
	
	updateSearchList()
end

function updateSearchList()
	local data = getData()
	searchList:clear()
	
	for i, v in ipairs(data) do
		searchList:addItem(v['Name'], nil, nil, v)
	end
end

local function openPane(pane, direction)
	if isEditorOpen or isNotificationOpen then return end
	
	startFrame:disable()
	
	local anim = colonyFrame:addAnimation()
		:setObject(pane)
		
	if direction == 'left' then anim:move(4, 3, 1) end
	if direction == 'right' then anim:move(1, 3, 1) end
	
	anim:play()
end

local function closePane(pane, direction)
	startFrame:enable()
	
	local anim = colonyFrame:addAnimation()
		:setObject(pane)
		
	if direction == 'left' then anim:move(-21, 3, 1) end
	if direction == 'right' then anim:move(26, 3, 1) end
	
	anim:play()
end



local function loadEditor(searchFrame, data, index)
	
	-- Delete old editor frame every time it is called
	if editorFrame ~= nil then
		editorFrame:remove()
		editorFrame = nil
	end
	
	editorFrame = searchFrame:addFrame()
		:setPosition(2, 1)
		:setSize(22, 16)
		:setBackground(false)
		:setScrollable(true)
	
	local searchName = editorFrame:addLabel()
		:setPosition(2, 2)
		:setText('Name')
		
	local searchNameInput = editorFrame:addInput()
		:setPosition(2, 3)
		:setSize(20, 1)
		:setInputLimit(20)
		
		if data and data['Name'] ~= nil then
			searchNameInput:setValue( data['Name'] )
		end
	
	
	for i, skill in ipairs(skills) do
		local checkbox = editorFrame:addCheckbox(skill .. 'Checkbox')
			:setPosition(2, 2 + 3*i)
			
			if data and data[skill] then checkbox:setValue(true) end
		
		local skillName = editorFrame:addLabel()
			:setPosition(4, 2 + 3*i)
			:setSize(12, 1)
			:setText(skill)
			
		local greaterThan = editorFrame:addLabel()
			:setPosition(2, 3 + 3*i)
			:setSize(2, 1)
			:setText('>=')
			
		local targetSkillLevel = editorFrame:addInput(skill .. 'TargetLevel')
			:setPosition(5, 3 + 3*i)
			:setSize(3, 1)
			:setInputType('number')
			:setInputLimit(2)
		
			if data and data[skill] then
				targetSkillLevel:setValue( data[skill] )
			end
			
	end
	
	local submitButton = editorFrame:addButton()
		:setPosition(2, 3 + 3*#skills + 2)
		:setSize(20, 3)
		:setText('Save')
	submitButton	
		:onClick(basalt.schedule(function(self, event, btn)
			
			if btn ~= 1 then return end
			
			local newData = {}
			
			if searchNameInput:getValue() == '' then
				searchNameInput:setBackground(colors.red)
				submitButton:setBackground(colors.red)
				sleep(0.05)
				submitButton:setPosition(3, 3 + 3*#skills + 2)
				sleep(0.05)
				submitButton:setPosition(2, 3 + 3*#skills + 2)
				sleep(0.05)
				submitButton:setPosition(1, 3 + 3*#skills + 2)
				sleep(0.05)
				submitButton:setPosition(2, 3 + 3*#skills + 2)
				submitButton:setBackground(colors.lightGray)
				return
			end
				
			newData['Name'] = searchNameInput:getValue()
			if index == nil then searchNameInput:setValue('') end
			
			for i, skill in ipairs(skills) do
				local isSkillTracked = editorFrame:getObject(skill .. 'Checkbox'):getValue()
				local skillTargetLevel = editorFrame:getObject(skill .. 'TargetLevel'):getValue()
				
				if isSkillTracked and skillTargetLevel ~= '' then
					newData[skill] = skillTargetLevel
				end
				
				if index == nil then
					editorFrame:getObject(skill .. 'Checkbox'):setValue(false)
					editorFrame:getObject(skill .. 'TargetLevel'):setValue('')
				end
			end
			
			local scrollTopAnimation = editorFrame:addAnimation()
				:setObject(editorFrame)
				:offset(0, 0, 1)
				:play()
				
			searchNameInput:setBackground(colors.lightGray)
			
			writeData(newData, index)
			
		end))
		
end


local function updateLocation()	
	while true do
		if trackingLabel == nil or trackedVisitor == nil then break end
		
		local visitors = colonyIntegrator.getVisitors()
		for i, visitor in ipairs(visitors) do
			
			if visitor['id'] == trackedVisitor then
				local location = visitor['location']
				if location.x == 0 and location.y == 0 and location.z == 0 then
					location = {x='?', y='?', z='?'}
				end
				trackingLabel
					:setText('[' .. location.x .. ', ' .. location.y .. 
							', ' .. location.z .. ']')
			end
		end
		
		os.sleep(10)
	end
end


local function trackingPage(searchName, visitorData, x, y)
	local trackingFrame = colonyFrame:addFrame()
		:setPosition(x, y)
		:setSize(20, 3)
		:setBackground(colors.lime)
	
		local anim = trackingFrame:addAnimation()
			:setObject(trackingFrame)
			:size(26, 20, 1)
			:move(1, 1, 1)
			:play()
		
		local backButton = trackingFrame:addLabel()
			:setPosition(1, 1)
			:setForeground(colors.cyan)
			:setText('<-')
		backButton
			:onClick(function(self, event, btn)
				if btn ~= 1 then return end
				trackingFrame:remove()
				trackingFrame = nil
				trackedVisitor = nil
				trackingLabel = nil
				notificationListFrame:enable()
			end)
		
		local title = trackingFrame:addLabel()
			:setPosition( (26-#searchName+1)/2 + 1 , 2 )
			:setBackground(colors.white)
			:setText(searchName)
		
		local saturationText = 'Saturation: ' .. utils.round(visitorData['saturation'], 0.1)
		local saturation = trackingFrame:addLabel()
			:setPosition( (26-#saturationText+1)/2 + 1 , 3 )
			:setText(saturationText)
			
		for i, skill in ipairs(skills) do
			local skillLabel = trackingFrame:addLabel()
				:setPosition(2, 4 + i)
				:setForeground(colors.gray)
				:setText(skill .. ': ' .. visitorData['skills'][skill]['level'])
		end
		
		local position = trackingFrame:addLabel()
			:setPosition(2, 17)
			:setForeground(colors.white)
			:setBackground(colors.black)
				
		local cost = trackingFrame:addLabel()
			:setPosition(2 , 19)
			:setText('Cost: ' .. string.gsub( string.match(visitorData['recruitCost'], '.+:(.+)'), '_', ' ' ) )
	
	trackedVisitor = visitorData['id']
	trackingLabel = position
	trackingFrame:addThread():start(updateLocation)
	
end


local function createNotification(searchName, visitorData)
	local saturationAmount = utils.round(visitorData['saturation'], 0.1)
	local recruitCost = string.gsub( string.match(visitorData['recruitCost'], '.+:(.+)'), '_', ' ' )
	
	local notification = notificationListFrame:addFrame()
		:setPosition(2, 2 + #notificationList*4)
		:setSize(20, 3)
		:setBackground(false)
	notification
		:onClick(function(self, event, btn)
			
			if btn ~= 1 then return end
			local notificationX, notificationY = notification:getAbsolutePosition()
			notificationListFrame:disable()
			trackingPage(searchName, visitorData, notificationX, notificationY)
			
		end)
	
		local title = notification:addLabel()
			:setPosition(1, 1)
			:setSize(20, 1)
			:setText(searchName)
		
		local saturation = notification:addLabel()
			:setPosition(1, 2)
			:setSize(16, 1)
			:setForeground(colors.gray)
			:setText( 'Saturation: ' .. saturationAmount )
		
		local cost = notification:addLabel()
			:setPosition(1, 3)
			:setSize(20, 1)
			:setForeground(colors.gray)
			:setText(recruitCost)
	
	table.insert(notificationList, notification)
end


local function scanVisitors()
	while true do
		if colonyIntegrator ~= nil then
			notificationList = {}
			local searches = getData()
			local visitors = colonyIntegrator.getVisitors()
			
			for i, search in ipairs(searches) do
				
				local potentialCitizens = {}
				local failedCitizens = {}
				
				for searchedSkill, searchedSkillValue in pairs(search) do
					
					if searchedSkill ~= 'Name' then
						
						for j, visitor in ipairs(visitors) do
							
							local id = visitor['id']
							
							if failedCitizens[id] == nil then
								if visitor['skills'][searchedSkill]['level'] >= searchedSkillValue then
									potentialCitizens[id] = visitor
								else
									potentialCitizens[id] = nil
									failedCitizens[id] = ''
								end
							end
							
						end
					end
					
				end
				
				for id, visitorData in pairs(potentialCitizens) do
					createNotification(search['Name'], visitorData)
				end
				
			end
		end
		
		sleep(30)
	end
end


local function startPage()
	
	-- Searching page
	startFrame = colonyFrame:addFrame()
		:setPosition(1, 1)
		:setSize(26, 20)
		:setBackground(colors.brown)
		
		local title = startFrame:addLabel()
			:setPosition(7, 2)
			:setText('Create Search')
		
		searchList = startFrame:addList()
			:setPosition(3, 4)
			:setSize(22, 12)
			:setScrollable(true)
			:setSelectedItem(colors.gray, colors.lightGray)
		updateSearchList()
		
		local addingButton = startFrame:addButton()
			:setPosition(3, 17)
			:setSize(10, 3)
			:setText('Add')
		
		local deleteButton = startFrame:addButton()
			:setPosition(15, 17)
			:setSize(10, 3)
			:setText('Delete')
		
		addExit(startFrame)
	
	-- Editor pane
	local searchFrame = colonyFrame:addFrame()
		:setPosition(26, 3)
		:setSize(23, 16)
		:setBackground(colors.lightBlue)
		
		local searchPane = searchFrame:addPane()
			:setPosition(1, 1)
			:setSize(1, 16)
			:setBackground(colors.blue)
			:onClick(function(self, event, btn)
				if btn ~= 1 then return end
				
				if isEditorOpen then
					closePane(searchFrame, 'right')
					isEditorOpen = false
				else
					openPane(searchFrame, 'left')
					isEditorOpen = true
				end
			end)
			
	-- Notification pane
	local notificationFrame = colonyFrame:addFrame()
		:setPosition(-21, 3)
		:setSize(23, 16)
		:setBackground(colors.lime)
		
		local notificationPane = notificationFrame:addPane()
			:setPosition(23, 1)
			:setSize(1, 16)
			:setBackground(colors.green)
			:onClick(function(self, event, btn)
				if btn ~= 1 then return end
				
				if isNotificationOpen then
					closePane(notificationFrame, 'left')
					isNotificationOpen = false
				else
					openPane(notificationFrame, 'right')
					isNotificationOpen = true
				end
			end)
			
			notificationListFrame = notificationFrame:addFrame()
				:setPosition(1, 1)
				:setSize(20, 16)
				:setBackground(false)
				:setScrollable(true)
	
	
	addingButton
		:onClick(function(self, event, btn)
			if btn ~= 1 then return end
			openPane(searchFrame, 'left')
			isEditorOpen = true
			loadEditor(searchFrame)
		end)
	
	searchList
		:onRelease(function(self, event, btn)
			if btn ~= 1 then return end
			local index = self:getItemIndex()
			if index == nil then return end
			local selectedItem = self:getItem( index )
			local data = selectedItem['args'][1]
			loadEditor(searchFrame, data, index)
			openPane(searchFrame, 'left')
		end)
		
	deleteButton
		:onClick(function(self, event, btn)
			if btn ~= 1 then return end
			
			removeData( searchList:getItemIndex() )
		end)
		
	
	local thread = colonyFrame:addThread()
		:start(scanVisitors)
	
end


local function checkIntegrator()
	
	colonyIntegrator = peripheral.find('colonyIntegrator')
	if colonyIntegrator ~= nil then
		basalt.setActiveFrame(colonyFrame)
		startPage()
	return end
	
	local errorFrame = colonyFrame:addFrame()
		:setPosition(1, 1)
		:setSize(26, 20)
		:setBackground(colors.black)
		:setFocus()
	basalt.setActiveFrame(errorFrame)
	
		local errorMessage = errorFrame:addLabel()
			:setPosition(1, 1)
			:setForeground(colors.lightGray)
			:setText('Colony Integrator not detected. Put one in your inventory!')
			
		local continueMessage = errorFrame:addLabel()
			:setPosition(1, 20)
			:setForeground(colors.yellow)
			:setText('Press any key to continue')
		
	errorFrame
		:onKey(function()
			pocket.equipBack()
			colonyIntegrator = peripheral.find('colonyIntegrator')
			
			if colonyIntegrator ~= nil then
				errorFrame:remove()
				errorFrame = nil
				basalt.setActiveFrame(colonyFrame)
				startPage()
			end
			
		end)
end


function colonyRecruiter.main(basaltInstance, frame, restart, ...)
	
	basalt = basaltInstance
	colonyFrame = frame
	homeRestart = restart
	
	colonyFrame
		:setPosition(1,1)
		:setSize(26, 20)
		:setTheme({
			FrameBG = colors.brown,
			ButtonBG = colors.lightGray,
			BasaltBG = colors.lightGray,
			ButtonText = colors.black,
			CheckboxBG = colors.lightGray,
			CheckboxText = colors.white,
			InputBG = colors.lightGray,
			InputText = colors.black,
			ListBG = colors.white,
			ListText = colors.gray,
			DropdownBG = colors.lightGray,
			DropdownText = colors.black,
			LabelBG = false,
			LabelText = colors.black
		})
		:show()
	
	checkIntegrator()
end

return colonyRecruiter