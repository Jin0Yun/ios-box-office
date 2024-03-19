import Foundation

final class DefaultMovieDetailRepository {
    private let dataTransferService: DefaultDataTransferService
    
    init(dataTransferService: DefaultDataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMovieDetailRepository: MovieDetailRepository {
    func fetchBoxOfficeList(movieCode: String) async throws -> Movie{
        try await dataTransferService.request(with: API.movieAPI(with: movieCode)).movieInfoResult.movieInfo.toModel()
    }
}
    
