# SpireSmiths TCG - Defold Edition
*A Strategic Trading Card Game built with Defold*

## 🎯 Project Vision

SpireSmiths is a Hearthstone-inspired trading card game built with the Defold game engine. The game features strategic turn-based gameplay where players summon creatures, cast spells, and forge their path to victory. Starting as a single-player experience with intelligent AI opponents, SpireSmiths will evolve into a comprehensive TCG platform.

## 🎮 Core Features

### Current Phase (v1.0 - Single Player)
- **Turn-based Strategy**: Classic TCG mechanics with mana management
- **Card Collection**: Diverse cards with unique abilities and effects
- **AI Opponents**: Intelligent computer players with varying difficulty levels
- **Deck Building**: Create and customize your own decks
- **Progressive Gameplay**: Unlock new cards and challenges

### Future Phases
- **Multiplayer Support**: Real-time matches against other players
- **Tournament Mode**: Competitive gameplay with rankings
- **Card Crafting**: Create and customize your own cards
- **Cross-Platform**: Play on mobile, desktop, and web

## 🏗️ Technical Stack

- **Engine**: Defold 1.8.0+
- **Language**: Lua 5.1
- **Platforms**: Android, iOS, macOS, Windows, Linux, HTML5
- **Graphics**: 2D sprites and GUI components
- **Audio**: Defold's built-in audio system
- **Data**: JSON for card data and game state

## 📋 Project Status

| Component | Status |
|-----------|--------|
| Project Setup | 🟡 In Progress |
| Core Game Engine | 🔴 Not Started |
| GUI Framework | 🔴 Not Started |
| AI System | 🔴 Not Started |
| Card System | 🔴 Not Started |

## 🚀 Getting Started

### Prerequisites
- [Defold Editor](https://defold.com/download/) (Latest version)
- Git

### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/cazziuz-realone/TCGLUA.git
   cd TCGLUA
   ```

2. **Open in Defold**
   - Launch Defold Editor
   - Click "Open Project"
   - Navigate to the cloned TCGLUA directory
   - Select the `game.project` file
   - Click "Open"

3. **Build and Run**
   - Press `Ctrl+B` (Windows/Linux) or `Cmd+B` (macOS) to build
   - Press `F5` to run the game
   - Use `Ctrl+R` for hot reload during development

### Development Setup

1. **Configure Editor**
   - Set up your preferred code editor for Lua
   - Install Defold extensions if available
   - Configure hot reload preferences

2. **Project Structure**
   ```
   TCGLUA/
   ├── game.project          # Project configuration
   ├── main/                 # Main collection and bootstrap
   ├── scripts/              # Game logic modules
   ├── gui/                  # GUI scenes and layouts
   ├── assets/               # Images, sounds, fonts
   ├── data/                 # Card data and game content
   └── test/                 # Unit tests
   ```

## 📖 Documentation

- [Game Design Document](docs/GAME_DESIGN.md) - Game mechanics and rules
- [Technical Architecture](docs/ARCHITECTURE.md) - System design and component overview
- [Development Roadmap](docs/ROADMAP.md) - Detailed development phases and milestones
- [Defold Guide](docs/DEFOLD_GUIDE.md) - Defold-specific development patterns
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to the project

## 🎯 Development Phases

### Phase 1: Foundation (4-6 weeks)
- Defold project setup and structure
- Core game entities and data models
- Basic GUI framework
- Card rendering system

### Phase 2: Core Gameplay (6-8 weeks)
- Game state management
- Turn-based game flow
- Card system implementation
- Basic AI implementation

### Phase 3: User Experience (4-6 weeks)
- Complete GUI implementation
- Animations and effects
- Sound and music integration
- Polish and optimization

### Phase 4: Content & Release (3-4 weeks)
- Initial card set creation
- AI difficulty balancing
- Platform-specific builds
- Release preparation

## 🎨 Art & Audio

### Art Style
- **Theme**: Mystical fantasy with smithing/crafting elements
- **Style**: Clean 2D art with hand-drawn feel
- **Resolution**: Scalable vector-style graphics
- **UI**: Modern card game interface design

### Audio
- **Music**: Atmospheric fantasy soundtrack
- **SFX**: Card sounds, spell effects, ambient audio
- **Voice**: Minimal voice acting for key moments

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on our development process.

### Quick Start for Contributors
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes in Defold
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Hearthstone's elegant game design
- Built with the amazing [Defold](https://defold.com/) game engine
- Community feedback and contributions
- King Digital Entertainment for creating Defold

## 📞 Contact

- **Project Lead**: [cazziuz-realone](https://github.com/cazziuz-realone)
- **Issues**: [GitHub Issues](https://github.com/cazziuz-realone/TCGLUA/issues)
- **Discussions**: [GitHub Discussions](https://github.com/cazziuz-realone/TCGLUA/discussions)

## 🎮 Platform Support

- ✅ **Android**: Primary mobile platform
- ✅ **iOS**: Secondary mobile platform  
- ✅ **Windows**: Desktop development and testing
- ✅ **macOS**: Desktop development and testing
- ✅ **Linux**: Desktop development and testing
- ✅ **HTML5**: Web browser play

---

*SpireSmiths - Forge Your Victory* ⚒️🃏

**Built with ❤️ using Defold**