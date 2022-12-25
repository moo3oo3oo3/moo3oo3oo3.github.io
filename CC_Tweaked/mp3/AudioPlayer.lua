local AudioPlayer = {}

function AudioPlayer.playURL(dfpwmURL)
	local dfpwm = require("cc.audio.dfpwm")
	
	local speaker = peripheral.find("speaker")
	local decoder = dfpwm.make_decoder()
	local songResponse = http.get(dfpwmURL, {}, true)
	songBinary.close()
	local songBinary = songResponse.readAll()

	local pattern = string.rep('.', 16384)
	for chunk in string.gmatch(songBinary, pattern) do
		local buffer = decoder(chunk)

		while not speaker.playAudio(buffer) do
			os.pullEvent("speaker_audio_empty")
		end
		
	end
end

return AudioPlayer