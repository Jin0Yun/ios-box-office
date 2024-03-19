import Foundation

protocol MovieDetailRepository {
    func fetchBoxOfficeList(movieCode: String) async throws -> Movie
}
