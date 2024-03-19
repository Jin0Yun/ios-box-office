import Foundation

protocol MovieDetailUseCase {
    @discardableResult
    func fetch(movieCode: String) async throws -> Movie
}

final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    private let movieDetailRepository: MovieDetailRepository
    
    init(movieDetailRepository: MovieDetailRepository) {
        self.movieDetailRepository = movieDetailRepository
    }
    
    func fetch(movieCode: String) async throws -> Movie {
        return try await movieDetailRepository.fetchBoxOfficeList(movieCode: movieCode)
    }
}
