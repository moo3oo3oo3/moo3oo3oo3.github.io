local url = url

function playURL(dfpwmURL)
	local dfpwmURL = dfpwmURL or url
	local dfpwm = require("cc.audio.dfpwm")
	
	local speaker = peripheral.find("speaker")
	local decoder = dfpwm.make_decoder()
	local songResponse = http.get(dfpwmURL, {}, true)
	local songBinary = songResponse.readAll()
	songResponse.close()

	local pattern = string.rep('.', 2048)
	for chunk in string.gmatch(songBinary, pattern) do
		local buffer = decoder(chunk)

		while not speaker.playAudio(buffer) do
			
			local e = os.pullEvent()
			if e == 'speaker_audio_empty' then end
			
		end
		
	end
end

playURL(url)