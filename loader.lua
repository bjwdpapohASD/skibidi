-- https://discord.gg/tUEJZYvF9d
-- known to work on wave, nihon, awp.gg, syn z, seliware
local environment = identifyexecutor and identifyexecutor()
local source = game:HttpGet("https://raw.githubusercontent.com/iRay888/wapus/refs/heads/main/source.lua")

if getfflag and getfflag("DebugRunParallelLuaOnMainThread") == "True" and not executed then
    loadstring(source)()
elseif environment == "Wave" and not executed then
    run_on_actor(getdeletedactors()[1], source)
elseif environment == "Nihon" and not executed then
    for _, actor in getactorthreads() do
        run_on_thread(actor, [[
            for _, func in getgc(false) do
                if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.find(debug.getinfo(func).source, "ClientLoader") then
                    ]] .. source .. [[
                    break
                end
            end
        ]])
    end
else
    queue_on_teleport("task.wait(5);" .. source)
    setfflag("DebugRunParallelLuaOnMainThread", "True")
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

getgenv().executed = true
