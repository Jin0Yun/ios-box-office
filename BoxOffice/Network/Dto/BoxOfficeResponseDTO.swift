import Foundation

struct BoxOfficeResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeDTO
}

extension BoxOfficeResponseDTO {
    struct BoxOfficeDTO: Decodable {
        let boxOfficeType: String
        let showRange: String
        let movieBoxOfficeList: Array<MovieBoxOfficeDTO>
    }
}

extension BoxOfficeResponseDTO.BoxOfficeDTO {
    private enum CodingKeys: String, CodingKey {
        case boxOfficeType = "boxofficeType"
        case showRange = "showRange"
        case movieBoxOfficeList = "dailyBoxOfficeList"
    }
}

extension BoxOfficeResponseDTO.BoxOfficeDTO {
    struct MovieBoxOfficeDTO: Decodable {
        let rank: String
        let rankChangesWithPreviousDay: String
        let rankOldAndNew: String
        let movieCode: String
        let movieName: String
        let openingDate: String
        let salesAmount: String
        let salesShare: String
        let salesChangesWithPreviousDay: String
        let salesChangesRatioWithPreviousDay: String
        let salesAccumulation: String
        let audienceCount: String
        let audienceCountChangesWithPreviousDay: String
        let audienceCountChangesRatioWithPreviousDay: String
        let audienceAccumulation: String
        let screenCount: String
        let showingCount: String
    }
}

extension BoxOfficeResponseDTO.BoxOfficeDTO.MovieBoxOfficeDTO {
    enum CodingKeys: String, CodingKey {
        case rank = "rank"
        case rankChangesWithPreviousDay = "rankInten"
        case rankOldAndNew = "rankOldAndNew"
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case openingDate = "openDt"
        case salesAmount = "salesAmt"
        case salesShare = "salesShare"
        case salesChangesWithPreviousDay = "salesInten"
        case salesChangesRatioWithPreviousDay = "salesChange"
        case salesAccumulation = "salesAcc"
        case audienceCount = "audiCnt"
        case audienceCountChangesWithPreviousDay = "audiInten"
        case audienceCountChangesRatioWithPreviousDay = "audiChange"
        case audienceAccumulation = "audiAcc"
        case screenCount = "scrnCnt"
        case showingCount = "showCnt"
    }
}

extension BoxOfficeResponseDTO.BoxOfficeDTO {
    func toModel() -> BoxOffice {
        return .init(boxofficeType: BoxOfficeType(boxofficeType: self.boxOfficeType),
                     showRange: self.showRange,
                     movieBoxOfficeList: self.movieBoxOfficeList.map { $0.toModel() })
    }
}

extension BoxOfficeResponseDTO.BoxOfficeDTO.MovieBoxOfficeDTO {
    func toModel() -> MovieBoxOffice {
        return .init(from: self)
    }
}
