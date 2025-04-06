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
