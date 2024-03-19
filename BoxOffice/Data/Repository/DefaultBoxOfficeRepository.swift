import Foundation

final class DefaultBoxOfficeRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultBoxOfficeRepository: BoxOfficeRepository {
    func fetchBoxOfficeList() async throws -> BoxOffice {
        try await dataTransferService.request(with: API.boxOfficeAPI()).boxOfficeResult.toModel()
    }
}
