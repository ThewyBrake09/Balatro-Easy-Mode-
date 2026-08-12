--- RarityLock
--- 1) Forces every Joker the game generates to a chosen rarity.
--- 2) Optionally allows duplicate JOKERS (Joker-only Showman) so owned Jokers
---    can reappear in shops/packs and the pool never dries up.
--- 3) The Soul card logic: forces it to pull from the 5 custom-common legendaries.

--- Stable mod reference captured at load time (SMODS.current_mod is nil later).
local THIS_MOD = SMODS.current_mod

THIS_MOD.config = THIS_MOD.config or {}
if THIS_MOD.config.enabled == nil then THIS_MOD.config.enabled = true end
if THIS_MOD.config.rarity == nil then THIS_MOD.config.rarity = 1 end
if THIS_MOD.config.allow_dupes == nil then THIS_MOD.config.allow_dupes = false end

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

    if legendary and _type == 'Joker' and not forced_key then
        local legendary_pool = {'j_perkeo', 'j_triboulet', 'j_yorick', 'j_chicot', 'j_caino'}
        forced_key = pseudorandom_element(legendary_pool, pseudoseed('soul_common_pool'))
        legendary = false
    end

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
--- List of cards.
--- Check pricelist.md to get original value.
----------------------------------------------------------------------
local modified_jokers = {
    -- Original legendary card pool, rarity = 4
    { key = 'j_perkeo', rarity = 1, cost = 12 },
    { key = 'j_triboulet', rarity = 1, cost = 12 },
    { key = 'j_yorick', rarity = 1, cost = 12 },
    { key = 'j_chicot', rarity = 1, cost = 12 },
    { key = 'j_caino', rarity = 1, cost = 12 },
    
    -- Original rare card pool, rarity = 3
    { key = 'j_dna', rarity = 1, cost = 8 },
    { key = 'j_vagabond', rarity = 1, cost = 8 },
    { key = 'j_baron', rarity = 1, cost = 8 },
    { key = 'j_obelisk', rarity = 1, cost = 8 },
    { key = 'j_baseball', rarity = 1, cost = 8 },
    { key = 'j_ancient', rarity = 1, cost = 8 },
    { key = 'j_campfire', rarity = 1, cost = 9 },
    { key = 'j_blueprint', rarity = 1, cost = 10 },
    { key = 'j_wee', rarity = 1, cost = 8 },
    { key = 'j_hit_the_road', rarity = 1, cost = 8 },
    { key = 'j_duo', rarity = 1, cost = 8 },
    { key = 'j_trio', rarity = 1, cost = 8 },
    { key = 'j_family', rarity = 1, cost = 8 },
    { key = 'j_order', rarity = 1, cost = 8 },
    { key = 'j_tribe', rarity = 1, cost = 8 },
    { key = 'j_stuntman', rarity = 1, cost = 7 },
    { key = 'j_invisible', rarity = 1, cost = 8 },
    { key = 'j_brainstorm', rarity = 1, cost = 10 },
    { key = 'j_drivers_license', rarity = 1, cost = 7 },
    { key = 'j_burnt', rarity = 1, cost = 8 },
    
    -- Original uncommon card pool, rarity = 2
    { key = 'j_stencil', rarity = 1, cost = 8 },
    { key = 'j_four_fingers', rarity = 1, cost = 7 },
    { key = 'j_mime', rarity = 1, cost = 5 },
    { key = 'j_ceremonial', rarity = 1, cost = 6 },
    { key = 'j_marble', rarity = 1, cost = 6 },
    { key = 'j_loyalty_card', rarity = 1, cost = 5 },
    { key = 'j_dusk', rarity = 1, cost = 5 },
    { key = 'j_fibonacci', rarity = 1, cost = 8 },
    { key = 'j_steel_joker', rarity = 1, cost = 7 },
    { key = 'j_hack', rarity = 1, cost = 6 },
    { key = 'j_pareidolia', rarity = 1, cost = 5 },
    { key = 'j_space', rarity = 1, cost = 5 },
    { key = 'j_burglar', rarity = 1, cost = 6 },
    { key = 'j_blackboard', rarity = 1, cost = 6 },
    { key = 'j_sixth_sense', rarity = 1, cost = 6 },
    { key = 'j_constellation', rarity = 1, cost = 6 },
    { key = 'j_hiker', rarity = 1, cost = 5 },
    { key = 'j_card_sharp', rarity = 1, cost = 6 },
    { key = 'j_madness', rarity = 1, cost = 7 },
    { key = 'j_seance', rarity = 1, cost = 6 },
    { key = 'j_vampire', rarity = 1, cost = 7 },
    { key = 'j_shortcut', rarity = 1, cost = 7 },
    { key = 'j_hologram', rarity = 1, cost = 7 },
    { key = 'j_cloud_9', rarity = 1, cost = 7 },
    { key = 'j_rocket', rarity = 1, cost = 6 },
    { key = 'j_midas_mask', rarity = 1, cost = 7 },
    { key = 'j_luchador', rarity = 1, cost = 5 },
    { key = 'j_gift', rarity = 1, cost = 6 },
    { key = 'j_turtle_bean', rarity = 1, cost = 6 },
    { key = 'j_erosion', rarity = 1, cost = 6 },
    { key = 'j_to_the_moon', rarity = 1, cost = 5 },
    { key = 'j_stone', rarity = 1, cost = 6 },
    { key = 'j_lucky_cat', rarity = 1, cost = 6 },
    { key = 'j_bull', rarity = 1, cost = 6 },
    { key = 'j_diet_cola', rarity = 1, cost = 6 },
    { key = 'j_trading', rarity = 1, cost = 6 },
    { key = 'j_flash', rarity = 1, cost = 5 },
    { key = 'j_trousers', rarity = 1, cost = 6 },
    { key = 'j_ramen', rarity = 1, cost = 6 },
    { key = 'j_selzer', rarity = 1, cost = 6 },
    { key = 'j_castle', rarity = 1, cost = 6 },
    { key = 'j_mr_bones', rarity = 1, cost = 5 },
    { key = 'j_acrobat', rarity = 1, cost = 6 },
    { key = 'j_sock_and_buskin', rarity = 1, cost = 6 },
    { key = 'j_troubadour', rarity = 1, cost = 6 },
    { key = 'j_certificate', rarity = 1, cost = 6 },
    { key = 'j_smeared', rarity = 1, cost = 7 },
    { key = 'j_throwback', rarity = 1, cost = 6 },
    { key = 'j_rough_gem', rarity = 1, cost = 7 },
    { key = 'j_bloodstone', rarity = 1, cost = 7 },
    { key = 'j_arrowhead', rarity = 1, cost = 7 },
    { key = 'j_onyx_agate', rarity = 1, cost = 7 },
    { key = 'j_glass', rarity = 1, cost = 6 },
    { key = 'j_ring_master', rarity = 1, cost = 5 },
    { key = 'j_flower_pot', rarity = 1, cost = 6 },
    { key = 'j_merry_andy', rarity = 1, cost = 7 },
    { key = 'j_oops', rarity = 1, cost = 4 },
    { key = 'j_idol', rarity = 1, cost = 6 },
    { key = 'j_seeing_double', rarity = 1, cost = 6 },
    { key = 'j_matador', rarity = 1, cost = 7 },
    { key = 'j_satellite', rarity = 1, cost = 7 },
    { key = 'j_cartomancer', rarity = 1, cost = 6 },
    { key = 'j_astronomer', rarity = 1, cost = 8 },
    { key = 'j_bootstraps', rarity = 1, cost = 7 },
}

for _, data in ipairs(modified_jokers) do
    SMODS.Joker:take_ownership(data.key, {
        rarity = data.rarity,
        cost = data.cost,
    })
end

----------------------------------------------------------------------
--- Card Effect
----------------------------------------------------------------------
SMODS.Joker:take_ownership('j_baseball', {
    config = { extra = 1.5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == 1 then
            return {
                x_mult = card.ability.extra,
                message = "X" .. card.ability.extra + 0 .. " Mult",
                colour = G.C.RED
            }
        end
    end
})

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

---------------------------------------------------------------------------
-- LOCALIZATION 
---------------------------------------------------------------------------
if SMODS.Localization then
    -- Bahasa Inggris (EN)
    SMODS.Localization {
        type = 'descriptions',
        key = 'en',
        nodes = {
            Joker = {
                j_baseball = {
                    name = "Baseball Card",
                    text = {
"{C:green}Common{} Jokers",
                    "each give {X:mult,C:white} X#1# {} Mult"
                    }
                }
            }
        }
    }
    
    SMODS.Localization {
        type = 'misc',
        key = 'en',
        nodes = {
            labels = {
                j_baseball = "Baseball Card"
            }
        }
    }

    -- Bahasa Indonesia (ID)
    SMODS.Localization {
        type = 'descriptions',
        key = 'id',
        nodes = {
            Joker = {
                j_baseball = {
                    name = "Kartu Bisbol",
                    text = {
                                      "Setiap {C:green}Uncommon{} Joker",
                    "memberikan {X:mult,C:white} X#1# {} Mult"
                    }
                }
            }
        }
    }
    
    SMODS.Localization {
        type = 'misc',
        key = 'id',
        nodes = {
            labels = {
                j_baseball = "Kartu Bisbol"
            }
        }
    }
end


