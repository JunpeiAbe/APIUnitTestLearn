struct GetUsersRequest: APIRequestable {
    
    typealias Response = GetUserResponse
    
    var path: String = "Users"
    
    var httpHeaders: HttpHeaders? = nil
    
    var httpMethod: HttpMethod = .get
    
    var httpBody: HttpBody? = nil
    
    init() {}
}

