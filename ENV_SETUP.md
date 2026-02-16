# Environment Configuration Setup

## Overview

The app now uses a `.env` file to securely manage the TMDB API key. This keeps sensitive credentials out of your source code and git history.

---

## Quick Setup

### 1. **Edit the .env file**

```bash
# Open .env in your editor
open .env
```

Add your TMDB API key:

```bash
TMDB_API_KEY=your_actual_api_key_from_tmdb
```

### 2. **Generate Config.swift**

**Option A: Run the script manually**

```bash
./Scripts/generate-config.sh
```

**Option B: Automatic in Xcode (Recommended)**
Add a Build Phase (see instructions below)

---

## Setting Up Xcode Build Phase (Recommended)

This automatically updates `Config.swift` every time you build the app.

### Steps:

1. **Open your project in Xcode**
2. **Select the project** in the navigator
3. **Select your app target**
4. **Go to "Build Phases" tab**
5. **Click "+" → "New Run Script Phase"**
6. **Drag the new phase** above "Compile Sources"
7. **Rename it** to "Generate Config from .env"
8. **Add this script:**

```bash
# Generate Config.swift from .env
"${SRCROOT}/Scripts/generate-config.sh"
```

9. **Expand "Input Files"** and add:

```
$(SRCROOT)/.env
```

10. **Expand "Output Files"** and add:

```
$(SRCROOT)/Config.swift
```

Now Config.swift will be automatically generated from .env on every build!

---

## Manual Generation

If you prefer not to use the build phase:

```bash
# After editing .env, run:
./Scripts/generate-config.sh
```

This regenerates `Config.swift` with your API key.

---

## How It Works

1. **`.env`** - Contains your API key (git ignored, never committed)
2. **`.env.example`** - Template file (committed to git)
3. **`Scripts/generate-config.sh`** - Reads .env and generates Config.swift
4. **`Config.swift`** - Auto-generated file used by the app

```
.env (your secrets)
    ↓
generate-config.sh (reads and validates)
    ↓
Config.swift (used by app)
```

---

## Security Benefits

✅ API keys never committed to git  
✅ `.env` is in `.gitignore`  
✅ Team members use their own keys  
✅ Easy to rotate keys  
✅ Config.swift auto-generated, not manually edited

---

## Troubleshooting

### "error: .env file not found"

- Ensure `.env` exists in project root
- Copy from `.env.example` if needed

### "error: TMDB_API_KEY is not set"

- Check `.env` has `TMDB_API_KEY=your_key`
- Remove quotes around the key
- No spaces around `=`

### Config.swift not updating

- Re-run `./Scripts/generate-config.sh`
- Check build phase is before "Compile Sources"
- Clean build: `Cmd + Shift + K`

---

## For New Team Members

```bash
# 1. Clone the repo
git clone <repo-url>

# 2. Copy example env file
cp .env.example .env

# 3. Edit .env with your API key
# Get key from: https://www.themoviedb.org/settings/api

# 4. Generate config
./Scripts/generate-config.sh

# 5. Open in Xcode and build
open MoviesLibrary.xcodeproj
```

---

## Files Reference

| File                         | Purpose                | Git Tracked?    |
| ---------------------------- | ---------------------- | --------------- |
| `.env`                       | Your actual API key    | ❌ No (ignored) |
| `.env.example`               | Template/documentation | ✅ Yes          |
| `Scripts/generate-config.sh` | Generator script       | ✅ Yes          |
| `Config.swift`               | Auto-generated config  | ⚠️ Optional\*   |

\*You can choose to track Config.swift or gitignore it

---

## Environment File Format

```bash
# .env file format
TMDB_API_KEY=a1b2c3d4e5f6g7h8i9j0  # No quotes needed
```

**DON'T:**

```bash
TMDB_API_KEY="your_key"  # ❌ No quotes
TMDB_API_KEY = your_key   # ❌ No spaces around =
```
