import Foundation

enum URLScheme: String {
    case http
    case https
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var method: HTTPMethodType { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: BodyEncoder { get }
    
    func toURLRequest() -> URLRequest?
}

extension Requestable {
    private func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = URLScheme.https.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1 as? String) }
        return components.url
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headerParameters.reduce(into: [:]) { partialResult, headerParameter in
            partialResult[headerParameter.key] = headerParameter.value
        }
        return urlRequest
    }
}

protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

struct APIConfig<R>: HTTPInteractable {
    typealias Response = R
    
    let baseURL: String
    let path: String
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let method: HTTPMethodType
    let bodyParameters: [String: Any]
    let bodyEncoder: BodyEncoder
    let responseDecoder: ResponseDecoder
    
    init(baseURL: String,
         path: String,
         headerParameters: [String: String] = [:],
         queryParameters: [String: Any] = [:],
         method: HTTPMethodType = .get,
         bodyParameters: [String: Any] = [:],
         bodyEncoder: BodyEncoder = JSONBodyEncoder(),
         responseDecoder: ResponseDecoder  = JSONResponseDecoder()
     ) {
        self.baseURL = baseURL
        self.path = path
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.method = method
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}
