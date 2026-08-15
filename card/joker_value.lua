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
    for key, card_data in pairs(G.P_CENTERS) do
        if card_data.set == 'Joker' then
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
        end
    end
end

local original_start_up = Game.start_up
function Game:start_up()
    original_start_up(self)
    apply_joker_changes()
end

local original_init_game_object = Game.init_game_object
function Game:init_game_object(self)
    local g = original_init_game_object(self)
    apply_joker_changes()
    return g
end
