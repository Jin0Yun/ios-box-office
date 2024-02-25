struct BoxOffice {
    private let boxofficeType: BoxOfficeType
    private let showRange: String
    private let movieBoxOfficeList: Array<MovieBoxOffice>
    
    init(boxofficeType: BoxOfficeType, showRange: String, movieBoxOfficeList: Array<MovieBoxOffice>) {
        self.boxofficeType = boxofficeType
        self.showRange = showRange
        self.movieBoxOfficeList = movieBoxOfficeList
    }
}
