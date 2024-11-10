struct User: Codable {
    var id: Int
    var name: String
    var age: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case age = "age"
    }
}

struct Users: Codable {
    var users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "users"
    }
}
