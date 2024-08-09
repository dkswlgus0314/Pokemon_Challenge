import Foundation
import RxSwift


class MainViewModel {
  
  //무한스크롤 구현
  /*var isLoading = false를 사용하는 이유는 중복된 데이터 요청을 방지하기 위해서
   스크롤할 때 scrollViewDidScroll 메서드가 여러 번 호출될 수 있는데, 이때 isLoading 플래그를 사용하여 데이터가 이미 로드 중인지 확인.
   isLoading = true: 데이터 로드 중이므로 추가 요청을 막음.
   isLoading = false: 데이터 로드가 완료되면 새로운 요청을 허용.

   */
  var isLoading = false

  private var offsetNum = 0
  
//  private var urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(self.offsetNum)"
  
  private var urlString: String{ return "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offsetNum)"}

  // 구독 해제를 위한 Disposebag
  private let disposeBag = DisposeBag()
  
  //view가 구독할 Subject. 초기값은??
  //포켓몬 리스트를 API로부터 가져와 BehaviorSubject를 통해 방출. 구독하는 뷰에서 데이터를 실시간으로 받을 수 있음.
  let pokemonListSubject = BehaviorSubject(value: [Result]())
  
  //let pokemonListSubject = PublishSubject<[Result]>() //컬렉션뷰에 이미지가 안뜸
  
  
  //초기화 메서드. 생성 시 fetchPokemonList 호출
  init(){
    fetchPokemonList()
  }
  
  
  //0부터 20개씩 포켓몬 정보 로드
  func fetchPokemonList() {
    isLoading = true
    
    guard let url = URL(string: urlString) else {pokemonListSubject.onError(NetworkError.invalidUrl)
      print("NetworkError: 유효하지 않은 pokemonList url")
      return }
    
    //네트워크 매니저를 통해 데이터 가져옴
    NetworkManager.shared.fetch(url: url)
      .subscribe(onSuccess: { [weak self] (resultsResponse: ResultsResponse) in
        print("메인모델뷰 fetchPokemonList(): \(url)")
        self?.offsetNum += 20

        //pokemonListSubject라는 BehaviorSubject에 새로운 데이터를 방출.
        //resultsResponse.results 데이터를 pokemonListSubject를 통해 구독자에게 전달
        //여기서 onNext는 데이터 방출하는 역할
        self?.pokemonListSubject.onNext(resultsResponse.results)
        self?.isLoading = false
      }, onFailure: { [weak self] error in
        self?.pokemonListSubject.onError(error)
        self?.isLoading = false
      }).disposed(by: disposeBag)
  }
  
}
