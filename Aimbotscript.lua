task.spawn(function() -- Aim Bot
    local AimBotPart, NearestPlayer
    local MouseModule = WaitChilds(ReplicatedStorage, "Mouse")
    
    task.spawn(function() -- Get Nearest Player
      local function CheckTeam(plr)
        return tostring(plr.Team) == "Pirates" or (tostring(plr.Team) ~= tostring(Player.Team))
      end
      
      local function GetNear()
        local Distance, Nearest = math.huge, false
        for _,plr in pairs(Players:GetPlayers()) do
          if (plr ~= Player) and CheckTeam(plr) then
            local plrPP = plr.Character and plr.Character.PrimaryPart
            local Mag = plrPP and Player:DistanceFromCharacter(plrPP.Position)
            
            if Mag and Mag <= Distance then
              Distance, Nearest = Mag, ({
                ["Position"] = (plrPP.Position),
                ["PrimaryPart"] = plrPP,
                ["DistanceFromCharacter"] = Mag
              })
            end
          end
        end
        NearestPlayer = Nearest
      end
      
      RunService.RenderStepped:Connect(GetNear)
    end)
    
    task.spawn(function() -- Enable Aim Bot
      local OldHook
      OldHook = hookmetamethod(game, "__namecall", function(self, V1, V2, ...)
        local Method = getnamecallmethod():lower()
        if tostring(self) == "RemoteEvent" and Method == "fireserver" then
          if typeof(V1) == "Vector3" then
            if AimBotPart then
              if AutoFarmSea or AutoWoodPlanks or Sea2_AutoFarmSea then
                if SeaAimBotSkill then
                  return OldHook(self, AimBotPart[2], V2, ...)
                end
              elseif AutoFarmMastery then
                if AimBotSkill then
                  return OldHook(self, AimBotPart[2], V2, ...)
                end
              end
            end
            if AimbotPlayer and NearestPlayer then
              return OldHook(self, NearestPlayer.Position, V2, ...)
            end
          end
        elseif Method == "invokeserver" then
          if type(V1) == "string" and V1 == "TAP" and typeof(V2) == "Vector3" then
            if AimbotTap and NearestPlayer then
              return OldHook(self, "TAP", NearestPlayer.Postion, V2, ...)
            end
          end
        end
        return OldHook(self, V1, V2, ...)
      end)
    end)
    
    Module["AimBotPart"] = function(RootPart)
      local Mouse = require(MouseModule)
      Mouse.Hit = CFrame.new(RootPart.Position)
      Mouse.Target = RootPart
      AimBotPart = ({ RootPart, RootPart.Position })
    end
  end)
  
  RunService.Heartbeat:Connect(Module.requestClick)
  
  Module["Shop"] = Shop
  Module["TweenBlock"] = TweenBlock
  Module["FarmCheck"] = FarmCheck
  Module["Inventory"] = Inventory
  Module["WaitPart"] = WaitChilds
  Module.__index = Module
  table.insert(Module, Module)
end

return Module
