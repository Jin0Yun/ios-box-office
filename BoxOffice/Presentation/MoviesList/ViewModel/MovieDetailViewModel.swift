import UIKit

@MainActor
class MovieDetailViewModel: ViewModel {
    struct Input {
        var callMovieDetailEvent: Observable<Void>
        var callMovieImageEvent: Observable<Void>
    }
    struct Output {
        var movieDetail: Observable<Movie?>
        var errorMessage: Observable<String>
        var movieImage: Observable<MovieImage?>
        var imageErrorMessage: Observable<String>
    }
    
    private let detailUseCase: MovieDetailUseCase
    private let imageUseCase: MovieImageUseCase
    private var movieCode: String
    private var movieName: String
    private var movieImage: Observable<MovieImage?> = Observable(nil)
    private var imageErrorMessage: Observable<String> = Observable("")
    private var movieDetail: Observable<Movie?> = Observable(nil)
    private var errorMessage: Observable<String> = Observable("")
    
    init(detailUseCase: MovieDetailUseCase,
         imageUseCase: MovieImageUseCase,
         movieCode: String,
         movieName: String) {
        self.detailUseCase = detailUseCase
        self.imageUseCase = imageUseCase
        self.movieCode = movieCode
        self.movieName = movieName
    }
    
    func transform(input: Input) -> Output {
        input.callMovieDetailEvent.bind { [weak self] _ in
            guard let movieCode = self?.movieCode else {
                return
            }
            self?.fetchMovieDetail(movieCode: movieCode)
        }
        input.callMovieImageEvent.bind { [weak self] _ in
            guard let movieName = self?.movieName else {
                return
            }
            self?.fetchMovieImage(movieName: movieName)
        }
        return .init(movieDetail: movieDetail,
                     errorMessage: errorMessage,
                     movieImage: movieImage,
                     imageErrorMessage: imageErrorMessage)
    }
    
    private func fetchMovieDetail(movieCode: String) {
        Task {
            do {
                movieDetail.value = try await detailUseCase.fetch(movieCode: movieCode)
            } catch {
                errorMessage.value = error.localizedDescription
            }
        }
        
    }
    
    private func fetchMovieImage(movieName: String) {
        Task {
            do {
                movieImage.value = try await imageUseCase.fetchMovieImage(movieName: movieName)
            } catch {
                errorMessage.value = error.localizedDescription
            }
        }
    }
}
