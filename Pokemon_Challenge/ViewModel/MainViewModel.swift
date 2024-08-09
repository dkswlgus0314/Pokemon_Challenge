import Foundation
import RxSwift


class MainViewModel {
  
  private var offsetNum = 0
  private var urlString: String { "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offsetNum)" }
  
  // 구독 해제를 위한 Disposebag
  private let disposeBag = DisposeBag()
  
  // view가 구독할 Subject.
  // 포켓몬 리스트를 API로부터 가져와 BehaviorSubject를 통해 방출. 구독하는 뷰에서 데이터를 실시간으로 받을 수 있음.
  let pokemonListSubject = BehaviorSubject(value: [Result]())
  
  // let pokemonListSubject = PublishSubject<[Result]>() //컬렉션뷰에 이미지가 안뜸
  
  //MARK: - 0부터 20개씩 포켓몬 정보 로드
  func fetchPokemonList() {
    
    guard let url = URL(string: urlString) else {
      pokemonListSubject.onError(NetworkError.invalidUrl)
      print("NetworkError: 유효하지 않은 pokemonList url")
      return
    }
    
    // 네트워크 매니저를 통해 데이터 가져옴
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (resultsResponse: ResultsResponse) in
        print("메인모델뷰 fetchPokemonList(): \(url)")
        self?.offsetNum += 20
        
        // pokemonListSubject라는 BehaviorSubject에 새로운 데이터를 방출.
        // resultsResponse.results 데이터를 pokemonListSubject를 통해 구독자에게 전달
        // 여기서 onNext는 데이터 방출하는 역할
        self?.pokemonListSubject.onNext(resultsResponse.results)
        print(resultsResponse.results)
      }, onFailure: { [weak self] error in
        self?.pokemonListSubject.onError(error)
      }).disposed(by: disposeBag)
  }
  
}
