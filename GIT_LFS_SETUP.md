# Git LFS Setup for SpireSmiths TCG Assets

## What is Git LFS?
Git Large File Storage (LFS) is designed to handle large binary files efficiently in Git repositories. Instead of storing the actual large files in Git history, it stores lightweight pointer files and keeps the actual content on a separate server.

## When to Use Git LFS for This Project

### ✅ Use Git LFS for:
- **Card artwork** (> 1MB per image)
- **High-resolution backgrounds** (> 5MB)
- **Audio files** (.mp3, .wav, .ogg)
- **Large texture atlases** (> 10MB)
- **Video files** (.mp4, .webm)
- **3D models** (if any, .fbx, .obj)

### ✅ Keep in Regular Git:
- **Small UI icons** (< 500KB)
- **Font files** (< 2MB)
- **Small button textures** (< 1MB)
- **Code and configuration files**
- **Small sound effects** (< 1MB)

## Setup Instructions

### 1. Install Git LFS
```bash
# Download and install Git LFS from: https://git-lfs.github.io/
# Or via package managers:

# macOS
brew install git-lfs

# Windows (with Chocolatey)
choco install git-lfs

# Ubuntu/Debian
sudo apt install git-lfs
```

### 2. Initialize LFS in Repository
```bash
cd /path/to/TCGLUA
git lfs install
```

### 3. Configure File Types for LFS
Create/edit `.gitattributes` file in repository root:

```gitattributes
# Large images
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.tga filter=lfs diff=lfs merge=lfs -text
*.psd filter=lfs diff=lfs merge=lfs -text

# Audio files
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.m4a filter=lfs diff=lfs merge=lfs -text

# Video files
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.webm filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text

# 3D models and textures
*.fbx filter=lfs diff=lfs merge=lfs -text
*.obj filter=lfs diff=lfs merge=lfs -text
*.dae filter=lfs diff=lfs merge=lfs -text

# Large atlas files
*.atlas filter=lfs diff=lfs merge=lfs -text

# Exclude small icons and UI elements from LFS
# (Add specific patterns if needed)
graphics/ui/icons/*.png !filter !diff !merge text
graphics/ui/small/*.png !filter !diff !merge text
```

### 4. Add and Commit Configuration
```bash
git add .gitattributes
git commit -m "Configure Git LFS for game assets"
git push
```

### 5. Adding Assets
```bash
# Add your visual assets normally
git add graphics/
git commit -m "Add card artwork and backgrounds"
git push
```

## GitHub LFS Quotas and Costs

### Free GitHub Account:
- **Storage:** 1GB included
- **Bandwidth:** 1GB/month included
- **Additional:** $5/month per 50GB storage + 50GB bandwidth

### GitHub Pro ($4/month):
- **Storage:** 1GB included  
- **Bandwidth:** 1GB/month included
- **Additional:** Same pricing as free

### Recommendations:
- Monitor usage in repository settings
- Compress images before adding when possible
- Use efficient formats (WebP instead of PNG for some cases)

## Alternative: Selective LFS Usage

For cost efficiency, you might want to be selective:

```gitattributes
# Only very large files in LFS
*.png filter=lfs diff=lfs merge=lfs -text size=5MB
*.jpg filter=lfs diff=lfs merge=lfs -text size=5MB

# Audio always in LFS
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
```

## Directory Structure Recommendation

```
TCGLUA/
├── graphics/
│   ├── ui/                    # Small UI elements (regular Git)
│   │   ├── icons/            # < 500KB each
│   │   ├── buttons/          # < 1MB each  
│   │   └── fonts/            # < 2MB each
│   ├── cards/                # Large assets (Git LFS)
│   │   ├── art/              # High-res card art
│   │   └── frames/           # Card frame templates
│   ├── backgrounds/          # Large backgrounds (Git LFS)
│   └── atlas/               # Compiled atlases (Git LFS)
├── audio/                    # All audio (Git LFS)
│   ├── music/
│   ├── sfx/
│   └── voice/
└── [existing project files]
```

## Commands Reference

```bash
# Check LFS status
git lfs status

# See LFS files
git lfs ls-files

# Track new file types
git lfs track "*.extension"

# See tracking patterns
git lfs track

# Check LFS usage
git lfs env
```

## Migration of Existing Files

If you already have large files in Git history:
```bash
# Migrate existing files to LFS
git lfs migrate import --include="*.png,*.jpg,*.mp3,*.wav"

# Push migrated repository
git push --force-with-lease
```

---

**Recommendation for SpireSmiths TCG:**
Use Git LFS for card art, backgrounds, and audio, but keep small UI elements in regular Git to minimize bandwidth usage.
