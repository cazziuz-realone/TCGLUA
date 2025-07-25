# SpireSmiths TCG - Project Handoff Documentation

## Last Updated: July 25, 2025

## Project Overview
SpireSmiths TCG is a Trading Card Game developed using the Defold game engine with Lua scripting. The project was recently converted from Kotlin and implements a complete TCG framework with AI opponents, card management, and turn-based gameplay.

## Recent Development Activity

### Latest Commit (July 25, 2025 - 18:14:45 UTC)
**Commit:** `5fb2a6db767cdfae7e077eeecf521e4773b87d7b`
**Message:** "Add comprehensive asset naming conventions guide"

**Previous Commits:**
- **16:39:11 UTC:** "Update handoff with Git LFS asset management information"
- **16:38:14 UTC:** "Add Git LFS configuration for game assets"
- **16:37:54 UTC:** "Add Git LFS setup guide for game assets"
- **16:31:30 UTC:** "Update handoff documentation with visual assets information"
- **16:30:42 UTC:** "Add comprehensive visual assets requirements documentation"

## Current Architecture

### Core Systems Implemented

#### 1. Game Controller (`main/game_controller.script`)
- **Purpose:** Main entry point and game flow coordinator
- **Key Features:**
  - Phase management (Init, Main Menu, Deck Builder, Game Setup, Gameplay, Game Over)
  - Scene transitions
  - Input delegation
  - System initialization
- **Status:** ✅ Implemented and functional

#### 2. Game State Management (`scripts/game/game_state.lua`)
- **Purpose:** Core gameplay logic and turn management
- **Key Features:**
  - Turn-based gameplay flow
  - Player state tracking
  - Win condition checking
  - Game event history
  - Phase transitions (Init, Mulligan, Start Turn, Main, End Turn, Game Over)
- **Status:** ✅ Core logic implemented

#### 3. AI Player System (`scripts/ai/ai_player.lua`)
- **Purpose:** AI opponent functionality
- **Key Features:**
  - Multiple difficulty levels
  - Decision-making algorithms
  - Card evaluation systems
- **Status:** ✅ Framework implemented (~15.8KB)

#### 4. Card Database (`scripts/data/card_database.lua`)
- **Purpose:** Card definitions and management
- **Key Features:**
  - Card storage and retrieval
  - Card type definitions
  - Database loading system
- **Status:** ✅ Database framework implemented (~14.9KB)

#### 5. Entity Systems
- **Player Module:** Player state, mana, health, deck management
- **Deck Module:** Deck creation, shuffling, card management
- **Card Entities:** Individual card logic and properties
- **Status:** ✅ Core entities implemented

#### 6. Scene Management (`scripts/ui/scene_manager.lua`)
- **Purpose:** UI scene transitions and management
- **Key Features:**
  - Scene loading/unloading
  - Input handling delegation
  - Scene state management
- **Status:** ✅ Framework implemented

#### 7. Input System (`scripts/input/input_manager.lua`)
- **Purpose:** Centralized input handling
- **Key Features:**
  - Input event processing
  - Action mapping
  - Input delegation to appropriate systems
- **Status:** ✅ Framework implemented

#### 8. GUI System (`gui/main_menu.gui`)
- **Purpose:** User interface implementation
- **Current State:** Basic placeholder GUI using Defold built-ins
- **Status:** 🔄 Basic structure implemented, needs visual assets

#### 9. Asset Management System
- **Git LFS Configuration:** Ready for large visual and audio assets
- **Asset Pipeline:** Configured for efficient game asset storage
- **Naming Conventions:** Comprehensive guidelines established
- **Status:** ✅ Git LFS configured and naming standards ready

### Directory Structure
```
TCGLUA/
├── main/
│   ├── game_controller.script (6.4KB) - Main game controller
│   └── main.collection - Defold scene definition
├── scripts/
│   ├── ai/
│   │   └── ai_player.lua (15.8KB) - AI system
│   ├── data/
│   │   └── card_database.lua (14.9KB) - Card definitions
│   ├── entities/
│   │   ├── player.lua
│   │   ├── deck.lua
│   │   └── [other entity modules]
│   ├── game/
│   │   └── game_state.lua (11.2KB) - Core game logic
│   ├── input/
│   │   └── input_manager.lua - Input handling
│   ├── ui/
│   │   └── scene_manager.lua - UI management
│   └── utils/
│       └── logger.lua - Logging utilities
├── gui/ 
│   ├── main_menu.gui (6.4KB) - Main menu interface
│   └── main_menu.gui_script (5.8KB) - Menu logic
├── graphics/ (ready for assets with naming conventions)
│   ├── ui/ (small assets - regular Git)
│   │   ├── buttons/ (btn_[purpose]_[state].png)
│   │   ├── icons/ (icon_[purpose]_[size].png)
│   │   ├── panels/ (panel_[purpose]_[size].png)
│   │   └── fonts/ (font_[style]_[weight].ttf)
│   ├── cards/ (large assets - Git LFS)
│   │   ├── frames/ (frame_[rarity]_[type].png)
│   │   ├── art/ (card_[category]_[name].png)
│   │   └── backs/ (cardback_[theme].png)
│   ├── backgrounds/ (bg_[scene]_[variant].png)
│   └── gameplay/ (token_[type], indicator_[purpose])
├── audio/ (ready for assets - Git LFS)
├── input/ - Input binding files
├── game.project (3.5KB) - Defold project configuration
├── .gitattributes - Git LFS configuration
├── README.md (5.8KB) - Project documentation
├── HANDOFF.md - Project handoff documentation
├── VISUAL_ASSETS_NEEDED.md - Visual requirements guide
├── GIT_LFS_SETUP.md - Asset management guide
└── ASSET_NAMING_CONVENTIONS.md - Asset naming standards
```

## Current Implementation Status

### ✅ Completed Systems
- Project structure and organization
- Core game loop and state management
- Turn-based gameplay mechanics
- AI player framework
- Card database system
- Scene management
- Input handling
- Entity management (Player, Deck)
- Logging system
- Game event tracking
- Basic GUI structure
- **Git LFS configuration for assets**
- **Asset naming conventions established**

### 🔄 Partially Implemented
- **GUI Interfaces:** Basic main menu exists, using placeholder graphics
- **Card Implementations:** Framework exists but card content needs population
- **Visual Assets:** Currently using Defold built-in placeholder graphics

### ❌ Not Yet Implemented
- **Complete Visual Asset Set** - Standards ready, assets needed
- **Card Content and Balancing** - Database structure ready but cards need creation
- **Audio System** - Placeholder in game controller
- **Save/Load System** - Placeholder in game controller
- **Complete GUI Scenes** - Deck builder, gameplay, game setup UIs
- **Settings Management**
- **Player Progression System**

## Asset Management Ready

### Git LFS Configuration ✅
The repository is now configured for efficient asset storage:
- **Large Assets (Git LFS):** Images, audio, video files automatically stored in LFS
- **Small Assets (Regular Git):** Small UI elements, fonts, code files in regular Git
- **Ready for Development:** Artists and developers can add assets immediately

### Asset Naming Conventions ✅
Comprehensive naming standards established:
- **Consistent Format:** lowercase_with_underscores
- **Descriptive Prefixes:** btn_, icon_, card_, bg_, frame_
- **State Suffixes:** _normal, _hover, _pressed, _disabled
- **Category Organization:** Clear directory structure with purpose-based folders

### Quick Naming Reference:
```
✅ btn_play_normal.png           # UI Button
✅ card_character_fire_knight.png # Card Art
✅ icon_mana_small.png          # UI Icon
✅ bg_main_menu_default.png     # Background
✅ frame_rare_spell.png         # Card Frame
✅ font_title_bold.ttf          # Typography
```

### To Add Visual Assets:
1. **Install Git LFS:** `git lfs install` (one-time setup)
2. **Follow Naming Convention:** Use ASSET_NAMING_CONVENTIONS.md guide
3. **Place in Correct Directory:** Organized by asset type and size
4. **Add and Commit:** `git add graphics/` and `git commit`
5. **Large files automatically handled by LFS**

## Demo Status

### 🎮 **Runnable Demo Available**
The project currently runs as a functional demo in Defold:
- **Main Menu:** Working with placeholder graphics
- **Scene Navigation:** Button clicks transition between game phases
- **Input System:** Mouse and keyboard controls functional
- **Game Loop:** Core systems operational

### 🎨 **Visual State**
- Basic Defold built-in graphics (simple blob shapes)
- Functional but needs visual polish
- All systems ready for asset replacement

See **ASSET_NAMING_CONVENTIONS.md** for detailed asset preparation guidelines.

## Next Development Priorities

### High Priority
1. **Visual Asset Creation** - Follow naming conventions from ASSET_NAMING_CONVENTIONS.md
2. **Asset Integration** - Replace placeholder graphics with proper art
3. **Card Content Creation** - Populate card database with actual game cards
4. **GUI Scene Enhancement** - Improve visual quality of all interfaces

### Medium Priority
1. **Save/Load System** - Implement persistent game data
2. **Audio Integration** - Add music and sound effects using Git LFS
3. **Game Balance** - Tune gameplay mechanics and card abilities
4. **Settings System** - Add game configuration options

### Low Priority
1. **Advanced AI** - Improve AI decision-making algorithms
2. **Player Progression** - Add unlockable content
3. **Analytics** - Add player behavior tracking
4. **Platform Optimization** - Optimize for specific platforms

## Development Guidelines

### Code Standards
- Follow existing modular structure
- Use comprehensive logging for debugging
- Maintain separation between game logic and presentation
- Document new modules and functions
- Follow Lua and Defold best practices

### Asset Integration
- **Use established naming conventions** (see ASSET_NAMING_CONVENTIONS.md)
- Use Git LFS for large assets (automatically configured)
- Use Defold Atlas files for efficient sprite packing
- Maintain consistent art style and color palette
- Optimize textures for mobile compatibility
- Test asset loading in Defold before committing

### Testing Approach
- Test core game mechanics thoroughly
- Validate AI behavior across difficulty levels
- Ensure proper scene transitions
- Test input handling across different scenarios
- Validate game state consistency
- Verify asset loading and display

## Known Issues & Technical Debt
- GUI uses placeholder Defold built-in graphics
- Card deck creation functions return empty decks (need content)
- Audio and save systems are placeholder implementations
- AI evaluation functions need refinement with actual card data

## Documentation Files
- **HANDOFF.md** - This project handoff document
- **VISUAL_ASSETS_NEEDED.md** - Comprehensive visual requirements
- **ASSET_NAMING_CONVENTIONS.md** - Detailed asset naming standards
- **GIT_LFS_SETUP.md** - Asset management and Git LFS guide
- **README.md** - General project information

## Repository Information
- **Repository:** https://github.com/cazziuz-realone/TCGLUA
- **Main Branch:** main
- **Last Commit:** 5fb2a6db767cdfae7e077eeecf521e4773b87d7b
- **License:** Not specified
- **Contributors:** Cazziuz (argotzcreations@gmail.com)

---

**Handoff Status:** Project has complete technical foundation with established asset management and naming standards. Ready for visual asset creation and integration.

**Next Developer Notes:** 
1. Install Git LFS locally: `git lfs install`
2. Review ASSET_NAMING_CONVENTIONS.md for proper file naming
3. Create or commission visual assets following naming guidelines
4. Place assets in appropriate directories (will auto-use LFS for large files)
5. Test asset integration in Defold
6. Populate card database with actual game content
7. Enhance GUI scenes with new visual assets
