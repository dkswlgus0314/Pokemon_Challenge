
import UIKit
import SnapKit

//포켓몬 도감 메인뷰
class MainViewController: ViewController{
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonBall")
        return imageView
    }()
    
    //화면 전환 테스트용 버튼
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("상세정보 보러가기", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        
        configureUI()
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
    }
    
    private func configureUI(){
        
        [logoImageView, button].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        
        }
    }
    
    @objc private func buttonTapped(){
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
