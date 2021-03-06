-- local version = select(4, GetBuildInfo());

local tiers = {
  -- Cata
  ds = {1, 2},
  -- MoP
  msv = {3, 4},
  hof = {5, 6},
  toes = {7},
  tot = {8, 9, 10, 11},
  soo12 = {12, 13},
  soo34 = {14, 15},
  soo = {12, 13, 14, 15},
};

SLASH_LFR_AUTOQ1 = "/alfr"

local function AddonLog(...)
  print("[LFR-AutoQ] ", ...)
end

local function QueueSection(i)
  local pLvl = UnitLevel("player")

  local id, name, _, _, min, max = GetRFDungeonInfo(i)
  local _, killed = GetLFGDungeonNumEncounters(id)

  -- SoO has 2 wings with 4 bosses
  local maxKilled = i >= 12 and i <= 13 and 4 or 3

  if not (pLvl < min or pLvl > max) then
      if killed < maxKilled and IsLFGDungeonJoinable(id) then
        local mode, subMode = GetLFGMode(LE_LFG_CATEGORY_RF, id);
        if mode == nil then
          AddonLog("Queueing to: " .. name)
          ClearAllLFGDungeons(LE_LFG_CATEGORY_RF)
          SetLFGDungeon(LE_LFG_CATEGORY_RF, id)
          JoinSingleLFG(LE_LFG_CATEGORY_RF, id)
        end
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

  SetLFGRoles(LE_LFG_CATEGORY_RF, asTank, asHeal, asDPS)

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
end