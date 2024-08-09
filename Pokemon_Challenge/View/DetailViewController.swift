import UIKit
import RxSwift
import SnapKit


//포켓몬 상세 뷰
class DetailViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let detailViewModel: DetailViewModel
  
  
  let pokemonImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let numberAndNameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 32)
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()   //도감번호, 이름
  
  let typeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24)
    label.textColor = .white
    return label
  }()
  
  let heightLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24)
    label.textColor = .white
    return label
  }()
  
  let weightLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24)
    label.textColor = .white
    return label
  }()
  
  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .center
    stackView.backgroundColor = #colorLiteral(red: 0.4338452816, green: 0.1451964974, blue: 0.135170728, alpha: 1)
    stackView.layer.cornerRadius = 10
    stackView.isLayoutMarginsRelativeArrangement = true //스택뷰 안에 여백
    stackView.directionalLayoutMargins =  NSDirectionalEdgeInsets(top: 24, leading: 10, bottom: 24, trailing: 10) //스택뷰 안에 여백
    return stackView
  }()
  
  
  init(viewModel: DetailViewModel) {
    self.detailViewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: -override
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.mainRed
    
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    detailViewModel.fetchPokemonDetail()  //뷰모델에 요청
  }
  
  //MARK: -bind() : 데이터 바인딩 해야 구독 방출 할 수 있음
  private func bind(){
    detailViewModel.pokemonSubjet
      .observe(on: MainScheduler.instance)  //구독한 데이터를 메인 스레드에서 처리.UI 업데이트는 메인 스레드에서.
      .subscribe (onNext: { [weak self] pokemon in
        guard let self else {return}
        
        NetworkManager.shared.configure(with: pokemon.id, completion: { image in
          self.pokemonImage.image = image
        })
        
        self.numberAndNameLabel.text = pokemon.title
        self.typeLabel.text = pokemon.type
        self.heightLabel.text = pokemon.height
        self.weightLabel.text = pokemon.weight
        
      }, onError: { error in
        print("상세뷰컨 데이터 바인딩 에러 발생: \(error) ")
      }).disposed(by: disposeBag)
    
  }
  
  
  private func configureUI(){
    [stackView].forEach { view.addSubview($0)}
    
    [pokemonImage,
     numberAndNameLabel,
     typeLabel,
     heightLabel,
     weightLabel].forEach{stackView.addArrangedSubview($0)}
    
    pokemonImage.snp.makeConstraints { make in
      make.width.height.equalTo(200)
    }
    
    stackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
      make.height.equalTo(450)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
    }
    
    
  }
  
}
