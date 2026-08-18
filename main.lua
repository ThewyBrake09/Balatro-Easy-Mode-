--- Main Mod Initialization File
-- Handles module loading, pool overrides, and config UI creation.

local THIS_MOD = SMODS.current_mod

--- Initialize Configuration Defaults
THIS_MOD.config = THIS_MOD.config or {}
THIS_MOD.config.enabled = THIS_MOD.config.enabled == nil or THIS_MOD.config.enabled
THIS_MOD.config.allow_dupes = THIS_MOD.config.allow_dupes or false
THIS_MOD.config.starting_money_mode = THIS_MOD.config.starting_money_mode or 2

--- Module Loader Sequence
local module = {
    "card/joker_pool.lua",
}

for _, file in ipairs(module) do
    local ok, chunk = pcall(SMODS.load_file, file)
    if ok and chunk then
        local loaded_module = chunk()
        if type(loaded_module) == "table" and type(loaded_module.init) == "function" then
            loaded_module.init()
        end
    else
        sendWarnMessage("Failed to load module: " .. tostring(file), "Balatro Easy Mode")
    end
end

local function get_config()
    return THIS_MOD.config
end

----------------------------------------------------------------------
--- Hook 1: Safe Pool Fetcher & Duplicate Handling
----------------------------------------------------------------------
local ref_get_current_pool = get_current_pool

function get_current_pool(_type, _rarity, _legendary, _append)
    local conf = get_config()

    if conf and conf.enabled and _type == 'Joker' then
        local saved_used_jokers = nil
        
        -- Bypass duplicate restrictions if configured
        if conf.allow_dupes and G.GAME and G.GAME.used_jokers then
            saved_used_jokers = G.GAME.used_jokers
            G.GAME.used_jokers = {}
        end

        local pool, pool_key = ref_get_current_pool(_type, _rarity, _legendary, _append)

        -- Fallback generator if pool is depleted
        if not pool or #pool == 0 then
            pool = {}
            for key, center in pairs(G.P_CENTERS) do
                if center.set == 'Joker' and not center.demo then
                    table.insert(pool, key)
                end
            end
            pool_key = 'Joker_Locked_Fallback'
        end

        -- Restore original used table state
        if saved_used_jokers then
            G.GAME.used_jokers = saved_used_jokers
        end

        return pool, pool_key
    end

    return ref_get_current_pool(_type, _rarity, _legendary, _append)
end

----------------------------------------------------------------------
--- Hook 2: Direct Starting Money Injection
----------------------------------------------------------------------
local ref_start_run = Game.start_run
function Game:start_run(args)
    ref_start_run(self, args)

    -- Jalankan hanya jika run baru (bukan continue save)
    if args and not args.savetext then
        local conf = THIS_MOD.config
        local mode = conf and conf.starting_money_mode or 2

        local bonus_map = {
            [1] = 0,   -- Disabled
            [2] = 25,  -- Balanced
            [3] = 50,  -- Casual
            [4] = 100  -- Chaos
        }

        local bonus = bonus_map[mode] or 0

        if bonus > 0 and G.GAME then
            -- Tambahkan bonus uang langsung ke total uang player
            G.GAME.dollars = G.GAME.dollars + bonus
        end
    end
end


----------------------------------------------------------------------
--- User Interface: Mod Config Tab
----------------------------------------------------------------------
THIS_MOD.config_tab = function()
    local conf = get_config()
    
    return {
        n = G.UIT.ROOT,
        config = { align = 'cm', padding = 0.1, colour = G.C.CLEAR },
        nodes = {
            -- Toggle: Allow Duplicate Jokers
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
                config = { align = 'cm', padding = 0.05 },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = 'Duplicates affect Jokers pool only.',
                            scale = 0.32,
                            colour = G.C.UI.TEXT_LIGHT,
                        },
                    },
                },
            },
            -- Cycle Option: Starting Money Bonus 
            {
                n = G.UIT.R,
                config = { align = 'cm', padding = 0.1 },
                nodes = {
                    create_option_cycle({
                        label = 'Starting Money Bonus',
                        options = {'Disabled ($0)', 'Balanced ($25)', 'Casual ($50)', 'Chaos ($100)'},
                        current_option = conf.starting_money_mode or 2,
                        opt_callback = 'update_starting_money_mode',
                        ref_table = conf,
                        ref_value = 'starting_money_mode',
                    }),
                },
            },
        },
    }
end

G.FUNCS.update_starting_money_mode = function(e)
    if e and e.to_key then
        THIS_MOD.config.starting_money_mode = e.to_key
        SMODS.save_mod_config(THIS_MOD) 
    end
end
