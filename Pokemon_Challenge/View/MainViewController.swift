
import UIKit
import SnapKit
import RxSwift

//포켓몬 도감 메인뷰
class MainViewController: ViewController{
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private var pokemonList = [Result]()
    
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
    
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        
        configureUI()
                bind()
                print("MainVC 38번 줄: \(viewModel.fetchPokemonList())")
    }
    
    //MARK: -bind() : 데이터 바인딩
        private func bind(){
            viewModel.pokemonListSubject
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] pokemonList in
                    self?.pokemonList = pokemonList
                    self?.collectionView.reloadData()
                },onError: { error in
                    print("에러 발생: \(error)")
                }).disposed(by: disposeBag)
        }
    
    
    //MARK: -configureUI() - 오토레이아웃
    private func configureUI(){
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
    
    
    //MARK: -createCellLayout(): 컬렉션뷰 레이아웃
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
    
    
    //MARK: -@objc
    @objc private func buttonTapped(){
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: -extension
extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {return UICollectionViewCell()}
        cell.backgroundColor = UIColor.cellBackground
        cell.layer.cornerRadius = 10
        cell.configure(with: pokemonList[indexPath.row])
        return cell
    }
    
    //cell tapped 했을 때 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
