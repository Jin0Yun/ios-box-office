import Foundation

protocol BoxOfficeRepository {
    func fetchBoxOfficeList() async throws -> BoxOffice
}
