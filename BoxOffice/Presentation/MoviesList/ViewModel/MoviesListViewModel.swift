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
        var movie: Observable<MovieBoxOffice?>
    }
    
    private let useCase: BoxOfficeUseCase
    private var movies: Observable<[MovieBoxOffice]> = Observable([])
    private var errorMessage: Observable<String> = Observable("")
    private var isRefreshing: Observable<Bool> = Observable(false)
    private var movie: Observable<MovieBoxOffice?> = Observable(nil)
    
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
                     movie: movie)
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
        movie.value = movies.value[index]
    }
}
