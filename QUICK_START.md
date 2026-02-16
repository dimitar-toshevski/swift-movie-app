# Quick Start Guide

## 🎬 Movies Library App - Swift/SwiftUI

A modern iOS app for browsing movies using The Movie Database (TMDB) API.

---

## ⚡ Quick Setup (3 steps)

### 1. Get TMDB API Key

- Visit: https://www.themoviedb.org/settings/api
- Sign up and request an API key (free)
- Copy your API key

### 2. Configure the App

- Open `Config.swift`
- Replace `YOUR_API_KEY_HERE` with your actual API key:

```swift
static let tmdbAPIKey = "your_actual_api_key_here"
```

### 3. Create Xcode Project

- Open Xcode
- File → New → Project → iOS App
- Name: `MoviesLibrary`, Interface: SwiftUI
- Save to this directory
- Add all `.swift` files to the project

**OR** follow the detailed guide in [XCODE_SETUP.md](XCODE_SETUP.md)

---

## 📱 What's Included

### Movie List Page

✅ Grid layout with movie posters  
✅ Ratings and release years  
✅ Pull-to-refresh  
✅ Infinite scrolling  
✅ Category filter (Popular/Top Rated/Now Playing)

### Movie Detail Page

✅ Full movie information  
✅ Backdrop image  
✅ Genres, runtime, ratings  
✅ Overview and tagline  
✅ Budget, revenue, production info

---

## 🏗️ Architecture

- **Pattern**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI
- **State Management**: @Observable (iOS 17+)
- **Networking**: Async/Await with URLSession
- **API**: The Movie Database (TMDB)

---

## 📂 File Structure

```
Models/          → Data structures
Services/        → API communication
ViewModels/      → Business logic & state
Views/           → UI components
  Components/    → Reusable UI elements
```

---

## 🚀 Running the App

1. Open the project in Xcode
2. Select a simulator or device (iOS 17+)
3. Press `Cmd + R` to build and run
4. Browse movies! 🎉

---

## 🔧 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- TMDB API Key (free)

---

## 📚 Additional Resources

- [ENV_SETUP.md](ENV_SETUP.md) - Environment variable configuration guide
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Detailed file organization
- [XCODE_SETUP.md](XCODE_SETUP.md) - Complete Xcode setup guide
- [README.md](README.md) - Full project documentation

---

## 🐛 Troubleshooting

**"Failed to load movies"**  
→ Check your API key in `.env` file  
→ Run `./Scripts/generate-config.sh` to regenerate Config.swift

**Build errors**  
→ Ensure iOS deployment target is 17.0+  
→ Clean build: `Cmd + Shift + K`

**Network issues**  
→ Verify internet connection  
→ Check API key permissions on TMDB

---

**Need help?** Check [XCODE_SETUP.md](XCODE_SETUP.md) for detailed troubleshooting.
