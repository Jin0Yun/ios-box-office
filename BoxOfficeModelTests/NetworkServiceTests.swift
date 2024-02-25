import XCTest
import Foundation

@testable import BoxOffice

final class MockNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        let fileName = request.url?.path() ==  "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            ? "box_office_sample_2"
            : "movie_detail_sample"
        let mockData = JsonLoader.loadjson(fileName: fileName)
        completion(mockData, nil, nil)
        let task = URLSessionTask()
        return task
    }
}

final class NetworkServiceTests: XCTestCase {

    func test_네트워크_서비스를_통해_박스오피스_데이터를_불러올_수_있다() throws {
        // given
        let boxOfficeAPI = API.boxOfficeAPI()
        let mockNetworkSessionManager = MockNetworkSessionManager()
        let sut = DefaultNetworkService(sessionManager: mockNetworkSessionManager)
        let expectation = XCTestExpectation(description: "dataFectch")
        // when
        _ = sut.request(apiConfig: boxOfficeAPI) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func test_네트워크에서_불러온_json을_BoxOfficeResponseDTO로_파싱할_수_있다() throws {
        // given
        let boxOfficeAPI = API.boxOfficeAPI()
        let mockNetworkSessionManager = MockNetworkSessionManager()
        let sut = DefaultDataTransferService(with: DefaultNetworkService(sessionManager: mockNetworkSessionManager))
        let decoder = JSONDecoder()
        let expectationData = try decoder.decode(BoxOfficeResponseDTO.self,
                                                 from: JsonLoader.loadjson(fileName: "box_office_sample_2")!)
        let expectation = XCTestExpectation(description: "dataFectch")
        // when
        _ = sut.request(with: boxOfficeAPI) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.boxOfficeResult.boxOfficeType, expectationData.boxOfficeResult.boxOfficeType)
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func test_네트워크에서_불러온_json을_MovieDetailResponseDTO로_파싱할_수_있다() throws {
        // given
        let movieDetailAPI = API.movieAPI(with: "20124079")
        let sut = DefaultDataTransferService(with: DefaultNetworkService(sessionManager: MockNetworkSessionManager()))
        let decoder = JSONDecoder()
        let expectationData = try decoder.decode(MovieDetailResponseDTO.self,
                                                 from: JsonLoader.loadjson(fileName: "movie_detail_sample")!)
        let expectation = XCTestExpectation(description: "dataFectch")
        // when
        _ = sut.request(with: movieDetailAPI) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.movieInfoResult.movieInfo.movieCode,
                               expectationData.movieInfoResult.movieInfo.movieCode)
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
