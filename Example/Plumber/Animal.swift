import Foundation

struct Animal: Codable {
    
    var name: String
    var localImageName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case localImageName = "image"
    }
    
    static func mock() throws -> [Self] {
        let jsonData = jsonString.data(using: .utf8)!
        return try JSONDecoder().decode([Self].self, from: jsonData)
    }
    
    static var jsonString: String {
                #"""
                    [
                      {
                        "name": "cat A",
                        "image": "cats_1"
                      },
                      {
                        "name": "cat B",
                        "image": "cats_2"
                      },
                      {
                        "name": "cat C",
                        "image": "cats_3"
                      },
                      {
                        "name": "cat D",
                        "image": "cats_4"
                      },
                      {
                        "name": "cat E",
                        "image": "cats_5"
                      }
                    ]
                """#
    }
}
