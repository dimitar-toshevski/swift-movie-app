//
//  MovieDetailViewModel.swift
//  MoviesLibrary
//
//  ViewModel for managing movie detail state
//

import Foundation
import Observation

@Observable
class MovieDetailViewModel {
    var movieDetail: MovieDetail?
    var isLoading = false
    var errorMessage: String?
    
    private let service = TMDBService.shared
    private let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    // MARK: - Fetch Movie Details
    @MainActor
    func fetchMovieDetails() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            movieDetail = try await service.fetchMovieDetails(id: movieId)
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching movie details: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Retry
    @MainActor
    func retry() async {
        await fetchMovieDetails()
    }
}
