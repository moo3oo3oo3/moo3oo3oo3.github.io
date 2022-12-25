local Music = require('AudioPlayer')
local completion = require('cc.completion')

--Turns lua string table into lua table
--Allows auto-updating of song list
local songs = http.get('https://github.com/moo3oo3oo3/moo3oo3oo3.github.io/raw/master/CC_Tweaked/songDirectory.lua', nil, true).readAll()
songs.close()
local songs = {['b'] = '2', ['z'] = '26', ['c'] = '3', ['d'] = '4', ['e'] = '5', ['f'] = '6', ['g'] = '7', ['h'] = '8', ['o'] = '15', ['j'] = '10', ['k'] = '11', ['l'] = '12', ['m'] = '13', ['n'] = '14', ['i'] = '9', ['p'] = '16', ['q'] = '17', ['r'] = '18', ['s'] = '19', ['t'] = '20', ['u'] = '21', ['v'] = '22', ['w'] = '23', ['x'] = '24', ['y'] = '25', ['a'] = '1'}

local width, height = term.getSize()
local currentPage = 1

local songTitles = {} -- List of all song titles
for title, url in pairs(songs) do table.insert(songTitles, title) end
table.sort(songTitles)


--List of song titles in groups of 12
local songTitlePages = {}
local tempPage = { 'Pick a song:' }
for i, title in ipairs(songTitles) do
	
	if i%12 == 0 then
		table.insert(tempPage, 2, '') --Inserts empty entry for formatting
		table.insert(songTitlePages, tempPage)
		tempPage = { 'Pick a song:' }
	end
	
	table.insert(tempPage, title)
end
table.insert(tempPage, 2, '') --Inserts empty entry for formatting
table.insert(songTitlePages, tempPage)


local function writeCenter(arr, ...)
	local yMid = math.floor(height / 2 + .5)
	
	local content = arr or arg
	
	for i, text in ipairs(content) do
		local yAdjusted = yMid
		local halfContent = table.getn(content)/2
		if i <= halfContent then yAdjusted = yAdjusted + ( i-math.ceil(halfContent + 0.5) ) end --Push up for first half
		if i > halfContent then yAdjusted = yAdjusted + ( i-math.ceil(halfContent + 0.5) ) end --Push down for first half
		
		term.setCursorPos(math.ceil(width / 2 - #text / 2 + .5), yAdjusted)
		term.write(text)
	end
	
	term.setCursorPos(1, height)
end


local function pageManager(pages, displayedPage)
	currentPage = displayedPage
	term.clear()
	
	local page = pages[displayedPage]
	local maxPages = #pages
	writeCenter(page)
	
	--footer
	term.setCursorPos(10, 18)
	term.write('Page ' .. displayedPage)
	if displayedPage >= 1 and displayedPage < maxPages then
		term.setCursorPos(24, 18)
		term.blit('->', '00', '22')
	end
	if displayedPage > 1 and displayedPage <= maxPages then
		term.setCursorPos(2, 18)
		term.blit('<-', '00', '22')
	end
	
	term.setCursorPos(1, height)
end


pageManager(songTitlePages, currentPage)
while true do
	
	local completionChoices = {table.unpack(songTitles)}
	for i=#songTitlePages, 1, -1 do
		if i ~= currentPage then table.insert(completionChoices, 1, 'Page ' .. i) end
	end --Add page commands to auto completion
	local choice = read(nil, completionChoices, function(txt) return completion.choice(txt, completionChoices) end)
	
	local pageNum = string.match(choice, '^Page (%d+)$')
	pageNum = tonumber(pageNum)
	
	if pageNum ~= nil and pageNum >= 1 and pageNum <= #songTitlePages then
		pageManager(songTitlePages, pageNum)
	elseif songs[choice] then
		term.clear()
		term.setCursorPos(7, 10)
		writeCenter(nil, "Now playing:", choice)
		Music.playURL(songs[choice])
		pageManager(songTitlePages, currentPage)
	else
		term.setCursorPos(1, height)
		term.setTextColor(colors.blue)
		term.write("Invalid command!")
		term.setTextColor(colors.white)
		sleep(2)
		pageManager(songTitlePages, currentPage)
	end
	
end