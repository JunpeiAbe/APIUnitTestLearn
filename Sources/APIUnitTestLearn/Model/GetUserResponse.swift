struct GetUserResponse: APIResponsable {
    var status: String
    var data: Users
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}
