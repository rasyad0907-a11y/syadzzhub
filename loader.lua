local URL = "https://raw.githubusercontent.com/rasyad0907-a11y/syadzzhub/main/main.lua"

local source = game:HttpGet(URL)
local run = loadstring(source)

if not run then
    error("main.lua gagal dimuat")
end

run()
