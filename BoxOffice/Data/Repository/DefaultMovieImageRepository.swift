import Foundation

final class DefaultMovieImageRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMovieImageRepository: MovieImageRepository {
    func fetchMovieImage(for query: String) async throws -> MovieImage {
        try await dataTransferService.request(with: API.movieImage(query: query)).toModel()
    }
}
