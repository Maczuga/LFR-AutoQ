local version = select(4, GetBuildInfo());

local tiers = {
  -- Cata
  ds = {1, 2},
  -- MoP
  msv = {3, 4},
  hof = {5, 6},
  toes = {7},
  tot = {8, 9, 10, 11},
  soo = {12, 13, 14, 15},
};

SLASH_LFR_AUTOQ1 = "/alfr"

function AddonLog(msg)
  print("[LFR-AutoQ] " .. msg)
end
function QueueSection(i)
  local pLvl = UnitLevel("player")

  local id, name, _, _, min, max = GetRFDungeonInfo(i)
  local _, killed = GetLFGDungeonNumEncounters(id)

  if not (pLvl < min or pLvl > max) then
      if killed < 3 and IsLFGDungeonJoinable(id) then
        AddonLog("Queueing to: " .. name)
        SetLFGDungeon(LE_LFG_CATEGORY_LFR, id)
      end
  end
end

SlashCmdList["LFR_AUTOQ"] = function(arg)
  -- Roles
  local asTank = string.find(arg, "tank")
  local asHeal = string.find(arg, "heal")
  local asDPS = string.find(arg, "dps")

  arg = " " .. arg .. " ";

  if string.find(arg, "all") then
    asTank = true
    asHeal = true
    asDPS = true
  end


  ClearAllLFGDungeons(LE_LFG_CATEGORY_LFR)
  SetLFGRoles(LE_LFG_CATEGORY_LFR, asTank, asHeal, asDPS)

  -- Sections
  if string.find(arg, "full") then
    for i = 1, GetNumRFDungeons() do
      QueueSection(i)
    end
  else
    for shortcut, sectionIds in pairs(tiers) do
      if string.find(arg, " " .. shortcut .. " ") then
        for i = 1, #sectionIds do
          QueueSection(sectionIds[i])
        end
      end
    end
  end

  JoinLFG(LE_LFG_CATEGORY_LFR)
end