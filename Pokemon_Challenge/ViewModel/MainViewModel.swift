import Foundation
import RxSwift


class MainViewModel {
    
    // 구독 해제를 위한 Disposebag
    private let disposeBag = DisposeBag()
    
    //view가 구독할 Subject
    let pokemonListSubject = BehaviorSubject(value: [Result]())
    
    
    init(){
        fetchPokemonList()
    }
    
    //0부터 20개씩 포켓몬 정보 로드
    func fetchPokemonList() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {pokemonListSubject.onError(NetworkError.invalidUrl)
            print("NetworkError: 유효하지 않은 pokemonList url")
            return }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (resultsResponse: ResultsResponse) in
                self?.pokemonListSubject.onNext(resultsResponse.results)
                print("MainViewModel 27번줄: \(resultsResponse.results)")
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }).disposed(by: disposeBag)
        
        
    }
}
