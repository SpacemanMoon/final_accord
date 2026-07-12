import UIKit
import Kingfisher

final class CustomSpecialistPhotoCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let avatarContainer = CustomView(type: .card)
    private let avatarImage = UIImageView()
    
    // MARK: - Properties
    static let reuseIdentifier = "CustomSpecialistPhotoCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImage)
        
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.clipsToBounds = true
        avatarContainer.layer.cornerRadius = 10
        avatarContainer.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        avatarContainer.layer.shadowColor = UIColor.black.cgColor
        avatarContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        avatarContainer.layer.shadowRadius = 8
        avatarContainer.layer.shadowOpacity = 0.3
        avatarContainer.layer.masksToBounds = false
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 10
        avatarImage.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            avatarContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            avatarImage.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            avatarImage.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with item: SpecialistItem) {
        guard let avatarUrlString = item.avatarUrl,
              let avatarUrl = URL(string: avatarUrlString) else {
            avatarImage.image = UIImage(named: "placeholder_avatar")
            avatarImage.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
            return
        }
        avatarImage.kf.setImage(
            with: avatarUrl,
            placeholder: UIImage(named: "placeholder_avatar"),
            options: [
                .cacheOriginalImage,
                .diskCacheExpiration(.days(7)),
                .memoryCacheExpiration(.days(1))
            ]
        )
        avatarImage.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
        avatarImage.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
    }
}
