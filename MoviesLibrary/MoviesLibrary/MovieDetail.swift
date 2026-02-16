//
//  MovieDetail.swift
//  MoviesLibrary
//
//  Detailed model for movie information
//

import Foundation

struct MovieDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let runtime: Int?
    let status: String?
    let tagline: String?
    let budget: Int?
    let revenue: Int?
    let genres: [Genre]?
    let homepage: String?
    let originalLanguage: String
    let spokenLanguages: [SpokenLanguage]?
    let productionCompanies: [ProductionCompany]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, runtime, status, tagline
        case budget, revenue, genres, homepage
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case spokenLanguages = "spoken_languages"
        case productionCompanies = "production_companies"
    }
    
    // Image URLs
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/original\(backdropPath)")
    }
    
    var releaseYear: String {
        guard let releaseDate = releaseDate,
              let year = releaseDate.split(separator: "-").first else {
            return "N/A"
        }
        return String(year)
    }
    
    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    var genreText: String {
        genres?.map { $0.name }.joined(separator: ", ") ?? ""
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
    }
}

struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
