

protocol APIClientProtocol {
    func request<Request: APIRequestable>(_ request: Request) async throws -> Request.Response
}

protocol APIRequestable: Encodable {
    associatedtype Response: APIResponsable
    var baseURL: URL { get set }
    var urlSuffix: String { get set }
    var httpMethod: HttpMethod { get }
    var httpHeaders: HttpHeaders? { get }
    var httpBody: HttpBody? { get set }
}

protocol HttpBody: Encodable {}

protocol APIResponsable: Decodable {}

enum HttpMethod: String {
    case get
    case post
}

struct HttpHeaders {
    var headers: [String : String] = [:]
}
