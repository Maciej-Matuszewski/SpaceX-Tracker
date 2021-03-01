import XCTest
@testable import Network

@available(iOS 10.0, *)
final class NetworkTests: XCTestCase {
    private var urlSession: URLSessionMock!
    private var networkClient: NetworkClient!

    override func setUp() {
        super.setUp()
        urlSession = .init()
        networkClient = .init(session: urlSession)
    }

    override func tearDown() {
        networkClient = nil
        urlSession = nil
        super.tearDown()
    }

    func test_send() {
        let json: String = """
{
    "date": "2006-03-25T10:30:00+12:00",
    "text": "This is fake text",
    "number": 132,
    "boolean": true,
    "snake_case_text": "This is snake case text",
    "nested": {
        "nested_text": "This is nested text"
    },
    "array_of_numbers": [
        1,
        2,
        4
    ]
}
"""

        urlSession.json = json

        let exp = expectation(description: "Waiting for response")
        networkClient.send(request: RequestMock()) { (result: Result<ModelMock, Error>) in

            guard case .success(let model) = result else {
                return XCTFail("Network Client failed to provide model")
            }

            XCTAssertNotNil(model.date)
            XCTAssertEqual(model.text, "This is fake text")
            XCTAssertEqual(model.number, 132)
            XCTAssertEqual(model.boolean, true)
            XCTAssertEqual(model.snakeCaseText, "This is snake case text")
            XCTAssertEqual(model.nested.nestedText, "This is nested text")
            XCTAssertEqual(model.arrayOfNumbers, [1, 2, 4])
            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_send_invalidRequest() {
        let json: String = """
{
    "date": "2006-03-25T10:30:00+12:00",
    "text": "This is fake text",
    "number": 132,
    "boolean": true,
    "snake_case_text": "This is snake case text",
    "nested": {
        "nested_text": "This is nested text"
    },
    "array_of_numbers": [
        1,
        2,
        4
    ]
}
"""

        urlSession.json = json

        let request = RequestMock(baseURL: nil, path: "", method: .POST, parameters: [:])
        let exp = expectation(description: "Waiting for response")
        networkClient.send(request: request) { (result: Result<ModelMock, Error>) in
            guard case .failure(let resultError) = result else {
                return XCTFail("Network Client should return error")
            }
            XCTAssertEqual(resultError as? NetworkError, .invalidURL)

            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_send_invalidDecoding() {
        let json: String = """
{
    "date": "2006-03-25T10:30:00+12:00",
    "text": "This is fake text",
    "number": "132",
    "snake_case_text": "This is snake case text",
    "nested": {
        "nested": {
            "nested_text": "This is nested text"
        }
    },
    "array_of_numbers": [
        1,
        2,
        4
    ]
}
"""

        urlSession.json = json

        let exp = expectation(description: "Waiting for response")
        networkClient.send(request: RequestMock()) { (result: Result<ModelMock, Error>) in
            guard case .failure(let resultError) = result else {
                return XCTFail("Network Client should return error")
            }
            XCTAssertEqual(resultError as? NetworkError, .invalidData)

            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_sendWithError() {
        urlSession.error = ErrorMock.error

        let exp = expectation(description: "Waiting for response")
        networkClient.send(request: RequestMock()) { (result: Result<ModelMock, Error>) in
            guard case .failure(let resultError) = result else {
                return XCTFail("Network Client should return error")
            }
            XCTAssertEqual(resultError as? ErrorMock, ErrorMock.error)

            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

struct RequestMock: NetworkRequest {
    var baseURL = URL(string: "http://127.0.0.1")
    var path: String = "path"
    var method: NetworkClient.HTTPMethod = .GET
    var parameters: [String : String] = [:]
}

fileprivate class URLSessionMock: URLSession {
    var json: String?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        URLSessionDataTaskMock { [self] in
            var data: Data?
            if let json = self.json {
                data = Data(json.utf8)
            }
            completionHandler(data, nil, error)
        }
    }
}

fileprivate class URLSessionDataTaskMock: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}

fileprivate struct ModelMock: Codable, Equatable {
    struct Nested: Codable, Equatable {
        let nestedText: String
    }

    let date: Date
    let text: String
    let number: Int
    let boolean: Bool
    let snakeCaseText: String
    let nested: Nested
    let arrayOfNumbers: [Int]
}

fileprivate enum ErrorMock: Error {
    case error
}
