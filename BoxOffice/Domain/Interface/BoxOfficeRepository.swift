import Foundation

protocol BoxOfficeRepository {
    func fetchBoxOfficeList(completion: @escaping (Result<BoxOffice, Error>) -> Void) -> URLSessionTask?
}
