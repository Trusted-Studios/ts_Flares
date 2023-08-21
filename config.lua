-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Debug Logs
-- ════════════════════════════════════════════════════════════════════════════════════ --

local filename = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end
print("^6[SHARED - DEBUG] ^0: "..filename()..".lua gestartet");

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Trusted Development || System
-- ════════════════════════════════════════════════════════════════════════════════════ --

Trusted = {}
Trusted.Debug = true
Trusted.Webhook = ''

-- ════════════════════════════════════════════════════════════════════════════════════ --
-- Code
-- ════════════════════════════════════════════════════════════════════════════════════ --

Config = {}

Config.Speed = -1.0

Config.FlareInterval = 500

Config.Flare_models = {
    [GetHashKey("mogul")] = {limit = 50, mode = 1},
    [GetHashKey("rogue")] = {limit = 50, mode = 1},
    [GetHashKey("starling")] = {limit = 50, mode = 1},
    [GetHashKey("seabreeze")] = {limit = 50, mode = 1},
    [GetHashKey("tula")] = {limit = 50, mode = 1},
    [GetHashKey("bombushka")] = {limit = 150, mode = 10},
    [GetHashKey("hunter")] = {limit = 50, mode = 1},
    [GetHashKey("nokota")] = {limit = 50, mode = 1},
    [GetHashKey("pyro")] = {limit = 50, mode = 1},
    [GetHashKey("molotok")] = {limit = 50, mode = 1},
    [GetHashKey("havok")] = {limit = 50, mode = 1},
    [GetHashKey("alphaz1")] = {limit = 50, mode = 1},
    [GetHashKey("microlight")] = {limit = 50, mode = 1},
    [GetHashKey("howard")] = {limit = 50, mode = 1},
    [GetHashKey("avenger")] = {limit = 50, mode = 1},
    [GetHashKey("thruster")] = {limit = 50, mode = 1},
    [GetHashKey("volatol")] = {limit = 50, mode = 1},
    [GetHashKey("lazer")] = {limit = 150, mode = 10},
    [GetHashKey("strikeforce")] = {limit = 50, mode = 1},
    [GetHashKey("buzzard")] = {limit = 50, mode = 3},
}