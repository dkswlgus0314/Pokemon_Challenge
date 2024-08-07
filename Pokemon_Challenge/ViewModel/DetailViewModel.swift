import Foundation
import RxSwift


class DetailViewModel {
  
  // 구독 해제를 위한 Disposebag
  private let disposeBag = DisposeBag()
  private var pokemonId: Int
  
  //view가 구독할 Subject
  let pokemonSubjet = PublishSubject<Pokemon>()  //초기값이 없어도 됨
  
  
  init(pokemonId: Int){
    self.pokemonId = pokemonId
  }
  
  
  //포켓몬 상세 정보 로드
  func fetchPokemonDetail(){
    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/") else {
      pokemonSubjet.onError(NetworkError.invalidUrl)
      print("NetworkError: 유효하지 않은 detail url")
      return
    }
    
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (pokemon: Pokemon) in
        self?.pokemonSubjet.onNext(pokemon)
      }, onFailure: {[weak self] error in
        self?.pokemonSubjet.onError(error)
      }).disposed(by: disposeBag)
  }
}
