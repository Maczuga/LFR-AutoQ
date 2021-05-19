SLASH_LFR_AUTOQ1 = "/alfr"

SlashCmdList["LFR_AUTOQ"] = function(arg)
  local asTank = string.find(arg, "tank")
  local asHeal = string.find(arg, "heal")
  local asDPS = string.find(arg, "dps")

  if string.find(arg, "all") then
    asTank = true
    asHeal = true
    asDPS = true
  end

  local pLvl = UnitLevel("player")

  ClearAllLFGDungeons(LE_LFG_CATEGORY_LFR)
  SetLFGRoles(LE_LFG_CATEGORY_LFR, asTank, asHeal, asDPS)

  for i = 1, GetNumRFDungeons() do
    local id, _, _, _, min, max = GetRFDungeonInfo(i)
    local total, killed = GetLFGDungeonNumEncounters(id)

    if not (pLvl < min or pLvl > max) then
        if killed ~= total and IsLFGDungeonJoinable(id) then
          SetLFGDungeon(LE_LFG_CATEGORY_LFR, id)
        end
    end
  end

  JoinLFG(LE_LFG_CATEGORY_LFR)
end