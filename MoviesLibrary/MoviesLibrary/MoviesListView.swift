//
//  MoviesListView.swift
//  MoviesLibrary
//
//  Main view displaying the list of movies
//

import SwiftUI

struct MoviesListView: View {
    @State private var viewModel = MoviesViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.movies.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    moviesList
                }
                
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Loading movies...")
                        .font(.headline)
                }
            }
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    categoryMenu
                }
            }
            .task {
                if viewModel.movies.isEmpty {
                    await viewModel.fetchMovies(refresh: true)
                }
            }
        }
    }
    
    // MARK: - Movies List
    private var moviesList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        MovieCardView(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .task {
                        await viewModel.loadMoreIfNeeded(currentMovie: movie)
                    }
                }
            }
            .padding()
            
            if viewModel.isLoading && !viewModel.movies.isEmpty {
                ProgressView()
                    .padding()
            }
        }
        .refreshable {
            await viewModel.fetchMovies(refresh: true)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
            
            Text("No Movies Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Retry") {
                    Task {
                        await viewModel.retry()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    // MARK: - Category Menu
    private var categoryMenu: some View {
        Menu {
            ForEach(MoviesViewModel.MovieCategory.allCases, id: \.self) { category in
                Button {
                    Task {
                        await viewModel.changeCategory(category)
                    }
                } label: {
                    HStack {
                        Text(category.rawValue)
                        if category == viewModel.selectedCategory {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}

#Preview {
    MoviesListView()
}
