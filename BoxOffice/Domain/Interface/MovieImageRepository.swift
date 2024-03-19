import Foundation

protocol MovieImageRepository {
    func fetchMovieImage(for query: String) async throws -> MovieImage
}
