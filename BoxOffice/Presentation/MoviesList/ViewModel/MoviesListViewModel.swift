import UIKit

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) async -> Output
}

@MainActor
final class MoviesListViewModel: ViewModel {
    struct Input {
        var viewDidLoad: Observable<Void>
        var refresh: Observable<Void>
        var loadCell: Observable<Int>
    }
    struct Output {
        var movies: Observable<[MovieBoxOffice]>
        var errorMessage: Observable<String>
        var isRefreshing: Observable<Bool>
        var nowCellInformation: Observable<(String, String, String, UIColor, String)>
    }
    
    private let useCase: BoxOfficeUseCase
    private var movies: Observable<[MovieBoxOffice]> = Observable([])
    private var errorMessage: Observable<String> = Observable("")
    private var isRefreshing: Observable<Bool> = Observable(false)
    private var nowCellInformation: Observable<(String, String, String, UIColor, String)> = Observable(("", "", "", .white, ""))
    
    init(useCase: BoxOfficeUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad.bind { [weak self] _ in
           self?.viewDidLoad()
        }
        input.refresh.bind { [weak self] _ in
            self?.refresh()
        }
        input.loadCell.bind { [weak self] index in
            self?.loadCell(index)
        }
        return .init(movies: movies,
                     errorMessage: errorMessage,
                     isRefreshing: isRefreshing,
                     nowCellInformation: nowCellInformation)
    }
    
    private func fetchData() async {
        do {
            movies.value = try await useCase.fetch().movieBoxOfficeList
        } catch {
            errorMessage.value = error.localizedDescription
        }
        isRefreshing.value = false
    }
    
    private func viewDidLoad() {
        Task {
           await fetchData()
        }
    }
    
    private func refresh() {
        isRefreshing.value = true
        Task {
            await fetchData()
        }
    }
    
    private func loadCell(_ index: Int) {
        let movie = movies.value[index]
        var movieName: String {
            var text = movie.movieName
            if text.count > 20 {
                let index = text.index(text.startIndex, offsetBy: 20)
                text = String(text[..<index]) + "..."
                return text
            }
            return text
        }
        var rank: String {
            return "\(movie.rank)"
        }
        var rankChangeText: String {
            if movie.rankChangesWithPreviousDay > 0 {
                return "▲\(movie.rankChangesWithPreviousDay)"
            }
            if movie.rankChangesWithPreviousDay < 0 {
                return "▼\(abs(movie.rankChangesWithPreviousDay))"
            }
            if movie.rankOldAndNew == .new {
                return "신작"
            }
            return "-"
        }
        var rankChangeColor: UIColor {
            if movie.rankOldAndNew == .new {
                return .red
            }
            if movie.rankChangesWithPreviousDay > 0 {
                return .red
            }
            if movie.rankChangesWithPreviousDay < 0 {
                return .blue
            }
            return .gray
        }
        var audienceText: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedAudienceCount = formatter.string(from: NSNumber(value: movie.audienceCount)) ?? "\(movie.audienceCount)"
            let formattedAccumulation = formatter.string(from: NSNumber(value: movie.audienceAccumulation)) ?? "\(movie.audienceAccumulation)"
            return "오늘 \(formattedAudienceCount) / 총 \(formattedAccumulation)"
        }
        let cellInformation = (movieName, rank, rankChangeText, rankChangeColor, audienceText)
        nowCellInformation.value = cellInformation
    }
}
