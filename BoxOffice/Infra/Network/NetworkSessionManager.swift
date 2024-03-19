import Foundation

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let result = try await URLSession.shared.data(for: request)
        return result
    }
}
