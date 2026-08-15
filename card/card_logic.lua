local joker_ownerships = {
    -- 3. Baseball Card
    {
        type = "Joker",
        key = "j_baseball",
        data = {
            config = { extra = 1.5 },
            loc_vars = function(self, info_queue, card)
                return { vars = { card.ability.extra } }
            end,
            calculate = function(self, card, context)
                if context.other_joker and context.other_joker.config.center.rarity == 1 then
                    return {
                        x_mult = card.ability.extra,
                        message = "X" .. card.ability.extra .. " Mult",
                        colour = G.C.RED
                    }
                end
            end
        }
    }
}

-- Looping 
for _, item in ipairs(joker_ownerships) do
    if item.type:lower() == "joker" then
        SMODS.Joker:take_ownership(item.key, item.data)
    end
end
