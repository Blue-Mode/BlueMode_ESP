-- ==============================================
-- 🔵 BLUE MODE HUB | PART 2/2 | FULL FINAL ENDING
-- ✅ NO TRUNCATION | ALL FEATURES INTACT
-- ==============================================
        for _,P in pairs(Players:GetPlayers()) do
            if P == LocalPlayer or not P then continue end
            local Char = P.Character; if not Char then continue end
            local Hum = Char:FindFirstChild("Humanoid")
            if not Hum or Hum.Health <= 0 then
                SafeDestroy(Char:FindFirstChild("BLUE_Outline"))
                SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
                continue
            end

            if not Char:FindFirstChild("BLUE_Outline") then
                local Out = Instance.new("Highlight")
                Out.Name = "BLUE_Outline"; Out.FillTransparency=0.6; Out.OutlineTransparency=0
                Out.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; Out.Adornee=Char; Out.Parent=Char
            end
            Char.BLUE_Outline.FillColor = Rainbow
            Char.BLUE_Outline.OutlineColor = Rainbow

            local IsFriend = IsPlayerFriend(P)
            local IsOwner = (P.UserId == OWNER_USERID)

            if IsOwner then
                if not Char:FindFirstChild("GoldenOwnerDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "GoldenOwnerDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(0,3,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Golden
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.GoldenOwnerDot.Frame.BackgroundColor3 = Golden
                end

                if IsFriend then
                    if not Char:FindFirstChild("FriendRainbowDot") then
                        local Dot = Instance.new("BillboardGui")
                        Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                        Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                        local Fr = Instance.new("Frame")
                        Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                        Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                    else
                        Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                    end
                else
                    SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                end

            elseif IsFriend then
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
                if not Char:FindFirstChild("FriendRainbowDot") then
                    local Dot = Instance.new("BillboardGui")
                    Dot.Name = "FriendRainbowDot"; Dot.Size = UDim2.new(0,15,0,15)
                    Dot.StudsOffset = Vector3.new(1.5,1,0); Dot.AlwaysOnTop = true
                    local Fr = Instance.new("Frame")
                    Fr.Size = UDim2.new(1,0,1,0); Fr.BackgroundColor3 = Rainbow
                    Instance.new("UICorner",Fr).CornerRadius=UDim.new(1,0); Fr.Parent=Dot; Dot.Parent=Char.Head
                else
                    Char.FriendRainbowDot.Frame.BackgroundColor3 = Rainbow
                end

            else
                SafeDestroy(Char:FindFirstChild("FriendRainbowDot"))
                SafeDestroy(Char:FindFirstChild("GoldenOwnerDot"))
            end
        end
    end)
end

-- ✅ MAIN HUB LOADS ONLY AFTER STARTUP IS CLOSED
LoadMainHub()
