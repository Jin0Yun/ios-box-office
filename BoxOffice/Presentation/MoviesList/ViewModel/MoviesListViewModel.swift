import UIKit

import RxCocoa
import RxSwift


protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) async -> Output
}

@MainActor
final class MoviesListViewModel: ViewModel {
    struct Input {
        var viewDidLoad: PublishRelay<Void>
        var refresh: Driver<Void>
    }
    struct Output {
        var movies: BehaviorRelay<[MovieBoxOfficeSection]> = BehaviorRelay(value: [MovieBoxOfficeSection]())
        var errorMessage: PublishRelay<String> = PublishRelay()
        var isRefreshing: PublishRelay<Bool> = PublishRelay()
    }
    
    private let output = Output()
    private let useCase: BoxOfficeUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: BoxOfficeUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in self?.fetchData() })
            .disposed(by: disposeBag)
        input.refresh
            .drive(onNext: { [weak self] in self?.refresh() })
            .disposed(by: disposeBag)
        return output
    }
    
    private func fetchData() {
        Task {
            do {
                let result = try await useCase.fetch()
                output.movies.accept([MovieBoxOfficeSection(items: result.movieBoxOfficeList)])
            } catch {
                output.errorMessage.accept(error.localizedDescription)
            }
            output.isRefreshing.accept(false)
        }
    }
    
    private func refresh() {
        output.isRefreshing.accept(true)
        fetchData()
    }
    
}
