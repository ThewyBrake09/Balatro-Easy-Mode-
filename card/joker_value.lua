local custom_costs = {
    ['j_blueprint'] = 10,
    ['j_brainstorm'] = 10,
    ['j_campfire'] = 9,
    ['j_astronomer'] = 8,
    ['j_four_fingers'] = 7,
    ['j_stuntman'] = 7,
    ['j_drivers_license'] = 7,
    ['j_smeared'] = 7,
    ['j_oops'] = 4,
}

local function apply_joker_changes()
    if not G or not G.P_CENTERS then return end

    for key, card_data in pairs(G.P_CENTERS) do
        if type(card_data) == 'table' and card_data.set == 'Joker' then
            local final_cost = custom_costs[key]
            
            if not final_cost then
                local original_rarity = card_data.rarity or 1
                
                if original_rarity == 4 then
                    final_cost = 12
                elseif original_rarity == 3 then
                    final_cost = 8
                elseif original_rarity == 2 then
                    final_cost = 6
                else
                    final_cost = card_data.cost or 4
                end
            end

            card_data.rarity = 1
            card_data.cost = final_cost
            card_data.unlocked = true
            card_data.discovered = true

            if SMODS and SMODS.Centers and SMODS.Centers[key] then
                SMODS.Centers[key].rarity = 1
                SMODS.Centers[key].cost = final_cost
            end

            if SMODS and SMODS.Jokers and SMODS.Jokers[key] then
                SMODS.Jokers[key].rarity = 1
                SMODS.Jokers[key].cost = final_cost
            end
        end
    end

    if G.P_JOKER_RARITY_POOLS then
        G.P_JOKER_RARITY_POOLS[1] = {}
        for key, card_data in pairs(G.P_CENTERS) do
            if card_data.set == 'Joker' and not card_data.demo then
                table.insert(G.P_JOKER_RARITY_POOLS[1], card_data)
            end
        end
    end
end

local ref_reset_globals = Game.reset_game_globals
function Game:reset_game_globals()
    ref_reset_globals(self)
    apply_joker_changes()
end

local ref_init_game = Game.init_game_object
function Game:init_game_object()
    local g = ref_init_game(self)
    apply_joker_changes()
    return g
end
