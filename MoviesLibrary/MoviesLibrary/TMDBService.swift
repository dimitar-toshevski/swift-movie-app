//
//  TMDBService.swift
//  MoviesLibrary
//
//  Service for communicating with TMDB API
//

import Foundation

enum TMDBError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
}

class TMDBService {
    static let shared = TMDBService()
    
    private init() {}
    
    private func createURL(endpoint: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(string: "\(Config.baseURL)\(endpoint)")
        
        var items = queryItems
        items.append(URLQueryItem(name: "api_key", value: Config.tmdbAPIKey))
        components?.queryItems = items
        
        return components?.url
    }
    
    // MARK: - Fetch Popular Movies
    func fetchPopularMovies(page: Int = 1) async throws -> MoviesResponse {
        guard let url = createURL(
            endpoint: "/movie/popular",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        ) else {
            throw TMDBError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Fetch Top Rated Movies
    func fetchTopRatedMovies(page: Int = 1) async throws -> MoviesResponse {
        guard let url = createURL(
            endpoint: "/movie/top_rated",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        ) else {
            throw TMDBError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Fetch Now Playing Movies
    func fetchNowPlayingMovies(page: Int = 1) async throws -> MoviesResponse {
        guard let url = createURL(
            endpoint: "/movie/now_playing",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        ) else {
            throw TMDBError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Fetch Movie Details
    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        guard let url = createURL(endpoint: "/movie/\(id)") else {
            throw TMDBError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Search Movies
    func searchMovies(query: String, page: Int = 1) async throws -> MoviesResponse {
        guard let url = createURL(
            endpoint: "/search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        ) else {
            throw TMDBError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Generic Request Handler
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TMDBError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorResponse = try? JSONDecoder().decode(TMDBErrorResponse.self, from: data) {
                    throw TMDBError.apiError(errorResponse.statusMessage)
                }
                throw TMDBError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                print("Decoding error: \(error)")
                throw TMDBError.invalidData
            }
            
        } catch let error as TMDBError {
            throw error
        } catch {
            throw TMDBError.networkError(error)
        }
    }
}

// MARK: - Error Response Model
struct TMDBErrorResponse: Codable {
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
