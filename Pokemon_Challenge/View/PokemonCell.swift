//
//  PokemonCell.swift
//  Pokemon_Challenge
//
//  Created by ahnzihyeon on 8/4/24.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    static let id = "PokemonCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    
    //MARK: -override
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds  //imageView의 frame 크기를 contentView와 똑같이
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //재사용 되는 이미지를 지워줘 컬렉션뷰에서 버벅거림 줄임
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    
    //MARK: -포켓몬 이미지 가져오는 메서드
    func configure(with result: Result){
        let resultUrl = result.url
        let id = result.id
        
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {  // URL에서 데이터를 가져옴
                DispatchQueue.main.async {  // 메인 큐에서 UI 업데이트 수행
                    if let image = UIImage(data: data) {
                        self?.imageView.image = image  // 이미지 뷰에 이미지 설정
                    }
                }
            }
        }
    }
    
    
}
