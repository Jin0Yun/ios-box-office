import Foundation

protocol MovieImageUseCase {
    @discardableResult
    func fetchMovieImage(movieName: String) async throws -> MovieImage
}

final class DefaulMovieImageUseCase: MovieImageUseCase {
    private let movieImageRepository: MovieImageRepository
    
    init(movieImageRepository: MovieImageRepository) {
        self.movieImageRepository = movieImageRepository
    }
    
    func fetchMovieImage(movieName: String) async throws -> MovieImage {
        return try await movieImageRepository.fetchMovieImage(for: movieName)
    }
}
