# SpireSmiths TCG - Visual Assets Requirements

## Current State
The project currently uses basic Defold built-in assets:
- `/builtins/fonts/default.font` - Basic system font
- `/builtins/graphics/particle_blob.png` - Simple blob texture for buttons
- Solid color rectangles for UI backgrounds

## Required Visual Assets

### 🎨 **UI/Interface Assets**

#### **Fonts & Typography**
- [ ] **Game Title Font** - Fantasy/medieval style for "SpireSmiths" branding
- [ ] **Card Text Font** - Readable serif/sans-serif for card descriptions
- [ ] **UI Text Font** - Clean sans-serif for buttons, labels, numbers
- [ ] **Flavor Text Font** - Italic style for card flavor text

#### **Buttons & UI Elements**
- [ ] **Button Backgrounds** - 9-slice sprites for various button styles
  - Primary action buttons (Play, Confirm)
  - Secondary buttons (Cancel, Back)
  - Deck builder buttons
  - Card action buttons
- [ ] **Button States** - Normal, hover, pressed, disabled variants
- [ ] **UI Panels** - Background panels for different sections
- [ ] **Window Frames** - Decorative borders for popup windows
- [ ] **Progress Bars** - Health bars, mana bars, loading bars
- [ ] **Icons Set** - Mana symbols, card types, status effects

#### **Menu Backgrounds**
- [ ] **Main Menu Background** - Atmospheric TCG scene
- [ ] **Deck Builder Background** - Workshop/library themed
- [ ] **Game Setup Background** - Tournament/arena themed
- [ ] **Game Over Background** - Victory/defeat variations

### 🃏 **Card System Assets**

#### **Card Frames & Borders**
- [ ] **Base Card Frame** - Standard card border template
- [ ] **Rarity Borders** - Common, Rare, Epic, Legendary variations
- [ ] **Card Type Frames** - Different frame styles for card types
- [ ] **Foil/Holographic Effects** - Premium card treatments

#### **Card Art & Illustrations**
- [ ] **Character Cards** - Heroes, creatures, NPCs (50-100+ unique pieces)
- [ ] **Spell Cards** - Magic effects, abilities, spells (30-50+ pieces)
- [ ] **Item Cards** - Weapons, armor, artifacts (20-40+ pieces)
- [ ] **Environment Cards** - Locations, structures (10-20+ pieces)

#### **Card UI Elements**
- [ ] **Mana Cost Backgrounds** - Circular/hexagonal mana cost display
- [ ] **Attack/Health Boxes** - Corner elements for creature stats
- [ ] **Card Back Design** - Consistent card back when face-down
- [ ] **Card Hover Effects** - Glow, shadow, highlight states

### 🎮 **Gameplay Field Assets**

#### **Game Board Elements**
- [ ] **Play Field Background** - Main battle area
- [ ] **Player Areas** - Distinct zones for each player
- [ ] **Card Zones** - Hand area, deck area, discard pile markers
- [ ] **Turn Indicator** - Visual cue for whose turn it is

#### **Game Pieces**
- [ ] **Mana Crystals** - Individual mana gems/tokens
- [ ] **Health Tokens** - Damage counters, health markers
- [ ] **Status Effect Icons** - Buffs, debuffs, conditions
- [ ] **Targeting Indicators** - Arrow, crosshair, selection highlights

### ✨ **Effects & Animations**

#### **Particle Effects** (Can be created in Defold)
- [ ] **Card Draw Effects** - Sparkles, energy trails
- [ ] **Spell Cast Effects** - Magic circles, energy bursts
- [ ] **Damage Effects** - Impact flashes, damage numbers
- [ ] **Healing Effects** - Restoration sparkles, green energy

#### **UI Animations** (Defold Timeline-based)
- [ ] **Card Movement** - Smooth card transitions
- [ ] **Button Animations** - Hover, press feedback
- [ ] **Screen Transitions** - Fade, slide, scale effects
- [ ] **Victory/Defeat Animations** - Celebration/defeat sequences

### 🔧 **Technical Specifications**

#### **Image Formats**
- **PNG** for UI elements with transparency
- **JPG** for large backgrounds without transparency
- **Atlas Textures** for efficient memory usage

#### **Resolution Requirements**
- **UI Elements:** 1920x1080 base resolution (scale for mobile)
- **Card Art:** 400x600px minimum (2x for high-DPI)
- **Backgrounds:** 1920x1080 or larger
- **Icons:** 64x64px base (with 2x variants)

#### **Art Style Guidelines**
- **Consistent Color Palette** - Define 8-12 core colors
- **Fantasy/Medieval Theme** - Match "SpireSmiths" branding
- **High Contrast** - Ensure readability on various devices
- **Scalable Design** - Works on mobile and desktop

### 📁 **Recommended Asset Organization**
```
/graphics/
├── ui/
│   ├── fonts/
│   ├── buttons/
│   ├── panels/
│   ├── icons/
│   └── backgrounds/
├── cards/
│   ├── frames/
│   ├── art/
│   │   ├── characters/
│   │   ├── spells/
│   │   ├── items/
│   │   └── environments/
│   └── effects/
├── gameplay/
│   ├── board/
│   ├── tokens/
│   └── indicators/
└── effects/
    ├── particles/
    └── animations/
```

### 🎯 **Priority Levels**

#### **High Priority (MVP)**
1. Basic UI button/panel textures to replace built-in blobs
2. Card frame templates (at least 1 design)
3. Placeholder card art (10-15 cards minimum)
4. Game field background
5. Essential icons (mana, health, etc.)

#### **Medium Priority**
1. Improved fonts and typography
2. Complete card art set (50+ cards)
3. Multiple card frame variations
4. Enhanced backgrounds for all scenes
5. Status effect icons and UI polish

#### **Low Priority (Polish)**
1. Particle effects and animations
2. Foil/premium card treatments
3. Advanced UI transitions
4. Multiple background variations
5. Achievement/progression graphics

### 🛠 **Implementation Notes**

#### **Defold Integration**
- Use **Atlas files** (.atlas) to pack multiple sprites efficiently
- Create **GUI scenes** (.gui) for each screen/menu
- Use **Materials** (.material) for special effects
- Implement **Spine** animations for complex character animations (optional)

#### **Performance Considerations**
- Keep texture atlas sizes under 2048x2048 for compatibility
- Use texture compression where appropriate
- Implement LOD (Level of Detail) for mobile devices
- Consider dynamic loading for large card sets

---

**Next Steps:**
1. Create basic UI texture replacements for current placeholder graphics
2. Design card frame templates
3. Commission or create initial card art set
4. Implement improved backgrounds and typography
5. Add polish effects and animations

**Current Status:** Using basic Defold built-ins, needs complete visual overhaul for production quality.
