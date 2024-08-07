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
    
}
