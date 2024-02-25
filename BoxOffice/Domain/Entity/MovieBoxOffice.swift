import Foundation

struct MovieBoxOffice {
    private let rank: Int
    private let rankChangesWithPreviousDay: Int
    private let rankOldAndNew: RankOldAndNew
    private let movieCode: String
    private let movieName: String
    private let audienceCount: Int
    private let audienceAccumulation: Int
    
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
