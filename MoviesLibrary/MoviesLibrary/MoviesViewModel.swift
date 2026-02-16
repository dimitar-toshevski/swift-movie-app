//
//  MoviesViewModel.swift
//  MoviesLibrary
//
//  ViewModel for managing movie list state
//

import Foundation
import Observation

@Observable
class MoviesViewModel {
    var movies: [Movie] = []
    var isLoading = false
    var errorMessage: String?
    var currentPage = 1
    var canLoadMore = true
    var selectedCategory: MovieCategory = .popular
    
    private let service = TMDBService.shared
    
    enum MovieCategory: String, CaseIterable {
        case popular = "Popular"
        case topRated = "Top Rated"
        case nowPlaying = "Now Playing"
    }
    
    // MARK: - Fetch Movies
    @MainActor
    func fetchMovies(refresh: Bool = false) async {
        guard !isLoading else { return }
        
        if refresh {
            currentPage = 1
            movies = []
            canLoadMore = true
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response: MoviesResponse
            
            switch selectedCategory {
            case .popular:
                response = try await service.fetchPopularMovies(page: currentPage)
            case .topRated:
                response = try await service.fetchTopRatedMovies(page: currentPage)
            case .nowPlaying:
                response = try await service.fetchNowPlayingMovies(page: currentPage)
            }
            
            if refresh {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            
            canLoadMore = currentPage < response.totalPages
            currentPage += 1
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching movies: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Load More
    @MainActor
    func loadMoreIfNeeded(currentMovie: Movie) async {
        guard let lastMovie = movies.last,
              lastMovie.id == currentMovie.id,
              canLoadMore,
              !isLoading else {
            return
        }
        
        await fetchMovies()
    }
    
    // MARK: - Change Category
    @MainActor
    func changeCategory(_ category: MovieCategory) async {
        guard category != selectedCategory else { return }
        selectedCategory = category
        await fetchMovies(refresh: true)
    }
    
    // MARK: - Retry
    @MainActor
    func retry() async {
        await fetchMovies(refresh: true)
    }
}
