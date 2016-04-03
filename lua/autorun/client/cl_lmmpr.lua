include("lmm_playerreview_config.lua")
surface.CreateFont( "LMMRPfontclose", {
		font = "Lato Light",
		size = 25,
		weight = 250,
		antialias = true,
		strikeout = false,
		additive = true,
} )
 
surface.CreateFont( "LMMRPTitleFont", {
	font = "Lato Light",
	size = 30,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMRPHeadingFont", {
	font = "Arial",
	size = 25,
	weight = 500,
} )
 
surface.CreateFont( "LMMRPTextFont", {
	font = "Arial",
	size = 35,
	weight = 500,
} ) 

surface.CreateFont( "LMMRPTextFontSmall", {
	font = "Arial",
	size = 25,
	weight = 500,
} ) 

surface.CreateFont( "LMMRPTextFontExtraSmall", {
	font = "Arial",
	size = 20,
	weight = 500,
} ) 

surface.CreateFont( "LMMRPNameFont", {
        font = "Lato Light",
        size = 46,
        weight = 250,
        antialias = true,
        strikeout = false,
        additive = true,
} )
 
surface.CreateFont( "LMMRPFontSmall", {
        font = "Lato Light",
        size = 34,
        weight = 250,
        antialias = true,
        strikeout = false,
        additive = true,
} )
 
surface.CreateFont( "LMMRPFont", {
        font = "Lato Light",
        size = 20,
        weight = 250,
        antialias = true,
        strikeout = false,
        additive = true,
} )

local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount) --Panel blur function
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

net.Receive("LMMPRReviewMe", function()
	
	local function MainRequest()
		local ply = net.ReadEntity()
		local PanelNum = 0
		local _, chatY = chat.GetChatBoxPos()

		if !LMMPRConfig.DevMode and ply == LocalPlayer() then return end
		
		local question = "Review "..ply:Nick().."?"
		local timeleft = 15
		local OldTime = CurTime()
		local timetext = 15
		if not IsValid(LocalPlayer()) then return end

		LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
		local panel = vgui.Create("DFrame")
		panel:SetPos(3 + PanelNum, chatY - 145)
		panel:SetTitle("")
		panel:SetSize(300, 140)
		panel:SetSizable(false)
		panel:SetDraggable(false)
		panel:ShowCloseButton(false)
		panel:SetKeyboardInputEnabled(false)
		panel:SetMouseInputEnabled(true)
		panel:SetVisible(true)
		panel.Paint = function( self, w, h )
			DrawBlur(panel, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 3.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 4, Color(0,0,0,125))
			draw.SimpleText( timetext, "LMMRPTitleFont", panel:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		
		function panel:Think()
			timetext = "Time: " .. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999))
			if timeleft - (CurTime() - OldTime) <= 0 then
				panel:Close()
			end
		end	

		local ava = vgui.Create( "AvatarImage", panel )
		ava:SetPos( 10, 40 )
		ava:SetSize( 64, 64 )
		ava:SetPlayer( ply, 64 )
		
		local label = vgui.Create("DLabel")
		label:SetParent(panel)
		label:SetPos(80, 65)
		label:SetText(question)
		label:SizeToContents()
		label:SetVisible(true)

		local divider = vgui.Create("Divider")
		divider:SetParent(panel)
		divider:SetPos(2, panel:GetTall() - 30)
		divider:SetSize(180, 2)
		divider:SetVisible(true)

		local ybutton = vgui.Create( "DButton", panel )
		ybutton:SetPos( 10, panel:GetTall() - 25 )
		ybutton:SetSize( panel:GetWide() - 170,20 )
		ybutton:SetText( "Yes" )
		ybutton:SetTextColor( Color( 255, 255, 255 ) )	
		ybutton.Paint = function( self, w, h )		
			DrawBlur(ybutton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		ybutton.DoClick = function()
			panel:Close()
			ClickedYes(ply)
		end	

		local nbutton = vgui.Create( "DButton", panel )
		nbutton:SetPos( panel:GetWide() - 150, panel:GetTall() - 25 )
		nbutton:SetSize( panel:GetWide() - 170,20 )
		nbutton:SetText( "No" )
		nbutton:SetTextColor( Color( 255, 255, 255 ) )	
		nbutton.Paint = function( self, w, h )		
			DrawBlur(nbutton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		nbutton.DoClick = function()
			panel:Close()
		end	
	end
	
	function ClickedYes(ply)	

		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 300 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 7.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 8, Color(0,0,0,125))
			draw.SimpleText( "Review Player", "LMMRPTitleFont", menu:GetWide() / 2, 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,10 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "LMMRPfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu:Close()
		end
 
		local QuestionList = vgui.Create( "DPanelList", menu )
		QuestionList:SetPos( 2, 50 )
		QuestionList:SetSize( menu:GetWide() - 4, menu:GetTall() - 80 )
		QuestionList:SetSpacing( 2 )
		QuestionList:EnableVerticalScrollbar( true )
		QuestionList.VBar.Paint = function( s, w, h )
			draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,72))
		end
		QuestionList.VBar.btnUp.Paint = function( s, w, h ) end
		QuestionList.VBar.btnDown.Paint = function( s, w, h ) end
		QuestionList.VBar.btnGrip.Paint = function( s, w, h )
			draw.RoundedBox( 4, 5, 0, 4, h+22, Color(0,0,0,72))
		end
		  
		local startpos = 30
		local thetable = {}
		local thenumber = LMMPRConfig.HowManyQuestions
				
		for k, v in pairs(LMMPRConfig.QuestionTable) do
			if v[2] >= 1 then
				local question = string.gsub( v[1], "!n", ply:Nick() )
				local choicen = 3 
				local DComboBox = vgui.Create( "DComboBox", QuestionList )
				DComboBox:SetPos( 2, startpos )
				DComboBox:SetSize( QuestionList:GetWide() - 4, 20 )
				DComboBox:SetValue( question )
				for i=1, v[2] do
					DComboBox:AddChoice( v[choicen] )
					choicen = choicen + 1
				end	
				DComboBox.OnSelect = function( panel, index, value )
					table.insert(thetable, {k, question, value})
					QuestionList:RemoveItem(DComboBox)
					thenumber = thenumber - 1
				end
				startpos = startpos + 30
				QuestionList:AddItem(DComboBox)
			else
				local question = string.gsub( v[1], "!n", ply:Nick() )
				
				local WarningLabel = vgui.Create("DLabel", QuestionList)
				WarningLabel:SetText("Press enter after completing")
				WarningLabel:SetTextColor(Color(255,0,0))
				WarningLabel:SetPos(2, startpos + 20)
				WarningLabel:SetSize(QuestionList:GetWide() - 4, 20)				
				
				local TextEntry = vgui.Create( "DTextEntry", QuestionList )
				TextEntry:SetPos( 2, startpos )
				TextEntry:SetSize( QuestionList:GetWide() - 4, 20 )
				TextEntry:SetText( question )
				TextEntry.OnEnter = function( self )
					table.insert(thetable, {k, question, self:GetValue()})
					QuestionList:RemoveItem(TextEntry)
					QuestionList:RemoveItem(WarningLabel)
					thenumber = thenumber - 1
				end				
				
				startpos = startpos + 40
				QuestionList:AddItem(TextEntry)
				QuestionList:AddItem(WarningLabel)
			end
		end
		QuestionList.Think = function()
			if thenumber <= 0 then
				menu:Close()
				table.insert(thetable, {ply})
				net.Start("LMMPRFinishedReview")
					net.WriteTable(thetable)
				net.SendToServer()
			end
		end
	end
	
	MainRequest()
end)

net.Receive("LMMPRReviewMeAnswersAdmin", function()
	
	local function MainRequest()
		local thetable = net.ReadTable()
		local reviewer = net.ReadEntity()
		local thenumber = LMMPRConfig.HowManyQuestions
		local ply = thetable[thenumber + 1][1]
		local PanelNum = 0
		local _, chatY = chat.GetChatBoxPos()

		local question = "Check "..ply:Nick().."'s review?\nSubmitted by: "..reviewer:Nick()
		local timeleft = 15
		local OldTime = CurTime()
		local timetext = 15
		if not IsValid(LocalPlayer()) then return end

		LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
		local panel = vgui.Create("DFrame")
		panel:SetPos(3 + PanelNum, chatY - 145)
		panel:SetTitle("")
		panel:SetSize(300, 140)
		panel:SetSizable(false)
		panel:SetDraggable(false)
		panel:ShowCloseButton(false)
		panel:SetKeyboardInputEnabled(false)
		panel:SetMouseInputEnabled(true)
		panel:SetVisible(true)
		panel.Paint = function( self, w, h )
			DrawBlur(panel, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 3.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 4, Color(0,0,0,125))
			draw.SimpleText( timetext, "LMMRPTitleFont", panel:GetWide() / 2, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		
		function panel:Think()
			timetext = "Time: " .. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999))
			if timeleft - (CurTime() - OldTime) <= 0 then
				panel:Close()
			end
		end	

		local ava = vgui.Create( "AvatarImage", panel )
		ava:SetPos( 10, 40 )
		ava:SetSize( 64, 64 )
		ava:SetPlayer( ply, 64 )
		
		local label = vgui.Create("DLabel")
		label:SetParent(panel)
		label:SetPos(80, 65)
		label:SetText(question)
		label:SizeToContents()
		label:SetVisible(true)

		local divider = vgui.Create("Divider")
		divider:SetParent(panel)
		divider:SetPos(2, panel:GetTall() - 30)
		divider:SetSize(180, 2)
		divider:SetVisible(true)

		local ybutton = vgui.Create( "DButton", panel )
		ybutton:SetPos( 10, panel:GetTall() - 25 )
		ybutton:SetSize( panel:GetWide() - 170,20 )
		ybutton:SetText( "Yes" )
		ybutton:SetTextColor( Color( 255, 255, 255 ) )	
		ybutton.Paint = function( self, w, h )		
			DrawBlur(ybutton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		ybutton.DoClick = function()
			panel:Close()
			ClickedYes(thetable, reviewer)
		end	

		local nbutton = vgui.Create( "DButton", panel )
		nbutton:SetPos( panel:GetWide() - 150, panel:GetTall() - 25 )
		nbutton:SetSize( panel:GetWide() - 170,20 )
		nbutton:SetText( "No" )
		nbutton:SetTextColor( Color( 255, 255, 255 ) )	
		nbutton.Paint = function( self, w, h )		
			DrawBlur(nbutton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		nbutton.DoClick = function()
			panel:Close()
		end	
	end
	
	function ClickedYes(thetable, reviewer)
		
		local thenumber = LMMPRConfig.HowManyQuestions
		local ply = thetable[thenumber + 1][1]
		
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( 300, 300 )
		menu:Center()
		menu:SetDraggable( true )
		menu:MakePopup()
		menu:SetTitle( "" )
		menu:ShowCloseButton( false )
		menu.Paint = function( self, w, h )
			DrawBlur(menu, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 7.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 8, Color(0,0,0,125))
			draw.SimpleText( "Review Player", "LMMRPTitleFont", menu:GetWide() / 2, 25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
 
		local frameclose = vgui.Create( "DButton", menu )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( menu:GetWide() - 34,10 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "LMMRPfontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end
		frameclose.DoClick = function()
			menu:Close()
		end

		local TheLabel = vgui.Create("DLabel", menu)
		TheLabel:SetText("Answers submitted by: "..reviewer:Nick())
		TheLabel:SetTextColor(Color(255,0,0))
		TheLabel:SetPos(2, 280)
		TheLabel:SetSize(menu:GetWide() - 4, 20)
		
		local QuestionList = vgui.Create( "DPanelList", menu )
		QuestionList:SetPos( 2, 50 )
		QuestionList:SetSize( menu:GetWide() - 4, menu:GetTall() - 80 )
		QuestionList:SetSpacing( 2 )
		QuestionList:EnableVerticalScrollbar( true )
		QuestionList.VBar.Paint = function( s, w, h )
			draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,72))
		end
		QuestionList.VBar.btnUp.Paint = function( s, w, h ) end
		QuestionList.VBar.btnDown.Paint = function( s, w, h ) end
		QuestionList.VBar.btnGrip.Paint = function( s, w, h )
			draw.RoundedBox( 4, 5, 0, 4, h+22, Color(0,0,0,72))
		end
		
		for k, v in pairs(thetable) do
			if k == thenumber + 1 then return end
			local CheckButton = vgui.Create("DButton", QuestionList)
			CheckButton:SetPos( 2, 60 )
			CheckButton:SetSize( QuestionList:GetWide() - 4,20 )
			CheckButton:SetText("Check answer for "..v[1])
			CheckButton:SetTextColor(Color(255,255,255))
			CheckButton.Paint = function( self, w, h )
				DrawBlur(CheckButton, 2)
				drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))	
			end
			CheckButton.DoClick = function()
				Derma_Message( "Question: "..v[2].."\nAnswer: "..v[3], "Answer for "..v[1], "OK" )
			end
			
			QuestionList:AddItem(CheckButton)
		end		
	end
	
	MainRequest()
end)