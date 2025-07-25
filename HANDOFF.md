# SpireSmiths TCG - Project Handoff Documentation

## Last Updated: July 25, 2025

## Project Overview
SpireSmiths TCG is a Trading Card Game developed using the Defold game engine with Lua scripting. The project was recently converted from Kotlin and implements a complete TCG framework with AI opponents, card management, and turn-based gameplay.

## Recent Development Activity

### Latest Commit (July 25, 2025 - 16:30:42 UTC)
**Commit:** `f19e7039dff89eb196448a57ac0f3f691256de07`
**Message:** "Add comprehensive visual assets requirements documentation"

**Previous Commits:**
- **16:19:01 UTC:** "Add project handoff documentation"
- **08:36:38 UTC:** "Add GUI components, scene management, input handling, AI system and card database"
- **08:28:03 UTC:** "Add core game entities and systems converted from Kotlin to Lua"
- **08:24:11 UTC:** "Initialize Defold project structure with main game controller"

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
├── input/ - Input binding files
├── game.project (3.5KB) - Defold project configuration
├── README.md (5.8KB) - Project documentation
├── HANDOFF.md - Project handoff documentation
└── VISUAL_ASSETS_NEEDED.md - Visual requirements guide
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

## Visual Assets Current State

The project currently uses basic Defold built-in assets:
- Default system font for all text
- Simple particle blob texture for buttons and backgrounds
- Solid color rectangles for UI elements

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
4. **Asset Integration Pipeline** - Set up efficient workflow for art integration

### Medium Priority
1. **Save/Load System** - Implement persistent game data
2. **Audio Integration** - Add music and sound effects
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
- Need complete visual asset pipeline
- AI evaluation functions need refinement with actual card data

## Documentation Files
- **HANDOFF.md** - This project handoff document
- **VISUAL_ASSETS_NEEDED.md** - Comprehensive visual requirements
- **README.md** - General project information

## Repository Information
- **Repository:** https://github.com/cazziuz-realone/TCGLUA
- **Main Branch:** main
- **Last Commit:** f19e7039dff89eb196448a57ac0f3f691256de07
- **License:** Not specified
- **Contributors:** Cazziuz (argotzcreations@gmail.com)

---

**Handoff Status:** Project has solid technical foundation. Primary need is visual asset creation and card content development.

**Next Developer Notes:** 
1. Review VISUAL_ASSETS_NEEDED.md for art requirements
2. Create or commission visual assets to replace placeholders
3. Populate card database with actual game content
4. Implement remaining GUI scenes using new visual assets
