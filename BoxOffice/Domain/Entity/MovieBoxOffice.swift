import Foundation

struct MovieBoxOffice: Equatable {
    let rank: Int
    let rankChangesWithPreviousDay: Int
    let rankOldAndNew: RankOldAndNew
    let movieCode: String
    let movieName: String
    let audienceCount: Int
    let audienceAccumulation: Int
    
    init(from movieBoxOfficeDTO: BoxOfficeResponseDTO.BoxOfficeDTO.MovieBoxOfficeDTO) {
        self.rank = Int(movieBoxOfficeDTO.rank) ?? 0
        self.rankChangesWithPreviousDay = Int(movieBoxOfficeDTO.rankChangesWithPreviousDay) ?? 0
        self.rankOldAndNew = movieBoxOfficeDTO.rankOldAndNew == RankOldAndNew.new.rawValue ? .new : .old
        self.movieCode = movieBoxOfficeDTO.movieCode
        self.movieName = movieBoxOfficeDTO.movieName
        self.audienceCount = Int(movieBoxOfficeDTO.audienceCount) ?? 0
        self.audienceAccumulation = Int(movieBoxOfficeDTO.audienceAccumulation) ?? 0
    }
}
