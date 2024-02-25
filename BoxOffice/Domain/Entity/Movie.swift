import Foundation

struct Movie {
    private let movieCode: Int
    private let movieName: String
    private let englishMovieName: String
    private let originalMovieName: String
    private let productionYear: Int
    private let duration: Int
    private let openingDate: Date
    private let productionStatus: ProductionStatus
    private let runtimeType: RuntimeType
    private let nations: [Nation]
    private let genres: [Genre]
    private let directors: [Director]
    private let actors: [Performer]
    private let showTypes: [ShowType]
    private let companies: [Company]
    private let audits: [Audit]
    private let staffs: [Staff]
}

struct Nation: Decodable {
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "nationNm"
    }
}

struct Genre: Decodable {
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "genreNm"
    }
}

struct Director: Decodable {
    let name: String
    let englishName: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case englishName = "peopleNmEn"
    }
}

struct Performer: Decodable {
    let name: String
    let englishName: String
    let role: String
    let castEnglish: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case englishName = "peopleNmEn"
        case role = "cast"
        case castEnglish = "castEn"
    }
}

struct ShowType: Decodable {
    let groupName: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case groupName = "showTypeGroupNm"
        case name = "showTypeNm"
    }
}

struct Company: Decodable {
    let code: String
    let name: String
    let englishName: String
    let partName: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "companyCd"
        case name = "companyNm"
        case englishName = "companyNmEn"
        case partName = "companyPartNm"
    }
}

struct Audit: Decodable {
    let auditNumber: String
    let rating: String
    
    private enum CodingKeys: String, CodingKey {
        case auditNumber = "auditNo"
        case rating = "watchGradeNm"
    }
}

struct Staff: Decodable {
    let name: String
    let englishName: String
    let role: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "peopleNm"
        case englishName = "peopleNmEn"
        case role = "staffRoleNm"
    }
}

enum ProductionStatus: String {
    case released   = "개봉"
    case unreleased = "미개봉"
    
    init(rawValue: String) {
        switch rawValue {
        case ProductionStatus.released.rawValue:
            self = .released
        default:
            self = .unreleased
        }
    }
}

enum RuntimeType: String {
    case long = "장편"
    case short = "단편"
    case middle = "중편"
    
    init(rawValue: String) {
        switch rawValue {
        case RuntimeType.long.rawValue:
            self = .long
        case RuntimeType.short.rawValue:
            self = .short
        default:
            self = .middle
        }
    }
}

extension Movie {
    init(from movieDTO: MovieDetailResponseDTO.MovieInfoResultDTO.MovieDTO) {
        self.movieCode = Int(movieDTO.movieCode) ?? 0
        self.movieName = movieDTO.movieName
        self.englishMovieName = movieDTO.englishMovieName
        self.originalMovieName = movieDTO.originalMovieName
        self.productionYear = Int(movieDTO.productionYear) ?? 0
        self.duration = Int(movieDTO.duration) ?? 0
        self.openingDate = movieDTO.openingDate.toDate() ?? Date()
        self.productionStatus = ProductionStatus(rawValue: movieDTO.productionStatus)
        self.runtimeType = RuntimeType(rawValue: movieDTO.runtimeType)
        self.nations = movieDTO.nations
        self.genres = movieDTO.genres
        self.directors = movieDTO.directors
        self.actors = movieDTO.actors
        self.showTypes = movieDTO.showTypes
        self.companies = movieDTO.companies
        self.audits = movieDTO.audits
        self.staffs = movieDTO.staffs
    }
}
