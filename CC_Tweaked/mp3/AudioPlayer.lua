local url = ...
local AudioPlayer = {}

function AudioPlayer.playURL(dfpwmURL)
	local dfpwmURL = dfpwmURL or url
	local dfpwm = require("cc.audio.dfpwm")
	
	local speaker = peripheral.find("speaker")
	local decoder = dfpwm.make_decoder()
	local songResponse = http.get(dfpwmURL, {}, true)
	local songBinary = songResponse.readAll()
	songResponse.close()

	local pattern = string.rep('.', 16384)
	for chunk in string.gmatch(songBinary, pattern) do
		local buffer = decoder(chunk)

		while not speaker.playAudio(buffer) do
			local e = os.pullEvent()
			if e == 'songDone' then return
			elseif e == 'speaker_audio_empty' then end
		end
		
	end
end

if url ~= nil then
	AudioPlayer.playURL(url)
	os.queueEvent('songDone')
end
shell.switchTab( multishell.getCurrent() )
shell.exit()

return AudioPlayer