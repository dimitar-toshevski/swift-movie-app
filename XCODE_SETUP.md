# Xcode Project Setup Guide

## Creating the Xcode Project

Since this is a source-code only directory, you'll need to create an Xcode project to build and run the app.

### Steps:

1. **Create New Xcode Project**
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "iOS" → "App"
   - Click "Next"

2. **Configure Project**
   - Product Name: `MoviesLibrary`
   - Team: Select your development team
   - Organization Identifier: `com.yourname` (or your preference)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Click "Next"

3. **Set Project Location**
   - Navigate to `/Users/dimitar/Desktop/Projects/swift-movie-app`
   - **IMPORTANT**: Uncheck "Create Git repository" (already exists)
   - Click "Create"

4. **Replace Default Files**
   - Delete the default `ContentView.swift` and `MoviesLibraryApp.swift` that Xcode creates
   - The existing files in the directory will now be recognized

5. **Add Files to Project**
   - In Xcode, right-click on the project navigator
   - Select "Add Files to MoviesLibrary..."
   - Select all the `.swift` files from the directory structure
   - Ensure "Copy items if needed" is **UNCHECKED**
   - Click "Add"

## File Organization in Xcode

After adding files, organize them in groups:

```
MoviesLibrary/
├── MoviesLibraryApp.swift (App Entry)
├── Config.swift
├── Models/
│   ├── Movie.swift
│   └── MovieDetail.swift
├── Services/
│   └── TMDBService.swift
├── ViewModels/
│   ├── MoviesViewModel.swift
│   └── MovieDetailViewModel.swift
└── Views/
    ├── MoviesListView.swift
    ├── MovieDetailView.swift
    ├── ContentView.swift
    └── Components/
        └── MovieCardView.swift
```

## Configuration

1. **Set Deployment Target**
   - Select project in navigator
   - Under "Deployment Info"
   - Set minimum deployment to **iOS 17.0**

2. **Add TMDB API Key**
   - Edit `.env` file in project root
   - Set `TMDB_API_KEY=your_actual_api_key`
   - Get a key at: https://www.themoviedb.org/settings/api
   - Run `./Scripts/generate-config.sh` to generate Config.swift

3. **Add Build Phase (Recommended)**
   - Select target → Build Phases
   - Add "New Run Script Phase" above "Compile Sources"
   - Add: `"${SRCROOT}/Scripts/generate-config.sh"`
   - This auto-generates Config.swift from .env on every build
   - See [ENV_SETUP.md](ENV_SETUP.md) for detailed instructions

4. **Configure App Transport Security (if needed)**
   - The app uses HTTPS, so no additional configuration needed
   - If you encounter network issues, check Info.plist

## Running the App

1. Select a simulator or device
2. Press `Cmd + R` to build and run
3. The app should launch showing the movies list

## Troubleshooting

**Build Errors:**

- Ensure all files are added to the target (check File Inspector)
- Clean build folder: `Cmd + Shift + K`
- Ensure iOS deployment target is 17.0+

**Network Errors:**

- Verify your TMDB API key is correct in `.env` file
- Run `./Scripts/generate-config.sh` to update Config.swift
- Check internet connection
- Ensure API key has proper permissions on TMDB website

**Missing Files:**

- Right-click project → "Add Files to MoviesLibrary"
- Make sure to include all Swift files from the directory

## Alternative: Using Swift Package

If you prefer not to use Xcode projects, you can create a Package.swift file for Swift Package Manager, but this is primarily for iOS app development, so Xcode project is recommended.
