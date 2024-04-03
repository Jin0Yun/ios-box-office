import UIKit

import Reusable
import RxCocoa
import RxDataSources
import RxSwift

struct MovieBoxOfficeSection: Equatable {
    
    var items: [MovieBoxOffice]
}

extension MovieBoxOfficeSection: SectionModelType {
    typealias Item = MovieBoxOffice
    
    init(original: MovieBoxOfficeSection, items: [MovieBoxOffice]) {
        self = original
        self.items = items
    }
}

final class MoviesListViewController: UIViewController {
    private let viewModel: MoviesListViewModel
    private let navigator: NavigatorProtocol
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(MoviesListCell.self, forCellWithReuseIdentifier: MoviesListCell.className)
        return collectionView
    }()
    private lazy var input = MoviesListViewModel.Input(viewDidLoad: PublishRelay(),
                                                       refresh: refreshControl.rx.controlEvent(.valueChanged).asDriver())
    private lazy var output = viewModel.transform(input: input)
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MovieBoxOfficeSection>?
    
    init(viewModel: MoviesListViewModel, 
         navigator: NavigatorProtocol,
         isRefreshing: Bool = false) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        dataSource = configureCollectionViewDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
        setupNavigationBar()
        bindOutput()
        input.viewDidLoad.accept(())
    }
}

extension MoviesListViewController {
    private func bindOutput() {
        output.movies
            .bind(to: collectionView.rx.items(dataSource: dataSource ?? configureCollectionViewDataSource()))
            .disposed(by: disposeBag)
        output.errorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.makeAlert(message: errorMessage, confirmAction: nil)
            })
            .disposed(by: disposeBag)
        output.isRefreshing
            .subscribe(onNext: { [weak self] isRefreshing in
                if !isRefreshing {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Date().yesterdayString(with: DateFormatter.yyMMddDashed)
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
    }

}

extension MoviesListViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = output.movies.value[0].items[indexPath.item]
        let destination = Navigator.Destination.detailMovie(movieCode: selectedMovie.movieCode, movieName: selectedMovie.movieName)
        navigator.navigate(to: destination, from: self)
    }
    
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<MovieBoxOfficeSection> {
        let dataSource: RxCollectionViewSectionedReloadDataSource<MovieBoxOfficeSection> = RxCollectionViewSectionedReloadDataSource { _, collectionView, indexPath, item in
            let cell: MoviesListCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(item)
            return cell
        }
        return dataSource
    }

}

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 80)
    }
}

extension MoviesListViewController {
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
