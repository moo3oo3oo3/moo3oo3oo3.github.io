local completion = require('cc.completion')
local utils = require('iMooUtils')
local speaker = peripheral.find('speaker')

if speaker == nil then error('Speaker not detected!') end

local musicPlayer = {}

local basalt
local currentFocus
local currentFrame
local musicFrame
local homeRestart

local menuItems = {}
local menuIndex = 1


local customSongs
local songs
local songTitles -- List of all song titles
local function updateSongs()
	customSongs = {}
	songs = {}
	songTitles = {}
	
	local songsResponse = http.get('https://raw.githubusercontent.com/moo3oo3oo3/moo3oo3oo3.github.io/master/CC_Tweaked/iMoo/songDirectory.lua', nil, true)
	songs = textutils.unserialise(songsResponse.readAll())
	songsResponse.close()
	--[[
	local songs = {['b'] = '2', ['z'] = '26', ['c'] = '3',
	['d'] = '4', ['e'] = '5', ['f'] = '6', ['g'] = '7', ['h'] = '8',
	['o'] = '15', ['j'] = '10', ['k'] = '11', ['l'] = '12', ['m'] = '13',
	['n'] = '14', ['i'] = '9', ['p'] = '16', ['q'] = '17', ['r'] = '18',
	['s'] = '19', ['t'] = '20', ['u'] = '21', ['v'] = '22', ['w'] = '23',
	['x'] = '24', ['y'] = '25', ['a'] = '1', ['really Long String Goes Here'] = '27'}
	]]--


	if fs.exists('customSongList.lua') then
		local file = fs.open('customSongList.lua', 'rb')
		local contents = textutils.unserialise(file.readAll())
		file.close()
		customSongs = contents
		
		for k,v in pairs(contents) do --Appends custom song tbl to songs tbl
			songs[k] = v
		end
	else
		local file = fs.open('customSongList.lua', 'wb')
		file.write( textutils.serialise( {} ))
		file.close()
		customSongs = {}
	end

	for title, url in pairs(songs) do table.insert(songTitles, title) end
	table.sort(songTitles)
end
updateSongs()


local function closeFrame(frame)
	menuItems = {}
	currentFrame = nil
	currentFocus = nil
	if frame ~= nil then
		frame:remove()
		frame = nil
	end
end

local function exitMusic()
	menuItems = nil
	menuIndex = nil
	homeRestart()
	musicFrame:remove()
	basalt = nil
	currentFocus = nil
	currentFrame = nil
	musicFrame = nil
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
		:onClick( function() exitMusic() end )
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then exitMusic() end
		end)
	table.insert(menuItems, 1, exitButton)
end

local function addBack(frame)
	local backButton = frame:addLabel()
		:setPosition(1, 1)
		:setForeground(colors.cyan)
		:setText('<-')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.cyan)
			self:setBackground(false)
		end)
		:onClick(function() startPage(frame) end)
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then startPage(frame) end
		end)
	table.insert(menuItems, 1, backButton)
end

local function playSong(songTitle)
	local songURL = songs[songTitle]
	
	if songURL ~= nil then
		local program = musicFrame:addProgram()
		program
			:setEnviroment({url = songURL})
			:execute('audioPlayer')
		
		playingPage(songTitle, program)
	end
	
end

local function saveCustomSong()
	local file = fs.open('customSongList.lua', 'wb')
	file.write( textutils.serialise(customSongs) )
	file.close()
end

local function cleanURL(urlLines)
	local url = ''
	for i,v in ipairs(urlLines) do
		url = url .. v
	end
	
	return string.gsub(url, '%s', '')
end

local function openEditor(listItem, editFrame)
	closeFrame(editFrame)
	
	local songName = listItem['args'][2]
	local songLink = customSongs[songName]
	
	local editorFrame = musicFrame:addFrame()
		:setPosition(1, 1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:setFocus()
	
	local songTitle = editorFrame:addLabel()
		:setPosition(2, 2)
		:setForeground(colors.white)
		:setText('Song Title:')
	
	local titleInput = editorFrame:addInput()
		:setPosition(2, 3)
		:setSize(24, 1)
		:setBackground(colors.lightGray)
		:setValue(songName)
	
	local songURL = editorFrame:addLabel()
		:setPosition(2, 5)
		:setForeground(colors.white)
		:setText('.dfpwn URL:')
	
	local urlInput = editorFrame:addTextfield()
		:setPosition(2, 6)
		:setSize(24, 6)
		:setBackground(colors.lightGray)
		:editLine(1, songLink)
		
	local cancelButton = editorFrame:addButton()
		:setPosition(2,14)
		:setSize(8, 3)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setText('Cancel')
	cancelButton
		:onClick(function(self)
			editPage(editorFrame)
		end)
	
	local deleteButton = editorFrame:addButton()
		:setPosition(18,14)
		:setSize(8, 3)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setText('Delete')
	deleteButton
		:onClick(function(self)
			customSongs[songName] = nil
			saveCustomSong()
			editPage(editorFrame)
		end)
	
	local errorLine = editorFrame:addLabel()
		:setPosition(2, 18)
		:setSize(24, 2)
		:setBackground(colors.white)
		:setForeground(colors.red)
		:setText('')
	
	local okButton = editorFrame:addButton()
		:setPosition(12,14)
		:setSize(4, 3)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setText('OK')
	okButton
		:onClick(function(self)
			local title = titleInput:getValue()
			local url = cleanURL(urlInput:getLines())
			if songs[title] ~= nil and title ~= songName then
				errorLine:setText('Song title already exists!')
				return
			end
			if string.match(title, '^%s+$') or string.match(url, '^%s+$')
			or title == "" or url == "" then
				errorLine:setText('Input(s) are empty!')
				return
			end
			
			customSongs[titleInput:getValue()] = url
			saveCustomSong()
			editPage(editFrame)
		end)
	
end

local function openAdder(songList, editFrame)
	closeFrame(editFrame)
	
	local adderFrame = musicFrame:addFrame()
		:setPosition(1, 1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:setFocus()
	
	local songTitle = adderFrame:addLabel()
		:setPosition(2, 2)
		:setForeground(colors.white)
		:setText('Song Title:')
	
	local titleInput = adderFrame:addInput()
		:setPosition(2, 3)
		:setSize(24, 1)
		:setBackground(colors.lightGray)
		:setFocus()
	
	local songURL = adderFrame:addLabel()
		:setPosition(2, 5)
		:setForeground(colors.white)
		:setText('.dfpwn URL:')
	
	local urlInput = adderFrame:addTextfield()
		:setPosition(2, 6)
		:setSize(24, 6)
		:setBackground(colors.lightGray)
		
	local cancelButton = adderFrame:addButton()
		:setPosition(2,14)
		:setSize(10, 3)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setText('Cancel')
	cancelButton
		:onClick(function(self)
			editPage(adderFrame)
		end)
	
	local errorLine = adderFrame:addLabel()
		:setPosition(2, 18)
		:setSize(24, 2)
		:setBackground(colors.white)
		:setForeground(colors.red)
		:setText('')
	
	local okButton = adderFrame:addButton()
		:setPosition(16,14)
		:setSize(10, 3)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setText('OK')
	okButton
		:onClick(function(self)
			local title = titleInput:getValue()
			local url = cleanURL(urlInput:getLines())
			if songs[title] ~= nil then
				errorLine:setText('Song title already exists!')
				return
			end
			if string.match(title, '^%s+$') or string.match(url, '^%s+$')
			or title == "" or url == "" then
				errorLine:setText('Input(s) are empty!')
				return
			end
			
			customSongs[titleInput:getValue()] = url
			saveCustomSong()
			editPage(adderFrame)
		end)
	
end

function playingPage(songTitle, program)
	local previousPage = currentFrame:disable():hide() -- Inactivates playFrame
	closeFrame()
	
	updateSongs()
	
	local playingFrame = musicFrame:addFrame()
		:setPosition(1, 1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:show()
	addExit(playingFrame)
	currentFrame = playingFrame
	
	local title = playingFrame:addLabel()
		:setPosition(2, 5)
		:setForeground(colors.white)
		:setText('Now Playing:')
	
	local songName = playingFrame:addLabel()
		:setPosition( 2, 6 )
		:setForeground(colors.white)
		:setBackground(colors.red)
		:setText(songTitle)
	
	local pauseButton = playingFrame:addButton()
		:setPosition(2, 15)
		:setSize(11, 3)
		:setBackground(colors.lightGray)
		:setText('Pause')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.black)
			self:setBackground(colors.lightGray)
		end)
	pauseButton
		:setFocus()
		:onClick(function()
			
			if program:isPaused() then
				pauseButton:setText('Pause') 
				program:pause(false)
			else
				pauseButton:setText('Resume')
				program:pause(true)
			end
			
		end)
		:onKey(function(self, event, key)
				if key == keys.enter or key == keys.space then
					if program:isPaused() then
					pauseButton:setText('Pause') 
					program:pause(false)
				else
					pauseButton:setText('Resume')
					program:pause(true)
				end
			end
		end)
	currentFocus = pauseButton
	table.insert(menuItems, pauseButton)
	menuIndex = 2
		
	local stopButton = playingFrame:addButton()
		:setPosition(16, 15)
		:setSize(10, 3)
		:setBackground(colors.lightGray)
		:setText('Stop')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.black)
			self:setBackground(colors.lightGray)
		end)
		:onClick(function()
			program:stop()
			program = nil
			previousPage:show():enable()
			playPage(playingFrame)
		end)
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then
				program:stop()
				program = nil
				previousPage:show():enable()
				playPage(playingFrame)
			end
		end)
	table.insert(menuItems, stopButton)
	
	program:onDone(function(self)
		self = nil
		previousPage:show():enable()
		playPage(playingFrame)
	end)
	
end

function playPage(previousPage)
	closeFrame(previousPage)
	
	local playFrame = musicFrame:addFrame()
		:setPosition(1,1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:show()
	
	addExit(playFrame)
	addBack(playFrame)
	currentFrame = playFrame
	menuIndex = 3
	
	local title = playFrame:addLabel()
		:setPosition(6, 3)
		:setForeground(colors.white)
		:setText('Choose a song:')
	
	local songList = playFrame:addList()
		:setPosition(2, 4)
		:setSize(24,16)
		:setForeground(colors.black)
		:setBackground(colors.lightGray)
		:setScrollable(true)
	currentFocus = songList
	songList
		:setSelectedItem(colors.brown, colors.yellow)		
		:onChange(function(self)
			if self:getValue()['args'] ~= nil then
				menuIndex = self:getValue()['args'][1] + 2 --List item 1 is menuIndex 3 due to back and exit buttons
				currentFocus = self
				playSong( self:getValue()['args'][2] )
			end
		end)
		:onClick(function(self)
			playSong( self:getValue()['args'][2] )
		end)
		:onKey(function(self, event, key)
			if key == keys.up or key == keys.down or key == keys.right or key == keys.left then
				songList:selectItem( menuIndex-2 )
				
				-- Auto scroll if selecting outside of view
				local offset = self:getOffset()
				local topVisible = utils.clamp(offset + 3, 3, #menuItems)
				local bottomVisible = utils.clamp(offset + 18, 3, #menuItems)
				if menuIndex >= 3 and menuIndex > bottomVisible then				
					songList:setOffset( menuIndex - 18 )
				elseif menuIndex >= 3 and menuIndex < topVisible then
					songList:setOffset( menuIndex - 3 )
				end
				
			end
			if key == keys.enter or key == keys.space then
				if self:getValue() ~= nil then
					playSong( self:getValue()['args'][2] )
				end
			end
		end)
		:setFocus()
		:onLoseFocus(function(self) self:setSelectedItem(colors.lightGray, colors.black) end)
		:onGetFocus(function(self)  self:setSelectedItem(colors.brown, colors.yellow) end)
	
	for i, songTitle in ipairs(songTitles) do
		local shownTitle = songTitle
		
		if string.len(shownTitle) > 24 then
			shownTitle = string.sub(shownTitle, 1, 21) .. '...'
		end
		
		songList:addItem(shownTitle, nil, nil, i, songTitle)
		table.insert(menuItems, songList)
	end
	
end

function editPage(previousPage)
	closeFrame(previousPage)
	
	updateSongs()
	
	local editFrame = musicFrame:addFrame()
		:setPosition(1,1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:show()
	
	addExit(editFrame)
	addBack(editFrame)
	currentFrame = editFrame
	menuIndex = 3
	
	local title = editFrame:addLabel()
		:setPosition(9, 2)
		:setForeground(colors.white)
		:setText('Edit Songs:')
	
	local songList = editFrame:addList()
		:setPosition(2, 4)
		:setSize(24,13)
		:setForeground(colors.black)
		:setBackground(colors.lightGray)
		:setScrollable(true)
	currentFocus = songList
	songList
		:setSelectedItem(colors.brown, colors.yellow)
		:onChange(function(self)
			if self:getValue()['args'] ~= nil then
				menuIndex = self:getValue()['args'][1] + 2 --List item 1 is menuIndex 3 due to back and exit buttons
				currentFocus = self
				local index = self:getItemIndex()
				openEditor( self:getItem( index ), editFrame )
			end
		end)
		:onClick(function(self)
			local index = self:getItemIndex()
			if index ~= nil then
				openEditor( self:getItem( index ), editFrame )
			end
		end)
		:onKey(function(self, event, key)
			if key == keys.up or key == keys.down or key == keys.left or key == keys.right then
				songList:selectItem( menuIndex-2 )
				
				-- Auto scroll if selecting outside of view
				local offset = self:getOffset()
				local topVisible = utils.clamp(offset + 3, 3, #menuItems-1) -- Minus 1 due to add button being last
				local bottomVisible = utils.clamp(offset + 18, 3, #menuItems-1)
				if menuIndex >= 3 and menuIndex > bottomVisible then				
					songList:setOffset( menuIndex - 18 )
				elseif menuIndex >= 3 and menuIndex < topVisible then
					songList:setOffset( menuIndex - 3 )
				end
				
			end
			if key == keys.enter or key == keys.space then
				local index = self:getItemIndex()
				if index ~= nil then
					openEditor( self:getItem( index ), editFrame )
				end
			end
		end)
		:setFocus()
		:onLoseFocus(function(self) self:setSelectedItem(colors.lightGray, colors.black) end)
		:onGetFocus(function(self)  self:setSelectedItem(colors.brown, colors.yellow) end)
	
	local i = 1
	for songTitle, url in pairs(customSongs) do
		local shownTitle = songTitle
		
		if string.len(shownTitle) > 24 then
			shownTitle = string.sub(shownTitle, 1, 21) .. '...'
		end
		
		songList:addItem(shownTitle, nil, nil, i, songTitle)
		table.insert(menuItems, songList)
		
		i = i + 1
	end
	
	local addButton = editFrame:addButton()
		:setPosition(2, 18)
		:setSize(24, 3)
		:setBackground(colors.lightGray)
		:setText('Add Songs')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.black)
			self:setBackground(colors.lightGray)
		end)
	addButton
		:onClick(function()
			openAdder(songList, editFrame)
		end)
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then
				openAdder(songList, editFrame)
			end
		end)
	table.insert(menuItems, addButton)
	
end

function startPage(previousPage)
	closeFrame(previousPage)
	
	local startFrame = musicFrame:addFrame()
		:setPosition(1,1)
		:setSize(26, 20)
		:setBackground(colors.gray)
		:show()
		
	addExit(startFrame)
	currentFrame = startFrame
	
	local title = startFrame:addLabel()
		:setPosition(8, 3)
		:setForeground(colors.white)
		:setText('Music Player')
	
	local playButton = startFrame:addButton()
		:setPosition(2, 7)
		:setSize(24, 5)
		:setBackground(colors.lightGray)
		:setText('Play Songs')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.black)
			self:setBackground(colors.lightGray)
		end)
	playButton
		:setFocus()
		:onClick(function()
			playPage(playFrame)
		end)
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then
				playPage(playFrame)
			end
		end)
	currentFocus = playButton
	table.insert(menuItems, playButton)
	menuIndex = 2
		
	local editButton = startFrame:addButton()
		:setPosition(2, 14)
		:setSize(24, 5)
		:setBackground(colors.lightGray)
		:setText('Edit Songs')
		:onGetFocus(function(self)
			self:setForeground(colors.yellow)
			self:setBackground(colors.brown)
		end)
		:onLoseFocus(function(self)
			self:setForeground(colors.black)
			self:setBackground(colors.lightGray)
		end)
		:onClick(function()
			editPage(startFrame)
		end)
		:onKey(function(self, event, key)
			if key == keys.enter or key == keys.space then
				editPage(startFrame)
			end
		end)
	table.insert(menuItems, editButton)
end

local function maintainFocus()
	while true do
		if currentFocus ~= nil then
			currentFrame:setFocus()
			currentFocus:setFocus()
		end
		os.sleep(0.5)
	end
end

function musicPlayer.main(basaltInstance, frame, restart, ...)
	basalt = basaltInstance
	musicFrame = frame
	homeRestart = restart
	
	musicFrame
		:setPosition(1,1)
		:setSize(26, 20)
		:show()
		:addThread():start(maintainFocus)
	musicFrame
		:onKey(function(self, event, key)
			if #menuItems ~= 0 then
				if key == keys.up or key == keys.left then
					local index = utils.loopClamp(menuIndex - 1, 1, #menuItems)
					basalt.debug(index, #menuItems)
					local obj = menuItems[index]:setFocus()
					currentFocus = obj
					menuIndex = index
				elseif key == keys.down or key == keys.right then
					local index = utils.loopClamp(menuIndex + 1, 1, #menuItems)
					basalt.debug(index, #menuItems)
					local obj = menuItems[index]:setFocus()
					currentFocus = obj
					menuIndex = index
				end
			end
		end)
		:setFocus()
	
	startPage()
end

return musicPlayer