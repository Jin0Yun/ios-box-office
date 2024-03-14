import UIKit

protocol NavigatorProtocol {
    func initializeViewController(destination: Navigator.Destination) -> UIViewController
    func navigate(to destination: Navigator.Destination, from viewController: UIViewController)
}

class Navigator: NavigatorProtocol {
    enum Destination {
        case movieList
        case detailMovie(movieCode: String, movieName: String)
    }
    
    func initializeViewController(destination: Destination) -> UIViewController {
        let sessionMananger = DefaultNetworkSessionManager()
        let networkService = DefaultNetworkService(sessionManager: sessionMananger)
        let dataTransferService = DefaultDataTransferService(with: networkService)
        
        switch destination {
        case .movieList:
            let boxOfficeRepository = DefaultBoxOfficeRepository(dataTransferService: dataTransferService)
            let boxOfficeUseCase = DefaulBoxOfficeUseCase(boxOfficeRepository: boxOfficeRepository)
            let movieListViewModel = MoviesListViewModel(useCase: boxOfficeUseCase)
            let moviesListViewController = MoviesListViewController(viewModel: movieListViewModel, navigator: self)
            let navigationController = UINavigationController(rootViewController: moviesListViewController)
            return navigationController
        case .detailMovie(let movieCode, let movieName):
            let movieDetailRepository = DefaultMovieDetailRepository(dataTransferService: dataTransferService)
            let movieDetailUseCase = DefaultMovieDetailUseCase(movieDetailRepository: movieDetailRepository)
            
            let movieImageRepository = DefaultMovieImageRepository(dataTransferService: dataTransferService)
            let movieImageUseCase = DefaulMovieImageUseCase(movieImageRepository: movieImageRepository)
            
            let movieDetailViewModel = MovieDetailViewModel(detailUseCase: movieDetailUseCase, imageUseCase: movieImageUseCase, movieCode: movieCode, movieName: movieName)
            let movieDetailView = MovieDetailViewController(viewModel: movieDetailViewModel)
            return movieDetailView
        }
    }
    
    func navigate(to destination: Destination, from viewController: UIViewController) {
        switch destination {
        case .detailMovie(_, _):
            guard let detailViewController = initializeViewController(destination: destination) as? MovieDetailViewController else {
                fatalError("MovieDetailView 에러")
            }
            viewController.navigationController?.pushViewController(detailViewController, animated: true)
        default:
            let destinationVC = initializeViewController(destination: destination)
            viewController.navigationController?.setViewControllers([destinationVC], animated: true)
        }
    }
}
