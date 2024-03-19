import Foundation

protocol BoxOfficeUseCase {
    @discardableResult
    func fetch() async throws -> BoxOffice
}

final class DefaulBoxOfficeUseCase: BoxOfficeUseCase {
    private let boxOfficeRepository: BoxOfficeRepository
    
    init(boxOfficeRepository: BoxOfficeRepository) {
        self.boxOfficeRepository = boxOfficeRepository
    }
    
    func fetch() async throws -> BoxOffice {
        return try await boxOfficeRepository.fetchBoxOfficeList()
    }
}
