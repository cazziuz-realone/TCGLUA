# SpireSmiths TCG - Asset Naming Conventions

## Overview
Consistent naming conventions ensure easy asset management, automated loading, and seamless integration with the game code. This guide covers all visual asset types for the SpireSmiths TCG project.

## General Naming Rules

### 🔤 **Base Conventions**
- **Lowercase only** - No uppercase letters
- **Underscores** for word separation (no spaces, hyphens, or camelCase)
- **Descriptive names** - Clear purpose from filename
- **Consistent prefixes** - Group related assets
- **No special characters** - Only letters, numbers, underscores
- **Meaningful suffixes** - Indicate variations, states, sizes

### 📏 **Size/Resolution Suffixes**
- `_small` - Small version (e.g., 64x64)
- `_medium` - Medium version (e.g., 128x128) 
- `_large` - Large version (e.g., 256x256)
- `_hd` - High definition/retina version
- `_thumb` - Thumbnail version

### 🎨 **State Suffixes**
- `_normal` - Default state
- `_hover` - Mouse hover state
- `_pressed` - Clicked/pressed state
- `_disabled` - Inactive/disabled state
- `_selected` - Selected state

## Directory Structure & Naming

```
graphics/
├── ui/                          # Small UI elements (regular Git)
│   ├── buttons/                 # Button graphics
│   ├── panels/                  # UI panel backgrounds
│   ├── icons/                   # Small icons and symbols
│   ├── frames/                  # Window frames and borders
│   └── fonts/                   # Font files
├── cards/                       # Large card assets (Git LFS)
│   ├── frames/                  # Card frame templates
│   ├── art/                     # Card artwork
│   │   ├── characters/          # Character illustrations
│   │   ├── spells/             # Spell effect artwork
│   │   ├── items/              # Item illustrations
│   │   └── environments/       # Location artwork
│   └── backs/                  # Card back designs
├── backgrounds/                 # Scene backgrounds (Git LFS)
│   ├── menus/                  # Menu backgrounds
│   ├── gameplay/               # Game field backgrounds
│   └── effects/                # Background effects
└── gameplay/                   # Game field elements
    ├── tokens/                 # Mana, health tokens
    ├── indicators/             # Targeting, selection indicators
    └── board/                  # Game board elements
```

## Specific Asset Naming Conventions

### 🖱️ **UI Buttons** (`graphics/ui/buttons/`)
```
btn_[purpose]_[state].png

Examples:
btn_play_normal.png
btn_play_hover.png
btn_play_pressed.png
btn_cancel_normal.png
btn_deck_builder_normal.png
btn_settings_disabled.png
btn_confirm_large_normal.png
```

### 🎴 **Card Frames** (`graphics/cards/frames/`)
```
frame_[rarity]_[type].png

Examples:
frame_common_creature.png
frame_rare_spell.png
frame_epic_item.png
frame_legendary_environment.png
frame_basic_neutral.png
```

### 🎨 **Card Artwork** (`graphics/cards/art/`)
```
card_[category]_[name].png

Examples:
card_character_fire_knight.png
card_character_ice_wizard.png
card_spell_lightning_bolt.png
card_spell_healing_potion.png
card_item_iron_sword.png
card_item_magic_shield.png
card_environment_dark_forest.png
```

### 🃏 **Card Backs** (`graphics/cards/backs/`)
```
cardback_[theme].png

Examples:
cardback_default.png
cardback_premium.png
cardback_guild_fire.png
cardback_guild_water.png
```

### 🏞️ **Backgrounds** (`graphics/backgrounds/`)
```
bg_[scene]_[variant].png

Examples:
bg_main_menu_default.png
bg_deck_builder_workshop.png
bg_gameplay_arena.png
bg_game_over_victory.png
bg_game_over_defeat.png
bg_settings_scroll.png
```

### 🔸 **Icons** (`graphics/ui/icons/`)
```
icon_[purpose]_[size].png

Examples:
icon_mana_small.png
icon_health_medium.png
icon_attack_small.png
icon_defense_small.png
icon_fire_element.png
icon_water_element.png
icon_settings_gear.png
icon_deck_cards.png
```

### 🎮 **Gameplay Elements** (`graphics/gameplay/`)
```
[category]_[name]_[variant].png

Examples:
token_mana_crystal_blue.png
token_health_heart_red.png
indicator_target_arrow.png
indicator_selection_glow.png
board_player_area.png
board_card_slot.png
```

### 📜 **UI Panels** (`graphics/ui/panels/`)
```
panel_[purpose]_[size].png

Examples:
panel_card_info_medium.png
panel_player_stats.png
panel_game_log.png
panel_settings_menu.png
panel_deck_list.png
```

## Font Naming (`graphics/ui/fonts/`)
```
font_[style]_[weight].ttf/.otf

Examples:
font_title_bold.ttf        # Main game title
font_ui_regular.ttf        # UI elements
font_card_regular.ttf      # Card text
font_flavor_italic.ttf     # Card flavor text
font_numbers_bold.ttf      # Stats, numbers
```

## Defold-Specific Considerations

### 🗂️ **Atlas Naming**
When creating Defold atlases, use descriptive names:
```
ui_elements.atlas          # Small UI elements
card_frames.atlas          # Card frame templates
card_art_set1.atlas        # First batch of card art
backgrounds.atlas          # Scene backgrounds
gameplay_tokens.atlas      # Game tokens and indicators
```

### 🎯 **Defold Resource IDs**
In Defold, your assets will be referenced like:
```lua
-- In code, assets are referenced by their atlas path
gui.set_texture(node, "ui_elements/btn_play_normal")
gui.set_texture(node, "card_frames/frame_rare_spell")
```

## Asset Organization Examples

### ✅ **Good Examples:**
```
✅ btn_play_normal.png
✅ card_character_fire_knight.png
✅ icon_mana_small.png
✅ bg_main_menu_default.png
✅ frame_legendary_creature.png
✅ token_health_heart_red.png
```

### ❌ **Bad Examples:**
```
❌ PlayButton.png              # Uppercase, no state
❌ Fire Knight Card.png        # Spaces, unclear category
❌ mana-icon.png              # Hyphens instead of underscores
❌ Background1.jpg            # Unclear purpose, numbered
❌ legendary_frame.PNG        # Wrong extension case
❌ heart token (red).png      # Spaces and parentheses
```

## Code Integration Examples

### 🔧 **In Defold GUI Scripts:**
```lua
-- Loading button states
local button_normal = "ui_elements/btn_play_normal"
local button_hover = "ui_elements/btn_play_hover"
local button_pressed = "ui_elements/btn_play_pressed"

-- Loading card components
local card_frame = "card_frames/frame_rare_spell"
local card_art = "card_art/card_spell_lightning_bolt"
```

### 🎴 **In Card Database:**
```lua
-- Card definition referencing assets
{
    id = "lightning_bolt",
    name = "Lightning Bolt",
    frame_asset = "frame_common_spell",
    art_asset = "card_spell_lightning_bolt",
    icon_asset = "icon_lightning_element"
}
```

## File Size Guidelines

### 📏 **Recommended Resolutions:**
- **Button textures:** 200x60px (normal), 400x120px (large)
- **Card frames:** 400x600px 
- **Card art:** 350x250px (fits within frame)
- **Icons:** 64x64px (small), 128x128px (medium)
- **Backgrounds:** 1920x1080px (full screen)
- **UI panels:** Variable, based on content

### 💾 **File Size Targets:**
- **Small UI elements:** < 100KB each
- **Card art:** < 500KB each  
- **Backgrounds:** < 2MB each
- **Icons:** < 50KB each

## Quality Assurance Checklist

### ✅ **Before Adding Assets:**
- [ ] Filename follows naming convention
- [ ] Placed in correct directory
- [ ] Appropriate file size and resolution
- [ ] PNG for transparency, JPG for opaque backgrounds
- [ ] No duplicate or similar names
- [ ] Consistent visual style with existing assets
- [ ] High contrast for mobile readability

### 🔍 **Testing in Defold:**
- [ ] Asset loads correctly in atlas
- [ ] No texture bleeding or artifacts
- [ ] Scales properly on different screen sizes
- [ ] Performance acceptable (check draw calls)

## Automation Possibilities

### 🤖 **Batch Renaming Script Example:**
If you have assets that don't follow the convention, you can create batch rename scripts:

```bash
# Example batch rename (bash/PowerShell)
# Rename "PlayButton.png" to "btn_play_normal.png"
for file in *.png; do
    # Your renaming logic here
done
```

### 📋 **Asset Manifest Generation:**
Consider maintaining an asset manifest for code reference:
```lua
-- Auto-generated asset references
ASSETS = {
    BUTTONS = {
        PLAY_NORMAL = "ui_elements/btn_play_normal",
        PLAY_HOVER = "ui_elements/btn_play_hover"
    },
    CARDS = {
        FRAMES = {
            COMMON_SPELL = "card_frames/frame_common_spell"
        }
    }
}
```

---

**Key Takeaway:** Follow these conventions from the start to avoid massive renaming later. Consistent naming makes asset management, code integration, and team collaboration much smoother!

**Quick Start:** Begin with UI buttons and icons following these conventions, then expand to cards and backgrounds as you create them.
