import Foundation

struct API {
    static func boxOfficeAPI() -> APIConfig<BoxOfficeResponseDTO> {
        return .init(baseURL: BoxOfficeAPI.baseUrl,
                     path: BoxOfficeAPI.boxOffice.path,
                     queryParameters: [
                        "key": boxOfficeApiKey,
                        "targetDt": Date().yesterdayString])
    }
    
    static func movieAPI(with movieCode: String) -> APIConfig<MovieDetailResponseDTO> {
        return .init(baseURL: BoxOfficeAPI.baseUrl,
                     path: BoxOfficeAPI.movie.path,
                     queryParameters: [
                        "key": boxOfficeApiKey,
                        "movieCd": movieCode])
    }
}

extension API {
    private static var boxOfficeApiKey: String {
        guard let file = Bundle.main.path(forResource: "API_KEYS", ofType: "plist"),
              let resoure = NSDictionary(contentsOfFile: file) else {
            print("API_KEYS.plist 파일을 찾을 수 없습니다.")
            return ""
        }
        guard let key = resoure["BoxOfficeAPI_KEY"] as? String else {
            print("API 키를 찾을 수 없습니다.")
            return ""
        }
        return key
    }
}
