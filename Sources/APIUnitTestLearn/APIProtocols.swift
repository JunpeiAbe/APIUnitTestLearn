import Foundation

/// APIクライアントの定義
protocol APIClientProtocol {
    func request<Request: APIRequestable>(_ request: Request) async throws -> Result<Request.Response>
}
/// APIリクエストの定義
protocol APIRequestable: Encodable {
    associatedtype Response: APIResponsable
    var baseURL: URL? { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var httpHeaders: HttpHeaders? { get }
    var httpBody: HttpBody? { get }
}

/// APIレスポンスの定義
protocol APIResponsable: Decodable {}

/// HTTPメソッド
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
/// HTTPヘッダー
struct HttpHeaders {
    var headers: [String : String] = [:]
}
/// HTTPボディ
struct HttpBody: Encodable {
    /// リクエストデータを定義
}

struct Result<Response> {
    /// ステータスコード
    var statusCode: Int?
    /// APIの返却データ
    var response: Response?
    /// APIエラー
    var error: APIError?
}

public enum APIError: Error {
    /// 不正なURL
    case invalidURL
    /// 通信エラー
    case networkError
    /// 通信タイムアウト
    case timeout
    /// レスポンスエラー
    case responseError
    /// decode失敗
    case parseError
    /// その他のエラー
    case otherError
}
