import UIKit
import SnapKit
import RxSwift


//포켓몬 도감 메인뷰
class MainViewController: UIViewController {
  
  private let disposeBag = DisposeBag() //구독해제를 위한 DisposeBag
  private let mainViewModel = MainViewModel() //메인뷰모델 인스턴스를 생성 해 뷰모델 기능 사용
  private var pokemonList = [Result]() //뷰모델에서 제공하는 포켓몬 리스트 데이터를 저장할 배열
  
  //무한스크롤 구현
  /*var isLoading = false를 사용하는 이유는 중복된 데이터 요청을 방지하기 위해서
   스크롤할 때 scrollViewDidScroll 메서드가 여러 번 호출될 수 있는데, 이때 isLoading 플래그를 사용하여 데이터가 이미 로드 중인지 확인.
   isLoading = true: 데이터 로드 중이므로 추가 요청을 막음.
   isLoading = false: 데이터 로드가 완료되면 새로운 요청을 허용.
   */
  var isLoading = false
  
  
  //상단 포켓볼 로고 이미지
  let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "pokemonBall")
    return imageView
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCellLayout())
    collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = #colorLiteral(red: 0.4334821701, green: 0.1452553272, blue: 0.1374996305, alpha: 1)
    return collectionView
  }()
  
  
  //MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.mainRed
    configureUI()
    bind()
  }
  
  //MARK: - bind() : 데이터 바인딩
  //뷰모델의 pokemonListSubject를 구독하여 데이터를 받아오고 데이터가 업데이트 되면 pokemonList 배열 갱신 및 컬렉션뷰 리로드
  private func bind() {
    //뷰모델에서 제공하는 Subject로 새로운 포켓몬 리스트 데이터를 방출
    mainViewModel.pokemonListSubject
    
    //방출된 데이터를 메인 스레드에서 처리(UI 업데이트는 메인 스레드에서)
      .observe(on: MainScheduler.instance)
    
    //메인뷰모델의 pokemonListSubject를 구독(pokemonList). 새로운 데이터 방출될 때마다 클로저 실행
    //여기서 onNext는 데이터를 구독하는 역할
      .subscribe(onNext: { [weak self] pokemonList in
        guard let self else { return }
        
        //방출된 데이터를 받아서 포켓몬 리스트 배열에 업데이트
        //        self.pokemonList = pokemonList
        self.pokemonList.append(contentsOf: pokemonList)
        
        //pokemonList 배열이 업데이트돼서 collectionView.reloadData()가 호출되면 컬렉션뷰는 이 새로운 데이터를 사용하여 셀을 다시 구성.
        //컬렉션뷰는 dataSource메서드(numberOfItemsInSection 및 cellForItemAt)를 호출해 셀에 데이터 업데이트.
        self.collectionView.reloadData()
        isLoading = false
      },onError: { [weak self] error in
        print("메인뷰컨 바인딩 에러 발생: \(error)")
        guard let self else { return }
        self.isLoading = false
      }).disposed(by: disposeBag) //disposeBag에 추가해 메모리 해제 관리
  }
  
  
  //MARK: - configureUI() - 오토레이아웃
  private func configureUI() {
    [logoImageView, collectionView].forEach { view.addSubview($0) }
    
    logoImageView.snp.makeConstraints { make in
      make.width.height.equalTo(100)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.centerX.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(logoImageView.snp.bottom).offset(24)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  
  //MARK: - createCellLayout(): 컬렉션뷰 레이아웃
  private func createCellLayout() -> UICollectionViewLayout {
    ///각 셀간의 간격 10 설정
    let itemSpacing: CGFloat = 10
    
    /// row당 3개의 cell을 설정
    let itemsPerRow: CGFloat = 3
    
    ///셀의 가로길이 :  (뷰의 넓이 -  (row당 셀의 갯수 - 1) * 셀 간격 / row당 셀의 갯수
    let width = (view.frame.width - (itemsPerRow - 1) * itemSpacing) / itemsPerRow
    
    let layout = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical // 스크롤을 방향 (기본값 vertical)
      layout.itemSize = CGSize(width: width, height: width) //정사각형
      layout.minimumLineSpacing = itemSpacing  //열과 열사이 간격
      layout.minimumInteritemSpacing = itemSpacing //아이템과 아이템 사이의 간격
      return layout
    }()
    return layout
  }
}


//MARK: - extension
extension MainViewController: UICollectionViewDelegate {
  /**scrollViewDidScroll는 UIScrollViewDelegate 프로토콜에 명시된 메서드.
   UICollectionViewDelegate는 UIScrollViewDelegate을 채택하고 있다.
   따라서 UICollectionViewDelegate를 채택함으로써 scrollViewDidScroll 메서드를 사용 가능.
   scrollViewDidScroll를 통해 scroll을 하면 이벤트를 delegate에게 알린다.**/
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.bounds.size.height) {
      
      if !isLoading {
        print("맨 아래 도착 ")
        isLoading = true
        // 서버에서 다음 페이지 GET
        mainViewModel.fetchPokemonList()
        //        collectionView.reloadData()
        
      }
    }
    
  }
  
}

//섹션의 아이템 수 반환
extension MainViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemonList.count
  }
  
  //각 셀을 구성
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {return UICollectionViewCell()}
    cell.backgroundColor = UIColor.cellBackground
    cell.layer.cornerRadius = 10
    //    cell.configure(with: pokemonList[indexPath.row]) //셀에 이미지 불러오기
    NetworkManager.shared.configure(with: pokemonList[indexPath.row].id){ image in
      cell.imageView.image = image
    }
    
    //    print("메인뷰컨 pokemonList[indexPath.row]: \(pokemonList[indexPath.row].id)")
    return cell
  }
  
  //cell tapped 했을 때 호출
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    //DetailViewController 인스턴스를 생성.생성된 DetailViewModel을 매개변수로 전달할 때 id를 제공.
    let detailVC = DetailViewController(viewModel: DetailViewModel(pokemonId: pokemonList[indexPath.row].id))
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  
}
