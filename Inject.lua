function script()
    if game.PlaceId == 10704789056 then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Varomine/obfuscate/main/Drive%20World.lua"))()
    elseif game.PlaceId == 3351674303 then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Varomine/obfuscate/main/Driving%20empire.lua"))()
    end
end

if not _G.Execute then 
    script()
    _G.Execute = true
end