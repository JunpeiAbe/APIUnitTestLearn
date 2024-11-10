import XCTest
@testable import APIUnitTestLearn

struct MockAPIClient: APIClientProtocol {
    typealias Request = MockGetUsersRequest
    
    var result: Result<Request.Response>?
    
    func request(_ request: Request) async -> Result<Request.Response> {
        return result ?? Result(error: .otherError)
    }
}

struct MockGetUsersRequest: APIRequestable {
    var baseURL: URL? = URL(string:"https://api.exmaple.com")
    
    typealias Response = GetUserResponse
    
    var path: String = "Users"
    
    var httpHeaders: HttpHeaders? = nil
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: HttpBody? = nil
    
}

/// テストケース
class APIUnitTestLearnTests: XCTestCase {
    var mockGetUsersClient: MockAPIClient?
    
    // セットアップ
    override func setUp() {
        super.setUp()
        // 初期化
        mockGetUsersClient = .init()
    }
    
    override func tearDown() {
        mockGetUsersClient = nil
        super.tearDown()
    }
    
    // 正常リクエスト
    func testSuccessfulRequest() async {
        // スタブのレスポンスデータ設定
        let responseData = GetUserResponse(
            status: "success",
            data: .init(
                users: [.init(
                    id: 1,
                    name: "a",
                    age: 20
                )]
            )
        )
        mockGetUsersClient?.result = Result(statusCode: 200, response: responseData)
        
        let request = MockGetUsersRequest()
        let result = await mockGetUsersClient?.request(request)
        XCTAssertEqual(result?.response?.status, "success")
    }
    // 無効なURL
    func testInvalidURL() async {
        // 無効なURLでエラーが帰るか確認(URLの判定処理は即座に結果が返却されるのでresultの指定は不要)
        var request = GetUsersRequest()
        request.baseURL = URL(string: "")
        let getUsersClient = GetUsersClient()
        let result = await getUsersClient.request(request)
        XCTAssertEqual(result.error, .invalidURL)
    }
    // ネットワークエラー
    func testNetworkError() async {
        let request = MockGetUsersRequest()
        // ネットワークエラーをスタブで設定
        mockGetUsersClient?.result = Result(error: .networkError)
        let result = await mockGetUsersClient?.request(request)
        XCTAssertEqual(result?.error, .networkError)
    }
    // タイムアウトエラー
    func testTimeoutError() async {
        let request = MockGetUsersRequest()
        // タイムアウトエラーをスタブで設定
        mockGetUsersClient?.result = Result(error: .timeout)
        let result = await mockGetUsersClient?.request(request)
        XCTAssertEqual(result?.error, .timeout)
    }
    // レスポンスエラー(ステータスコード200以外)
    func testResponseError() async {
        let request = MockGetUsersRequest()
        // 404エラーをスタブで設定
        mockGetUsersClient?.result = Result(statusCode: 404, error: .responseError)
        let result = await mockGetUsersClient?.request(request)
        XCTAssertEqual(result?.statusCode, 404)
        XCTAssertEqual(result?.error, .responseError)
    }
    // デコードエラー
    func testDecodeError() async {
        let request = MockGetUsersRequest()
        mockGetUsersClient?.result = Result(error: .parseError)
        let result = await mockGetUsersClient?.request(request)
        XCTAssertEqual(result?.error, .parseError)
    }
}


















