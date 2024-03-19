import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
}

protocol DataTransferService {
    func request<T: Decodable, E: HTTPInteractable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
    
    func request<E: HTTPInteractable>(with endpoint: E) async throws where E.Response == Void
}

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    
    init(with networkService: NetworkService
    ) {
        self.networkService = networkService
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<E>(with endpoint: E) async throws where E: Requestable, E: Responsible, E.Response == () {
        _ = try await networkService.request(apiConfig: endpoint)
    }
    
    func request<T: Decodable, E: HTTPInteractable>(with endpoint: E) async throws -> T where E.Response == T {
        let data =  try await networkService.request(apiConfig: endpoint)
        let result: T = try decode(data: data, decoder: endpoint.responseDecoder)
        return result
    }
    
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) throws -> T {
        do {
            guard let data = data else {
                throw DataTransferError.noResponse
            }
            let result: T = try decoder.decode(data)
            return result
        } catch {
            throw DataTransferError.parsing(error)
        }
    }
    
}
