-- soul ex legend card logic
function c_override(legendary, _type, forced_key)
    if legendary and _type == 'Joker' and not forced_key then
        local legendary_pool = {'j_perkeo', 'j_triboulet', 'j_yorick', 'j_chicot', 'j_caino'}
        forced_key = pseudorandom_element(legendary_pool, pseudoseed('soul_common_pool'))
        legendary = false
    end
    return legendary, forced_key
end

