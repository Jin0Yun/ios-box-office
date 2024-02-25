import Foundation

struct MovieDetailResponseDTO: Decodable {
    let movieInfoResult: MovieInfoResultDTO
}

extension MovieDetailResponseDTO {
    struct MovieInfoResultDTO: Decodable {
        let movieInfo: MovieDTO
        let source: String
    }
}

extension MovieDetailResponseDTO.MovieInfoResultDTO {
    struct MovieDTO: Decodable {
        let movieCode: String
        let movieName: String
        let englishMovieName: String
        let originalMovieName: String
        let productionYear: String
        let duration: String
        let openingDate: String
        let productionStatus: String
        let runtimeType: String
        let nations: [Nation]
        let genres: [Genre]
        let directors: [Director]
        let actors: [Performer]
        let showTypes: [ShowType]
        let companies: [Company]
        let audits: [Audit]
        let staffs: [Staff]
    }
}

extension MovieDetailResponseDTO.MovieInfoResultDTO.MovieDTO {
    private enum CodingKeys: String, CodingKey {
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case englishMovieName = "movieNmEn"
        case originalMovieName = "movieNmOg"
        case productionYear = "prdtYear"
        case duration = "showTm"
        case openingDate = "openDt"
        case productionStatus = "prdtStatNm"
        case runtimeType = "typeNm"
        case nations
        case genres
        case directors
        case actors
        case showTypes
        case companies = "companys"
        case audits
        case staffs
    }
}

extension MovieDetailResponseDTO.MovieInfoResultDTO.MovieDTO {
    func toModel() -> Movie {
        return .init(from: self)
    }
}
