util.AddNetworkString("LMMPRReviewMe")
util.AddNetworkString("LMMPRFinishedReview")
util.AddNetworkString("LMMPRReviewMeAnswersAdmin")

net.Receive("LMMPRFinishedReview", function(len, ply)
	local thetable = net.ReadTable()
	local thenumber = LMMPRConfig.HowManyQuestions
	local reviwedply = thetable[thenumber + 1][1]
	
	reviwedply:ChatPrint(ply:Nick().." has sent in their review on you!")
	
	for k, v in pairs(player.GetAll()) do
		if table.HasValue(LMMPRConfig.AdminGroups, v:GetUserGroup()) then
			net.Start("LMMPRReviewMeAnswersAdmin")		
				net.WriteTable(thetable)
				net.WriteEntity(ply)
			net.Send(v)
		end
	end
end)

function chatCommand( ply, text )
    if (string.sub(text, 1, 9) == "/reviewme" or string.sub(text, 1, 9) == "!reviewme") then --if the first 4 letters are /die, kill him
        net.Start("LMMPRReviewMe")
			net.WriteEntity(ply)
		net.Broadcast()
        return false
    end
end
hook.Add( "PlayerSay", "chatCommand", chatCommand )