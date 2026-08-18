# Changelog

All notable changes to this project will be documented in this file.


## [2.0.0] - 2026-8-18

### Added
- New startup money mechanic only applies on new run (access it through mod config ingame)
- Support other custom rarity while respecting their original rarity visual 
- All joker have equal odds (including your custom cards mods)

### Changed
- All joker still have their original rarity tag on card
- Deleting raritylock functions, and lot of unused file
- Legendary Joker rebalance cost $20 before $12
- Baseball Joker back to their original effect


## [1.0.2-beta] - 2026-08-15

### Added
- Initial card_logic.lua

### Changed
- Cleaning the code a bit
- Language update
- Compatible with all other mods

### Minor Fix
- Fix uncommon rare legendary joker won't appear in shop because of compatibility update
- Fix other mod description into nil value
- Compatible with other mods without any weird thing happen
- I forgot to enable new joker baseball effect


## [1.0.1-beta] - 2026-08-14

### Added
- Initial card_effects.lua
- Initial joker_value.lua
- Initial override.lua

### Changed 
- The Soul : Updated card generation logic to pull from the 5 custom-commonized legendary Jokers while respecting active rarity configurations.
- Baseball Card : Reworked the Joker so that Common Jokers each grant $\times 1.5$ Mult.
- Ankh and Ectoplasma revamp
- Update en-us.lua


## [1.0.0-beta] - 2026-08-12

### Added
- Easier Joker pool.
- Rarity Locking System.
- Joker Duplicate Toggle.
- Initial CHANGELOG.md
- Initial README.md
- Initial manifest.json
- Initial localization (id)
- 
