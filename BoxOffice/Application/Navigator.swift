import UIKit

protocol NavigatorProtocol {
    func initializeViewController(destination: Navigator.Destination) -> UIViewController
    func navigate(to destination: Navigator.Destination, from viewController: UIViewController)
}

final class Navigator: NavigatorProtocol {
    enum Destination {
        case movieList
        case detailMovie(movieCode: String, movieName: String)
    }
    private let depengencyManager: DepengencyManager = DepengencyManager()
    
    @MainActor func initializeViewController(destination: Destination) -> UIViewController {
        switch destination {
        case .movieList:
            let navigationController = UINavigationController(rootViewController: depengencyManager.makeMoviesListViewController(navigator: self))
            return navigationController
        case .detailMovie(let movieCode, let movieName):
            return depengencyManager.makeMovieDetailViewController(navigator: self,
                                                                   movieCode: movieCode,
                                                                   movieName: movieName)
        }
    }
    
    @MainActor func navigate(to destination: Destination, from viewController: UIViewController) {
        switch destination {
        case .movieList:
            viewController.dismiss(animated: true)
        case .detailMovie:
            guard let detailViewController = initializeViewController(destination: destination) as? MovieDetailViewController else {
                fatalError("MovieDetailView 에러")
            }
            viewController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
