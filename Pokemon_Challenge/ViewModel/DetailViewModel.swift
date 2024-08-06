import Foundation
import RxSwift


class DetailViewModel {
    
    // 구독 해제를 위한 Disposebag
    private let disposeBag = DisposeBag()
    
    //view가 구독할 Subject
    let pokemonSubjet = PublishSubject<Pokemon>()
    
    init(){
//        fetchPokemonDetail()
    }
    
    //포켓몬 상세 정보 로드
    func fetchPokemonDetail(pokemonId: Int){
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/") else {
            pokemonSubjet.onError(NetworkError.invalidUrl)
            print("NetworkError: 유효하지 않은 detail url")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (pokemon: Pokemon) in
                self?.pokemonSubjet.onNext(pokemon)
                
                print("메인뷰컨에서 셀 클릭 시 함수타고 제대로 넘어옴?? \(pokemon)")
                
      
                
            }, onFailure: {[weak self] error in
                self?.pokemonSubjet.onError(error)
            }).disposed(by: disposeBag)
    }
}
