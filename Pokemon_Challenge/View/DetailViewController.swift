import UIKit
import RxSwift
import SnapKit


//포켓몬 상세 뷰
class DetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
    
    
    let pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //도감번호, 이름
    let numberAndNameLabel: UILabel = {
        let label = UILabel()
        label.text = "도감번호  고라파덕"
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "타입: 물"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키: 0.8m"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "몸무게: 19.6kg"
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
        self.viewModel = viewModel
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
        viewModel.fetchPokemonDetail()  //뷰모델에 요청
    }
    
    //MARK: -bind() : 데이터 바인딩 해야 구독 방출 할 수 있음
    private func bind(){
        viewModel.pokemonSubjet
            .observe(on: MainScheduler.instance)  //구독한 데이터를 메인 스레드에서 처리.UI 업데이트는 메인 스레드에서.
            .subscribe (onNext: { pokemon in
                
                print("디테일뷰컨 \(pokemon)")
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
