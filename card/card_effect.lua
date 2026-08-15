local custom_ownerships = {
    -- 1. Ectoplasm
    {
        type = "Consumable",
        key = "c_ectoplasm",
        data = {
            use = function(this, card, area, copier)
                G.hand:change_size(1)
                
                local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('ectoplasm_exp'))
                if chosen_joker and not chosen_joker.getting_sliced then
                    chosen_joker:set_edition({negative = true}, true)
                end
            end
        }
    },
    -- 2. Ankh
    {
        type = "Consumable",
        key = "c_ankh",
        data = {
            use = function(this, card, area, copier)
                local eligible_jokers = {}
                for _, v in ipairs(G.jokers.cards) do table.insert(eligible_jokers, v) end
                if #eligible_jokers > 0 then
                    local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('ankh_exp'))
                    local card_to_copy = copy_card(chosen_joker, nil, nil, nil, true)
                    card_to_copy:add_to_deck()
                    G.jokers:emplace(card_to_copy)
                end
            end
        }
    },
}

-- Looping 
for _, item in ipairs(custom_ownerships) do
    if item.type == "Consumable" then
        SMODS.Consumable:take_ownership(item.key, item.data)
    end
end
