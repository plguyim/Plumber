import Foundation

struct Flower: Codable {
    
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
                        "name": "flower A",
                        "image": "flowers_1"
                      },
                      {
                        "name": "flower B",
                        "image": "flowers_2"
                      },
                      {
                        "name": "flower C",
                        "image": "flowers_3"
                      },
                      {
                        "name": "flower D",
                        "image": "flowers_4"
                      },
                      {
                        "name": "flower E",
                        "image": "flowers_5"
                      }
                    ]
                """#
    }
    
}
