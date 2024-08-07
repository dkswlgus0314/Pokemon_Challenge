import Foundation


// MARK: - ResultsResponse 리스트 : limit 개씩 offset 부터 포켓몬 정보 로드
struct ResultsResponse: Codable {
  let results: [Result]
}

struct Result: Codable {
  let name: String
  let url: String
  
  //계산속성
  var id: Int {
    let separator = url.split(separator: "/")
    return Int(separator.last ?? "0") ?? 0
  }
}


// MARK: - 포켓몬 데이터 모델 구조체 : 포켓몬 번호로부터 포켓몬 디테일 정보 로드
struct PokemonResponseDTO: Codable {  //Response에 쓰는 DTO
  let id: Int?
  let name: String?
  let types: [TypeElement]
  let weight: Int?
  let height: Int?
  
  func toDomain() -> Pokemon{
    let id = id ?? 0
    let title = "No.\(id ?? 0)   \(PokemonTranslator.getKoreanName(for: name ?? "nil"))"
    //pokemon.types.type.name이 되지 않는 이유: types가 배열이기 때문에 배열의 각 요소에 접근해야해서 map함수 사용
    //joined(separator:) 메서드를 사용하여 배열의 모든 요소를 하나의 문자열로 결합
    let type = "타입: \( types.compactMap{$0.type.name}.compactMap{PokemonTypeName(rawValue: $0)}.map{$0.displayName}.joined(separator: ","))"
    let height = "키 : \(Double(height ?? 0) / 10) m"
    let weight = "몸무게 : \(Double(weight ?? 0) / 10) kg"
    return Pokemon(id: id,
                    title: title,
                   type: type,
                   height: height,
                   weight: weight)
  }
}

struct Pokemon {
  let id: Int
  let title: String
  let type: String
  let height: String
  let weight: String
}

struct TypeElement: Codable {
  let slot: Int?
  let type: Species
}

struct Species: Codable {
  let name: String?
}



