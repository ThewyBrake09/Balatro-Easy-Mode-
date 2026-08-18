function SMODS.poll_rarity(_type, _key)
    local available_rarities = {}
    local total_cards = 0

    for _, center in pairs(G.P_CENTER_POOLS['Joker']) do
        if not center.no_pool_spawn then
            local r = center.rarity
            if r then
                available_rarities[r] = (available_rarities[r] or 0) + 1
                total_cards = total_cards + 1
            end
        end
    end

    if total_cards == 0 then return 1 end

    local rand = pseudorandom(_key or 'random') * total_cards
    local current_weight = 0

    for rarity_key, count in pairs(available_rarities) do
        current_weight = current_weight + count
        if rand <= current_weight then
            return rarity_key
        end
    end

    return 1 
end
