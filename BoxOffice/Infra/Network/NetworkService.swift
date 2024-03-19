import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case dataError
}

protocol NetworkService {
    func request(apiConfig: any Requestable) async throws -> Data?
}

final class DefaultNetworkService: NetworkService {
    
    func request(apiConfig: any Requestable) async throws -> Data? {
        guard let urlRequest = apiConfig.toURLRequest() else {
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 200 {
                throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
            }
            return data
        } catch {
            throw networkError(error)
        }
    }
    
    private func networkError(_ error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}
