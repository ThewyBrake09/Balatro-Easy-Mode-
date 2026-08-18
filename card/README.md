# Unbalanced Features 

# How to Activate 
make your way to main.lua and find line 13 you should have something like this
```
local files = {
    "card/joker_pool.lua",
    "card/card_effect.lua", --add this 
    "localization/id.lua",  --this, dont forget ','
    "localization/en-us.lua"  --and this
}
 ```                          
                           
# What it does
* it make ankh joker to create copy of random joker without destroying all of your joker
* it make ectoplasm joker to create negative effect to tour random joker and +1 poker size instead of -1 hand size

### There you go
