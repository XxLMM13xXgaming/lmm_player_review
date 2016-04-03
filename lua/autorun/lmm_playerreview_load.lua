if (SERVER) then
	AddCSLuaFile("lmm_playerreview_config.lua")
	include("lmm_playerreview_config.lua")
end

if (CLIENT) then
	include("lmm_playerreview_config.lua")
end