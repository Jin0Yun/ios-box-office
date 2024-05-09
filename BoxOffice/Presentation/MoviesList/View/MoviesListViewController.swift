import UIKit

final class MoviesListViewController: UIViewController {
    private let viewModel: MoviesListViewModel
    private let navigator: NavigatorProtocol
    private let refreshControl = UIRefreshControl()
    private var viewDidLoadEvent: Observable<Void> = Observable(())
    private var refreshEvent: Observable<Void> = Observable(())
    private var loadCellEvent: Observable<Int> = Observable(-1)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviesListCell.self, forCellWithReuseIdentifier: MoviesListCell.className)
        return collectionView
    }()
    private lazy var input = MoviesListViewModel.Input(viewDidLoad: viewDidLoadEvent,
                                                       refresh: refreshEvent,
                                                       loadCell: loadCellEvent)
    private lazy var output = viewModel.transform(input: input)
    
    init(viewModel: MoviesListViewModel, 
         navigator: NavigatorProtocol,
         isRefreshing: Bool = false) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
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
        input.viewDidLoad.value = ()
    }
}

extension MoviesListViewController {
    private func bindOutput() {
        output.movies.bind { [weak self] _ in
            self?.reload()
        }
        output.errorMessage.bind { [weak self] errorMessage in
            self?.makeAlert(message: errorMessage, confirmAction: nil)
        }
        output.isRefreshing.bind { [weak self] isRefreshing in
            if !isRefreshing {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Date().yesterdayString(with: DateFormatter.yyMMddDashed)
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        input.refresh.value = ()
    }
}

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.movies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCell.className, for: indexPath) as? MoviesListCell else {
            fatalError("MoviesListCell 에러")
        }
        output.movie.bind { movie in
            guard let movie else {
                return
            }
            cell.configure(movie)
        }
        input.loadCell.value = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = output.movies.value[indexPath.item]
        let destination = Navigator.Destination.detailMovie(movieCode: selectedMovie.movieCode, movieName: selectedMovie.movieName)
        navigator.navigate(to: destination, from: self)
    }
    
    private func reload() {
        self.collectionView.reloadData()
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
