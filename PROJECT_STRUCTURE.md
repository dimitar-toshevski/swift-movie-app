# Project Structure

```
swift-movie-app/
│
├── README.md                          # Project overview and features
├── XCODE_SETUP.md                     # Guide for creating Xcode project
├── .gitignore                         # Git ignore rules
├── Config.swift                       # API configuration (⚠️ Add your API key here)
│
├── MoviesLibraryApp.swift             # App entry point
├── ContentView.swift                  # Alternative content view
│
├── Models/
│   ├── Movie.swift                    # Movie model and API response
│   └── MovieDetail.swift              # Detailed movie model with genres
│
├── Services/
│   └── TMDBService.swift              # TMDB API service layer
│
├── ViewModels/
│   ├── MoviesViewModel.swift          # Movies list state management
│   └── MovieDetailViewModel.swift     # Movie detail state management
│
└── Views/
    ├── MoviesListView.swift           # Main movies list page
    ├── MovieDetailView.swift          # Movie details page
    ├── ContentView.swift              # Helper content view
    └── Components/
        └── MovieCardView.swift        # Reusable movie card component
```

## Key Features Implemented

### Movies List Page

- Grid layout with 2 columns
- Movie posters with titles, ratings, and release years
- Pull-to-refresh functionality
- Infinite scrolling (pagination)
- Category filtering (Popular, Top Rated, Now Playing)
- Loading states and error handling
- Empty state view

### Movie Details Page

- Backdrop image header
- Complete movie information:
  - Title, rating, and vote count
  - Release year and runtime
  - Genres as tags
  - Tagline
  - Full overview
  - Production details (budget, revenue, status)
  - Production companies
- Loading and error states
- Retry functionality

### Architecture

- **MVVM Pattern**: Clear separation of concerns
- **SwiftUI**: Modern declarative UI
- **Async/Await**: Modern concurrency for API calls
- **@Observable**: SwiftUI state management (iOS 17+)
- **NavigationStack**: Modern navigation system

### API Integration

- Full TMDB API integration
- Popular movies endpoint
- Top rated movies endpoint
- Now playing movies endpoint
- Movie details endpoint
- Search capability (service ready, UI can be added)
- Proper error handling
- Image URL construction with different sizes
