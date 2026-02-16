# Movies Library App

A SwiftUI iOS app that displays a library of movies using The Movie Database (TMDB) API.

## Features

- Browse popular movies
- View detailed movie information
- Movie posters and images
- Ratings and release dates

## Setup

1. Get your API key from [TMDB](https://www.themoviedb.org/settings/api)
2. Edit `.env` file and set your API key:
   ```bash
   TMDB_API_KEY=your_actual_api_key
   ```
3. Generate config (automatic with Xcode build phase, or run `./Scripts/generate-config.sh`)
4. Build and run the project

See [ENV_SETUP.md](ENV_SETUP.md) for detailed configuration instructions.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Architecture

- **MVVM Pattern**: Clear separation between UI and business logic
- **SwiftUI**: Modern declarative UI framework
- **Async/Await**: Modern concurrency for API calls
- **Observable**: SwiftUI state management
