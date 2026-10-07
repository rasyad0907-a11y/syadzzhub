local URL = "https://raw.githubusercontent.com/rasyad0907-a11y/SYADZZ-HUB/main/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok then
    error("Gagal mengambil main.lua: " .. tostring(source))
end

local fn, err = loadstring(source)

if not fn then
    error("Gagal menjalankan main.lua: " .. tostring(err))
end

fn()
