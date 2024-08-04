import Foundation


// MARK: - 포켓몬 데이터 모델 구조체
struct Pokemon: Codable {
    
    let height: Int
    let id: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let species: Species //종
    let sprites: Sprites //이미지
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct Species: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
