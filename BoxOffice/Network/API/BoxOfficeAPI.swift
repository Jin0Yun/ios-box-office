enum BoxOfficeAPI {
    case boxOffice
    case movie
}

extension BoxOfficeAPI {
    static let baseUrl = "kobis.or.kr"
    static let basePath = "/kobisopenapi/webservice/rest"
    
    var path: String {
        switch self {
        case .boxOffice:
            return BoxOfficeAPI.basePath + "/boxoffice/searchDailyBoxOfficeList.json"
        case .movie:
            return BoxOfficeAPI.basePath + "/movie/searchMovieInfo.json"
        }
    }
}
