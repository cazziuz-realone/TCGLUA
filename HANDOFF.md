# SpireSmiths TCG - Project Handoff Documentation

## Last Updated: July 25, 2025

## Project Overview
SpireSmiths TCG is a Trading Card Game developed using the Defold game engine with Lua scripting. The project was recently converted from Kotlin and implements a complete TCG framework with AI opponents, card management, and turn-based gameplay.

## Recent Development Activity

### Latest Commit (July 25, 2025 - 16:38:14 UTC)
**Commit:** `fa8f1a586a2e3a7eb559b4852cb7364b256d6d83`
**Message:** "Add Git LFS configuration for game assets"

**Previous Commits:**
- **16:37:54 UTC:** "Add Git LFS setup guide for game assets"
- **16:31:30 UTC:** "Update handoff documentation with visual assets information"
- **16:30:42 UTC:** "Add comprehensive visual assets requirements documentation"
- **16:19:01 UTC:** "Add project handoff documentation"
- **08:36:38 UTC:** "Add GUI components, scene management, input handling, AI system and card database"

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
- **Status:** ✅ Git LFS configured and ready

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
├── graphics/ (ready for assets)
│   ├── ui/ (small assets - regular Git)
│   ├── cards/ (large assets - Git LFS)
│   ├── backgrounds/ (large assets - Git LFS)
│   └── atlas/ (compiled atlases - Git LFS)
├── audio/ (ready for assets - Git LFS)
├── input/ - Input binding files
├── game.project (3.5KB) - Defold project configuration
├── .gitattributes - Git LFS configuration
├── README.md (5.8KB) - Project documentation
├── HANDOFF.md - Project handoff documentation
├── VISUAL_ASSETS_NEEDED.md - Visual requirements guide
└── GIT_LFS_SETUP.md - Asset management guide
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

### 🔄 Partially Implemented
- **GUI Interfaces:** Basic main menu exists, using placeholder graphics
- **Card Implementations:** Framework exists but card content needs population
- **Visual Assets:** Currently using Defold built-in placeholder graphics

### ❌ Not Yet Implemented
- **Complete Visual Asset Set** - See VISUAL_ASSETS_NEEDED.md for details
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

### To Add Visual Assets:
1. **Install Git LFS:** `git lfs install` (one-time setup)
2. **Add Assets:** Place files in appropriate directories
3. **Commit Normally:** `git add graphics/` and `git commit`
4. **Large files automatically handled by LFS**

See **GIT_LFS_SETUP.md** for detailed instructions.

## Visual Assets Current State

The project currently uses basic Defold built-in assets:
- Default system font for all text
- Simple particle blob texture for buttons and backgrounds
- Solid color rectangles for UI elements

**Ready for Asset Integration:**
- Directory structure planned and ready
- Git LFS configured for large files
- Defold project structure supports immediate asset addition

**Immediate Visual Needs:**
1. **UI Textures** - Button backgrounds, panels, frames
2. **Fonts** - Game-appropriate typography (fantasy/medieval style)
3. **Card Frames** - Basic card border templates
4. **Background Art** - Scene backgrounds for different game phases
5. **Icons** - Mana symbols, status effects, card types

See **VISUAL_ASSETS_NEEDED.md** for comprehensive visual requirements.

## Next Development Priorities

### High Priority
1. **Visual Asset Creation** - Replace placeholder graphics with game-appropriate art
2. **Card Content Creation** - Populate card database with actual game cards
3. **GUI Scene Implementation** - Create deck builder, gameplay, and other UI scenes
4. **Asset Integration** - Add created assets to the configured Git LFS system

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
- Use Git LFS for large assets (automatically configured)
- Use Defold Atlas files for efficient sprite packing
- Maintain consistent art style and color palette
- Optimize textures for mobile compatibility
- Follow naming conventions for easy asset management

### Testing Approach
- Test core game mechanics thoroughly
- Validate AI behavior across difficulty levels
- Ensure proper scene transitions
- Test input handling across different scenarios
- Validate game state consistency

## Known Issues & Technical Debt
- GUI uses placeholder Defold built-in graphics
- Card deck creation functions return empty decks (need content)
- Audio and save systems are placeholder implementations
- AI evaluation functions need refinement with actual card data

## Documentation Files
- **HANDOFF.md** - This project handoff document
- **VISUAL_ASSETS_NEEDED.md** - Comprehensive visual requirements
- **GIT_LFS_SETUP.md** - Asset management and Git LFS guide
- **README.md** - General project information

## Repository Information
- **Repository:** https://github.com/cazziuz-realone/TCGLUA
- **Main Branch:** main
- **Last Commit:** fa8f1a586a2e3a7eb559b4852cb7364b256d6d83
- **License:** Not specified
- **Contributors:** Cazziuz (argotzcreations@gmail.com)

---

**Handoff Status:** Project has solid technical foundation and is ready for asset integration. Git LFS configured for efficient large file management.

**Next Developer Notes:** 
1. Install Git LFS locally: `git lfs install`
2. Review VISUAL_ASSETS_NEEDED.md for art requirements
3. Create or commission visual assets
4. Add assets to appropriate directories (will auto-use LFS for large files)
5. Populate card database with actual game content
6. Implement remaining GUI scenes using new visual assets
