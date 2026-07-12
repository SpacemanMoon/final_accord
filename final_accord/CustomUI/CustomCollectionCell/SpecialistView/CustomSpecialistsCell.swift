import UIKit
import Kingfisher

final class CustomSpecialistCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let cardBackgroundView = CustomView(type: .card)
    private let avatarWrapperView = CustomView(type: .clear)
    private let avatarImageView = UIImageView()
    
    private let ratingBadgeView = CustomView(type: .card)
    private let ratingIconContainer = CustomView(type: .clear)
    private let ratingIconView = UIImageView()
    private let ratingLabel = UILabel()
    
    private let verifiedBadge = UIImageView()
    
    private let fullNameLabel = UILabel()
    private let specializationLabel = UILabel()
    
    // MARK: - Properties
    static let reuseIdentifier = "CustomSpecialistCell"
    
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
        contentView.addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(avatarWrapperView)
        avatarWrapperView.addSubview(avatarImageView)
        avatarWrapperView.addSubview(ratingBadgeView)
        ratingBadgeView.addSubview(ratingIconContainer)
        ratingIconContainer.addSubview(ratingIconView)
        ratingBadgeView.addSubview(ratingLabel)
        cardBackgroundView.addSubview(fullNameLabel)
        cardBackgroundView.addSubview(specializationLabel)
        cardBackgroundView.addSubview(verifiedBadge)
        
        // Card Background
        cardBackgroundView.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        cardBackgroundView.layer.cornerRadius = 16
        cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardBackgroundView.layer.shadowRadius = 8
        cardBackgroundView.layer.shadowOpacity = 0.3
        cardBackgroundView.layer.masksToBounds = false
        
        verifiedBadge.translatesAutoresizingMaskIntoConstraints = false
        verifiedBadge.image = UIImage(systemName: "checkmark.seal.fill")
        verifiedBadge.tintColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        verifiedBadge.contentMode = .scaleAspectFit
        verifiedBadge.isHidden = false
        
        avatarWrapperView.clipsToBounds = true
        avatarWrapperView.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        avatarWrapperView.layer.cornerRadius = 16
        avatarWrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        ratingBadgeView.backgroundColor = UIColor(white: 0.25, alpha: 0.95)
        ratingBadgeView.layer.cornerRadius = 8
        ratingBadgeView.layer.masksToBounds = true
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.alpha = 0.9
        
        ratingIconView.translatesAutoresizingMaskIntoConstraints = false
        ratingIconView.image = UIImage(systemName: "star.fill")
        ratingIconView.tintColor = UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1.0)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        ratingLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        fullNameLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        fullNameLabel.textAlignment = .center
        
        specializationLabel.translatesAutoresizingMaskIntoConstraints = false
        specializationLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        specializationLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        specializationLabel.textAlignment = .center
        specializationLabel.numberOfLines = 2
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarWrapperView.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor),
            avatarWrapperView.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor),
            avatarWrapperView.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor),
            avatarWrapperView.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -70),

            avatarImageView.topAnchor.constraint(equalTo: avatarWrapperView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarWrapperView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarWrapperView.trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarWrapperView.bottomAnchor),

            ratingBadgeView.topAnchor.constraint(equalTo: avatarWrapperView.topAnchor, constant: 12),
            ratingBadgeView.trailingAnchor.constraint(equalTo: avatarWrapperView.trailingAnchor, constant: -12),
            ratingBadgeView.heightAnchor.constraint(equalToConstant: 28),
            ratingBadgeView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),

            ratingIconContainer.leadingAnchor.constraint(equalTo: ratingBadgeView.leadingAnchor, constant: 8),
            ratingIconContainer.centerYAnchor.constraint(equalTo: ratingBadgeView.centerYAnchor),
            ratingIconContainer.widthAnchor.constraint(equalToConstant: 14),
            ratingIconContainer.heightAnchor.constraint(equalToConstant: 14),
            
            ratingIconView.topAnchor.constraint(equalTo: ratingIconContainer.topAnchor),
            ratingIconView.leadingAnchor.constraint(equalTo: ratingIconContainer.leadingAnchor),
            ratingIconView.trailingAnchor.constraint(equalTo: ratingIconContainer.trailingAnchor),
            ratingIconView.bottomAnchor.constraint(equalTo: ratingIconContainer.bottomAnchor),

            ratingLabel.leadingAnchor.constraint(equalTo: ratingIconContainer.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingBadgeView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingBadgeView.trailingAnchor, constant: -8),

            verifiedBadge.trailingAnchor.constraint(equalTo: avatarWrapperView.trailingAnchor, constant: -8),
            verifiedBadge.bottomAnchor.constraint(equalTo: avatarWrapperView.bottomAnchor, constant: -8),
            verifiedBadge.widthAnchor.constraint(equalToConstant: 24),
            verifiedBadge.heightAnchor.constraint(equalToConstant: 24),

            fullNameLabel.topAnchor.constraint(equalTo: avatarWrapperView.bottomAnchor, constant: 10),
            fullNameLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 10),
            fullNameLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -10),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            specializationLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            specializationLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 10),
            specializationLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -10),
            specializationLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configure
    func configure(with item: SpecialistItem) {
        ratingLabel.text = "\(Int(round(item.rating)))"
        fullNameLabel.text = "\(item.firstName) \(item.lastName)"
        specializationLabel.text = item.specialization
        loadAvatar(from: item.avatarUrl)
    }

    private func loadAvatar(from urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill")
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
            avatarImageView.tintColor = UIColor(white: 0.5, alpha: 1.0)
            avatarImageView.contentMode = .center
            avatarImageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        avatarImageView.kf.cancelDownloadTask()
    }
}
