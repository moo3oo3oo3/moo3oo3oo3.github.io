if not http then
    printError("OpenInstaller requires the http API")
    printError("Set http.enabled to true in the ComputerCraft config")
    return
end

local function downloader(url)

    local response, http_err = http.get(url, nil, true)
    if not response then
        printError("Failed to download " .. url .. " \n" .. http_err)
        return nil
    end

    local responseData = response.readAll()
    response.close()
    return responseData or ""
end

local files = textutils.unserialise(downloader('https://raw.githubusercontent.com/moo3oo3oo3/moo3oo3oo3.github.io/master/CC_Tweaked/iMoo/files.lua'))

for path, url in pairs(files) do

    local file, err = fs.open(path, "wb")
    if not file then
        printError("Failed to save \"" .. path .. " \n" .. err)
        return
    end

    file.write( downloader(url) )
    file.close()

    term.setTextColor(colors.lime)
    print("Downloaded \"" .. path .. "\"")
end

-- Basalt installation
local basaltInstaller = downloader('https://basalt.madefor.cc/install.lua')
local file, err = fs.open('basaltInstaller', "wb")
if not file then
	printError("Failed to save \"basaltInstaller.lua\"\n" .. err)
	return
end
file.write(basaltInstaller)
file.close()
shell.run('basaltInstaller', 'release', 'basalt-1.6.4.lua')
fs.delete('basaltInstaller')

term.setTextColor(colors.lime)
print("Downloaded \"Basalt\"")

print("")
term.setTextColor(colors.blue)
print("Please restart the device")