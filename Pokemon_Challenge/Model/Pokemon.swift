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
struct Pokemon: Codable {
  let id: Int?
  let name: String?
  let types: [TypeElement]
  let weight: Int?
  let height: Int?
}

struct TypeElement: Codable {
  let slot: Int?
  let type: Species
}

struct Species: Codable {
  let name: String?
}



