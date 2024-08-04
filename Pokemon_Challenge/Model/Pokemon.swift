import Foundation


// MARK: - PokemonResponse
struct PokemonResponse: Codable {
    let results: [Result]
}


// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}


// MARK: - 포켓몬 데이터 모델 구조체
struct Pokemon: Codable {
    let height: Int
    let id: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let species: Species //종
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct Species: Codable {
    let name: String
    let url: String
}



