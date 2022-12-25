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

local files = load('return ' .. downloader('https://raw.githubusercontent.com/moo3oo3oo3/moo3oo3oo3.github.io/master/CC_Tweaked/mp3/files.lua'))()

for path, url in pairs(files) do

    local file, err = fs.open(path, "wb")
    if not file then
        printError("Failed to save \"" .. path .. " \n" .. err)
        return
    end

    file.write( downloader(url) )
    file.close()

    term.setTextColour(colors.lime)
    print("Downloaded \"" .. path .. "\"")
end

print("Please restart the device")