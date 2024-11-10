import Foundation

struct GetUsersRequest: APIRequestable {
    var baseURL: URL? = URL(string:"https://api.exmaple.com")
    
    typealias Response = GetUserResponse
    
    var path: String = "Users"
    
    var httpHeaders: HttpHeaders? = nil
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: HttpBody? = nil
    
}

