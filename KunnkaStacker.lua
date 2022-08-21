local KunnkaStacker = {}
KunnkaStacker.optionEnable = Menu.AddOption({"Utility", "Kunnka Stacker"}, "Activation", "")

function KunnkaStacker.OnUpdate()
  if not Menu.IsEnabled(KunnkaStacker.optionEnable) then return end
  local myHero = Heroes.GetLocal()
  if not myHero then return end
  local torrent = NPC.GetAbility(myHero, "kunkka_torrent")
  if torrent and GameRules.GetGameState() == 5 then
    needStaker = true
    if Ability.IsReady(torrent) then
      local rangetorrent = Ability.GetCastRange(torrent)
      local second = (GameRules.GetGameTime()-GameRules.GetGameStartTime())%60
      local ping = NetChannel.GetAvgLatency(Enum.Flow.MAX_FLOWS)
      if second >= 60-2.6-ping then
        for _,camp in pairs(anchentpoint) do
          if camp[2] and NPC.IsPositionInRange(myHero,camp[1],rangetorrent) then
            Ability.CastPosition(torrent,camp[1])
          end
        end
      end
    end
  end
end

function KunnkaStacker.OnDraw()
  if not Menu.IsEnabled(KunnkaStacker.optionEnable) then return end
  if not needStaker then return end
  for _,camp in pairs(anchentpoint) do
    if camp then
      local X,Y,vis = Renderer.WorldToScreen(camp[1])
      if vis then
        if camp[2] then
          Renderer.SetDrawColor(0,255,0,150)
        else
          Renderer.SetDrawColor(255,0,0,150)
        end
        Renderer.DrawFilledRect(X-sizeBar/2,Y-sizeBar/2,sizeBar,sizeBar)
      end
      if Input.IsCursorInRect(X-sizeBar/2,Y-sizeBar/2,sizeBar,sizeBar) then
        if Input.IsKeyDownOnce(Enum.ButtonCode.KEY_LCONTROL) then
          camp[2] = not camp[2]
        end
      end
    end
  end
end

function KunnkaStacker.init()
  sizeBar = 32
  needStaker = false
  anchentpoint = { -- you can add new spots here
    {Vector(-3691.8159179688, 783.97601318359, 384.0),false},
    {Vector(-2630.6437988281, -589.87915039063, 384.0),false},
    {Vector(2563.2019042969, 110.64920043945, 384.00012207031),false},
    {Vector(4152.0834960938, -395.28869628906, 384.0),false},
    {Vector(-265.02026367188, -3316.8745117188, 384.0),false},
    {Vector(442.3918762207, -4641.634765625, 384.0),false},
    {Vector(-1890.6604003906, 4440.8701171875, 384.00012207031),false},
    {Vector(-2568.0346679688, 4803.93359375, 256.0),false},
    {Vector(-4322.5180664063, 3610.083984375, 256.0),false}
  }
end

function KunnkaStacker.OnGameStart()
  KunnkaStacker.init()
end

function KunnkaStacker.OnGameEnd()
  KunnkaStacker.init()
end

KunnkaStacker.init()

return KunnkaStacker