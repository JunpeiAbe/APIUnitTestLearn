import Foundation

extension APIClientProtocol {
    func request(_ request: Request) async -> Result<Request.Response> {
        /// リクエストURLチェック
        guard let url = request.url else {
            return Result(error: .invalidURL)
        }
        /// エンコード
        guard let encodedData = try? JSONEncoder().encode(request.httpBody) else {
            return Result(error: .parseError)
        }
        /// リクエストの作成
        var urlRequest = URLRequest(url: url)
        if request.httpMethod == .post {
            urlRequest.httpMethod = request.httpMethod.rawValue
            request.httpHeaders?.headers.forEach {
                urlRequest.setValue($0.key, forHTTPHeaderField: $0.value)
            }
            urlRequest.httpBody = encodedData
        }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        let urlSession = URLSession(configuration: config)
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse
            else {
                return Result(error: .responseError)
            }
            guard urlResponse.statusCode == 200
            else {
                switch urlResponse.statusCode {
                case 400:
                    return Result(statusCode: 400, error: .responseError)
                case 404:
                    return Result(statusCode: 404, error: .responseError)
                case 500:
                    return Result(statusCode: 500, error: .responseError)
                default:
                    return Result(statusCode: urlResponse.statusCode, error: .responseError)
                }
            }
            /// デコード
            let response = try JSONDecoder().decode(Request.Response.self, from: data)
            return Result(statusCode: 200, response: response)
        } catch {
            
            if error is DecodingError {
                return Result(error: .parseError)
            }
            
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain
            {
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    return Result(error: .networkError)
                case NSURLErrorTimedOut:
                    return Result(error: .timeout)
                default:
                    return Result(error: .otherError)
                }
            }
            return Result(error: .otherError)
        }
    }
}

extension APIRequestable {
//    var baseURL: URL? {
//        return URL(string: "https://api.exmaple.com")
//    }
    var url: URL? {
        return baseURL?.appending(component: path)
    }
    var httpHeaders: HttpHeaders {
        return .init(
            headers: ["Content-Type" : "application/json"]
        )
    }
}
