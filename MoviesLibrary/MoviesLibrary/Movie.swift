//
//  Movie.swift
//  MoviesLibrary
//
//  Model representing a movie from TMDB API
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let originalLanguage: String
    let adult: Bool
    let video: Bool
    let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, video
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
    }
    
    // Computed properties for image URLs
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/w780\(backdropPath)")
    }
    
    var thumbnailURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/w200\(posterPath)")
    }
    
    // Formatted release year
    var releaseYear: String {
        guard let releaseDate = releaseDate,
              let year = releaseDate.split(separator: "-").first else {
            return "N/A"
        }
        return String(year)
    }
    
    // Rating formatted to 1 decimal place
    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
}

// Response wrapper for TMDB API
struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
