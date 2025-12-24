
-- TYPICAL COLORS 2 AUTO-LIGHTING
-- Created by: mishammaliy
-- Version: 0.1

local selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("TC2 Auto-Lighting")

local button = toolbar:CreateButton("TC2 Auto-Lighting", "Sets the lighting automatically for you.", "rbxassetid://113010417690534")

local interface = plugin:CreateDockWidgetPluginGui("Menu", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 600, 400, 600, 400))
local UI = script.GUI
UI.Parent = interface
interface.Title = "TC2 Auto Lighting"
interface.Enabled = false

local function warnPlayer(text)
	local warning = UI.Required:Clone()
	
	UI.Required.Visible = false
	warning.Text = text
	warning.Parent = UI
	wait(5)
	UI.Required.Visible = true
	warning:Destroy()
end

UI.TextButton.MouseButton1Click:Connect(function()
	for i,model in selection:Get() do
		--Is the map the only selected?
		if i > 1 then 
			task.spawn(warnPlayer, "Please select only one model.") 
			return 
		end
		
		-- Is the map a folder?
		if not model:IsA("Folder") then 
			task.spawn(warnPlayer, "Not a valid Folder.") 
			return 
		end
		
		-- Does the map have Settings?
		if not model:FindFirstChild("Settings") then 
			task.spawn(warnPlayer, "Make sure its a valid TC2 Map!") 
			return 
		end
		
		-- Does the map have Lighting?
		if not model.Settings:FindFirstChild("Lighting") then 
			task.spawn(warnPlayer, "Make sure its a valid TC2 Map!") 
			return 
		end
		
		-- Does the map have Terrain?
		if not model.Settings:FindFirstChild("Terrain") then 
			task.spawn(warnPlayer, "Make sure its a valid TC2 Map!") 
			return 
		end
		
		-- Clears everything inside the lighting,
		-- before importing from settings to it's Lighting.
		for _,no in game.Lighting:GetChildren() do no:Destroy() end
		
		-- Importing on the Lighting values begins.
		for _,value in model.Settings.Lighting:GetChildren() do
			if string.find(string.lower(value.ClassName), "value") then
				game.Lighting[value.Name] = value.Value
			else
				value:Clone().Parent = game.Lighting
			end
		end
		
		-- Importing on the Terrain values begins.
		for _,value in model.Settings.Terrain:GetChildren() do
			if string.find(string.lower(value.ClassName), "value") then
				workspace.Terrain[value.Name] = value.Value
			else
				value:Clone().Parent = workspace.Terrain
			end
		end
		
		--Reminds the player everything is done.
		script.Sounds.yes:Play()
		task.spawn(warnPlayer, "Complete!")
	end
end)

button.Click:Connect(function() 
	interface.Enabled = not interface.Enabled 
end)
