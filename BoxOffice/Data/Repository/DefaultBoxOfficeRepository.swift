import Foundation

final class DefaultBoxOfficeRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultBoxOfficeRepository: BoxOfficeRepository {
    func fetchBoxOfficeList(completion: @escaping (Result<BoxOffice, Error>) -> Void) -> URLSessionTask? {
        return dataTransferService.request(with: API.boxOfficeAPI()) { result in
            switch result {
            case .success(let boxOfficeResponseDTO):
                completion(.success(boxOfficeResponseDTO.boxOfficeResult.toModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
