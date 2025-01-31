local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

player.Idled:Connect(function()
    VirtualUser:CaptureController()
end)

RunService.Heartbeat:Connect(function()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
    game.StarterGui:SetCore("SendNotification", {
        Title = "AntiAfk",
        Text = "RIGHT CLICKED",
        Duration = 2
    })
end)
