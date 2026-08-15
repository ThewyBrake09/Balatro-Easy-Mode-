--- RarityLock
--- 1) Forces every Joker the game generates to a chosen rarity.
--- 2) Optionally allows duplicate JOKERS (Joker-only Showman) so owned Jokers
---    can reappear in shops/packs and the pool never dries up.
--- 3) The Soul card logic: forces it to pull from the 5 custom-common legendaries.

--- Stable mod reference captured at load time (SMODS.current_mod is nil later).
local THIS_MOD = SMODS.current_mod

local path = SMODS.path_asi or (THIS_MOD and THIS_MOD.path) or (THIS_MOD and THIS_MOD.folder and ("Mods/" .. THIS_MOD.folder .. "/")) or ""

THIS_MOD.config = THIS_MOD.config or {}
if THIS_MOD.config.enabled == nil then THIS_MOD.config.enabled = true end
if THIS_MOD.config.rarity == nil then THIS_MOD.config.rarity = 1 end
if THIS_MOD.config.allow_dupes == nil then THIS_MOD.config.allow_dupes = false end

--- call file

local files = {
    "card/joker_value.lua",
    "card/override.lua",
    "card/card_logic",
    "localization/id.lua",
    "localization/en-us.lua"
}

for _, file in ipairs(files) do
    assert(SMODS.load_file(file))()
end

local function get_config()
    return THIS_MOD.config
end

local ROLL_FOR_RARITY = {
    [1] = 0.3,   -- Common   (<= 0.7)
    [2] = 0.85,  -- Uncommon (0.7 - 0.95)
    [3] = 0.99,  -- Rare     (> 0.95)
}

----------------------------------------------------------------------
--- Hook 1: force Joker rarity in create_card.
----------------------------------------------------------------------
local ref_create_card = create_card

function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local conf = get_config()

    legendary, forced_key = c_override(legendary, _type, forced_key)
    
    if conf and conf.enabled and _type == 'Joker' and not forced_key then
        if conf.rarity == 4 then
            legendary = true
            _rarity = nil
        else
            legendary = false
            _rarity = ROLL_FOR_RARITY[conf.rarity] or 0.3
        end
    end

    return ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end

----------------------------------------------------------------------
--- Hook 2: Joker-only duplicates.
----------------------------------------------------------------------
local ref_get_current_pool = get_current_pool

function get_current_pool(_type, _rarity, _legendary, _append)
    local conf = get_config()

    if conf and conf.allow_dupes and _type == 'Joker'
       and G.GAME and G.GAME.used_jokers then
        local saved = G.GAME.used_jokers
        G.GAME.used_jokers = {}

        local pool, pool_key = ref_get_current_pool(_type, _rarity, _legendary, _append)

        G.GAME.used_jokers = saved
        return pool, pool_key
    end

    return ref_get_current_pool(_type, _rarity, _legendary, _append)
end

----------------------------------------------------------------------
--- Config tab UI 
----------------------------------------------------------------------
THIS_MOD.config_tab = function()
    local conf = get_config()
    return {
        n = G.UIT.ROOT,
        config = { align = 'cm', padding = 0.1, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.1 },
                nodes = {
                    create_toggle({
                        label = 'Allow duplicate Jokers (Joker-only)',
                        ref_table = conf,
                        ref_value = 'allow_dupes',
                    }),
                },
            },
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.1 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = 'Duplicates affects Jokers only.',
                            scale = 0.32,
                            colour = G.C.UI.TEXT_LIGHT,
                        },
                    },
                },
            },
        },
    }
end
