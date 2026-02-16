//
//  MovieDetailView.swift
//  MoviesLibrary
//
//  Detailed view for a single movie
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @State private var viewModel: MovieDetailViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        _viewModel = State(initialValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            if let movie = viewModel.movieDetail {
                movieDetailContent(movie: movie)
            } else if viewModel.isLoading {
                loadingView
            } else if viewModel.errorMessage != nil {
                errorView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.movieDetail == nil {
                await viewModel.fetchMovieDetails()
            }
        }
    }
    
    // MARK: - Movie Detail Content
    @ViewBuilder
    private func movieDetailContent(movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Backdrop Image
            backdropImage(movie: movie)
            
            // Movie Info
            VStack(alignment: .leading, spacing: 20) {
                // Title and Year
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        // Rating
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(movie.formattedRating)
                                .fontWeight(.semibold)
                            Text("(\(movie.voteCount) votes)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        Divider()
                            .frame(height: 20)
                        
                        // Year
                        Text(movie.releaseYear)
                            .foregroundStyle(.secondary)
                        
                        if !movie.formattedRuntime.isEmpty && movie.formattedRuntime != "N/A" {
                            Divider()
                                .frame(height: 20)
                            
                            Text(movie.formattedRuntime)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
                
                // Genres
                if let genres = movie.genres, !genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundStyle(.blue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                // Tagline
                if let tagline = movie.tagline, !tagline.isEmpty {
                    Text(tagline)
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(.secondary)
                }
                
                // Overview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Additional Info
                if movie.status != nil || movie.budget != nil || movie.revenue != nil {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Details")
                            .font(.headline)
                        
                        if let status = movie.status {
                            DetailRow(label: "Status", value: status)
                        }
                        
                        if let budget = movie.budget, budget > 0 {
                            DetailRow(label: "Budget", value: formatCurrency(budget))
                        }
                        
                        if let revenue = movie.revenue, revenue > 0 {
                            DetailRow(label: "Revenue", value: formatCurrency(revenue))
                        }
                        
                        DetailRow(label: "Language", value: movie.originalLanguage.uppercased())
                    }
                }
                
                // Production Companies
                if let companies = movie.productionCompanies, !companies.isEmpty {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Production Companies")
                            .font(.headline)
                        
                        ForEach(companies) { company in
                            Text(company.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Backdrop Image
    @ViewBuilder
    private func backdropImage(movie: MovieDetail) -> some View {
        AsyncImage(url: movie.backdropURL) { phase in
            switch phase {
            case .empty:
                backdropPlaceholder
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                backdropPlaceholder
            @unknown default:
                backdropPlaceholder
            }
        }
        .frame(height: 250)
        .clipped()
    }
    
    private var backdropPlaceholder: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
            
            Image(systemName: "photo")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading movie details...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text("Failed to load movie details")
                .font(.headline)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Retry") {
                Task {
                    await viewModel.retry()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Helper Functions
    private func formatCurrency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}

// MARK: - Detail Row Component
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movieId: 278)
    }
}
