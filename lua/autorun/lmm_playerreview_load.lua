if (SERVER) then
	AddCSLuaFile("lmm_playerreview_config.lua")
	include("lmm_playerreview_config.lua")
	MsgC(Color(0,255,0), [[LMM PLAYER REVIEW NOW LOADED!
]])
end

if (CLIENT) then
	include("lmm_playerreview_config.lua")
	MsgC(Color(0,255,0), [[LMM PLAYER REVIEW NOW LOADED!
]]) 
end 