import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case dataError
}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(completion: @escaping CompletionHandler) -> URLSessionTask?
}

final class DefaultNetworkService {
    
    private let config: any Requestable
    private let sessionManager: NetworkSessionManager
    
    init(config: any Requestable,
         sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()
    ) {
        self.sessionManager = sessionManager
        self.config = config
    }
    
}

extension DefaultNetworkService: NetworkService {
    private func request(request: URLRequest,
                         completion: @escaping CompletionHandler) -> URLSessionTask {
        let sessionDataTask = sessionManager.request(request) { [weak self] data, response, requestError in
            if let requestError = requestError {
                completion(.failure(self?.networkError(response, requestError, data) ?? .generic(requestError)))
            } else {
                completion(.success(data))
            }
        }
        return sessionDataTask
    }
    
    func request(completion: @escaping CompletionHandler) -> URLSessionTask? {
        let urlComponents = config.toURLComponents()
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method.rawValue
        return request(request: URLRequest(url: url), completion: completion)
    }
    
    private func networkError(_ urlResponse: URLResponse?,
                              _ error: Error,
                              _ data: Data?) -> NetworkError {
        if let response = urlResponse as? HTTPURLResponse {
            return .error(statusCode: response.statusCode, data: data)
        }
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

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> URLSessionTask
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
