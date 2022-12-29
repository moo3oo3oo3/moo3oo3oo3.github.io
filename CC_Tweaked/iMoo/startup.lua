local basalt = require('basalt')
local music = require('musicPlayer')
local colony = require('colonyRecruiter')
local utils = require('iMooUtils')

local currentFocus
local focusThread
local images = {}

local mainFrame = basalt.createFrame()
	:setBackground(colors.black)

-- Header
local title = mainFrame:addLabel()
	:setPosition(6, 2)
	:setForeground(colors.white)
	:setText('Select a Program')
local subTitle = mainFrame:addLabel()
	:setPosition(2, 3)
	:setForeground(colors.yellow)
	:setText('Use scroll wheel or arrow keys to navigate')

-- Horizontal scroll
local programObjs = {}
local function selectionScroll(self, event, var)
	local dir = 0
	if event == 'mouse_scroll' then dir = var
	elseif event == 'key' and (var == keys.left or var == keys.up) then dir = -1
	elseif event == 'key' and (var == keys.right or var == keys.down) then dir = 1 end
	
	
	local maxScroll = 0
	for k,v in pairs(programObjs)do
		local x = v[1]:getX()
		local w = v[1]:getWidth()
		maxScroll = x + w > maxScroll and x + w or maxScroll
	end
	local xOffset = self:getOffset()
	local dirAdjusted = dir * 3 --Speed up scroll
	local maxScroll = maxScroll + 2  --Adjust for increased scroll speed
	if(xOffset+dirAdjusted>=0 and xOffset+dirAdjusted<=maxScroll-self:getWidth())then
		self:setOffset(xOffset+dirAdjusted, 0)
	end
	
	local closestProgram = math.ceil( utils.clamp( self:getOffset()/12, 1, #programObjs ) ) -- [1, #programObjs]
	local program = programObjs[closestProgram][2] -- Get subText
		:setFocus()
	currentFocus = program
end

-- Selection frame
local selectionFrame = mainFrame:addFrame()
	:setPosition(2, 5)
	:setSize(24, 15)
	:setBackground(colors.gray, '', colors.black)
	:onScroll(selectionScroll)
	:onKey(selectionScroll)
	:setFocus() -- Selection frame needs to be focused first for arrow key scrolling

-- Creates program image and sub text
local function newProgramObj(imgPath, subText, func, ...)
	
	local parameters = arg
	
	local startX, yPos = 3, 3
	local xPos = startX + #programObjs * 24
	
	local combinedObj = {}
	
	-- Image
	local img = selectionFrame:addImage()
		:setPosition(xPos, yPos)
		:setSize(20, 10)
		:loadImage(imgPath)
		:play(true)
	if func ~= nil then
		img
			:onClick(function()
				local frame = mainFrame:addFrame():hide()
				focusThread:stop()
				selectionFrame:hide():disable()
				func(basalt, frame, restart, parameters)
			end)
	end
	table.insert(combinedObj, img)
	table.insert(images, img)
	
	--Sub text
	local text = selectionFrame:addLabel(frame)
		:setPosition(xPos, yPos+11)
		:setSize(#subText,1)
		:setForeground(colors.white)
		:setText(subText)
		:onGetFocus(function(self)
			self:setForeground(colors.orange)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.white)
			self:setBackground(false)
		end)
	if func ~= nil then
		text
			:onClick(function()
				local frame = mainFrame:addFrame():hide()
				focusThread:stop()
				selectionFrame:hide():disable()
				func(basalt, frame, restart, parameters)
			end)
			:onKey(function(self, event, key)
				if key == keys.enter or key == keys.space then
					local frame = mainFrame:addFrame():hide()
					focusThread:stop()
					selectionFrame:hide():disable()
					func(basalt, frame, restart, parameters)
				end
			end)
	end
	table.insert(combinedObj, text)
	
	table.insert(programObjs, combinedObj)
	return combinedObj
end

-- Add programs
newProgramObj('notes.bimg', 'Music Player', music.main)
newProgramObj('colonyCompass.bimg', 'Colony Recruiter', colony.main)
newProgramObj('red_question_mark.bimg', 'Coming Soon')

-- Keep focus to allow arrow key selection
currentFocus = programObjs[1][2]
local function maintainFocus()
	while true do
		selectionFrame:setFocus() -- Ensures selectionFrame focus event fires
		currentFocus:setFocus()
		os.sleep(0.5)
	end
end
focusThread = mainFrame:addThread():start(maintainFocus)

function restart()
	basalt.setActiveFrame(selectionFrame)
	
	for i, img in ipairs(images) do img:play(true) end
	
	selectionFrame:enable():show()
	focusThread:start(maintainFocus)
end


basalt.autoUpdate()