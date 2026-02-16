//
//  MovieCardView.swift
//  MoviesLibrary
//
//  Card view component for displaying a movie in the grid
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
            AsyncImage(url: movie.thumbnailURL) { phase in
                switch phase {
                case .empty:
                    posterPlaceholder
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    posterPlaceholder
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    
                    Text(movie.formattedRating)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(movie.releaseYear)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var posterPlaceholder: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
            
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    MovieCardView(movie: Movie(
        id: 1,
        title: "The Shawshank Redemption",
        overview: "Two imprisoned men bond over a number of years...",
        posterPath: nil,
        backdropPath: nil,
        releaseDate: "1994-09-23",
        voteAverage: 8.7,
        voteCount: 25000,
        popularity: 100.0,
        originalLanguage: "en",
        adult: false,
        video: false,
        genreIds: [18, 80]
    ))
    .frame(width: 160)
    .padding()
}
