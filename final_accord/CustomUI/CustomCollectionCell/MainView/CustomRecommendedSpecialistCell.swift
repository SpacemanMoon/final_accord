import UIKit
import Kingfisher

final class CustomRecommendedSpecialistCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let cardView = UIView()
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    private let gradientOverlay = UIView()
    private let nameLabel = UILabel()
    private let professionLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let reviewsLabel = UILabel()
    private let verifiedBadge = UIImageView()
    private let onlineBadge = UIView()
    private let onlineDot = UIView()
    private let onlineLabel = UILabel()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CustomRecommendedSpecialistCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupUI()
        setupConstraints()
        setupOnlineDotAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        cardView.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 12
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.masksToBounds = false
        
        imageContainer.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        imageContainer.layer.cornerRadius = 16
        imageContainer.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        gradientOverlay.backgroundColor = .clear
        
        onlineBadge.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 0.9)
        onlineBadge.layer.cornerRadius = 15
        onlineBadge.clipsToBounds = true
        
        onlineDot.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        onlineDot.layer.cornerRadius = 3
        onlineDot.clipsToBounds = true
        
        onlineLabel.text = "Online"
        onlineLabel.font = .systemFont(ofSize: 11, weight: .bold)
        onlineLabel.textColor = UIColor(white: 1.0, alpha: 1.0)
        
        verifiedBadge.image = UIImage(systemName: "checkmark.seal.fill")
        verifiedBadge.tintColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        verifiedBadge.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        professionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        professionLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        professionLabel.numberOfLines = 2
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 6
        ratingStackView.alignment = .center
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1.0)
        starImageView.contentMode = .scaleAspectFit
        
        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        reviewsLabel.font = .systemFont(ofSize: 12, weight: .regular)
        reviewsLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        contentView.addSubview(cardView)
        
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(gradientOverlay)
        
        cardView.addSubview(imageContainer)
        cardView.addSubview(onlineBadge)
        cardView.addSubview(verifiedBadge)
        cardView.addSubview(nameLabel)
        cardView.addSubview(professionLabel)
        cardView.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewsLabel)
        
        onlineBadge.addSubview(onlineDot)
        onlineBadge.addSubview(onlineLabel)
    }
    
    private func setupConstraints() {
        [cardView, imageContainer, imageView, gradientOverlay,
         onlineBadge, onlineDot, onlineLabel, verifiedBadge,
         nameLabel, professionLabel, ratingStackView,
         starImageView, ratingLabel, reviewsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageContainer.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            imageContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            imageContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            gradientOverlay.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            onlineBadge.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            onlineBadge.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 8),
            onlineBadge.heightAnchor.constraint(equalToConstant: 30),
            onlineBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            onlineDot.leadingAnchor.constraint(equalTo: onlineBadge.leadingAnchor, constant: 8),
            onlineDot.centerYAnchor.constraint(equalTo: onlineBadge.centerYAnchor),
            onlineDot.widthAnchor.constraint(equalToConstant: 6),
            onlineDot.heightAnchor.constraint(equalToConstant: 6),
            
            onlineLabel.leadingAnchor.constraint(equalTo: onlineDot.trailingAnchor, constant: 6),
            onlineLabel.trailingAnchor.constraint(equalTo: onlineBadge.trailingAnchor, constant: -8),
            onlineLabel.centerYAnchor.constraint(equalTo: onlineBadge.centerYAnchor),
            
            verifiedBadge.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -8),
            verifiedBadge.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            verifiedBadge.widthAnchor.constraint(equalToConstant: 24),
            verifiedBadge.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            professionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            ratingStackView.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            ratingStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            ratingStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func setupOnlineDotAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.5
        pulseAnimation.fromValue = 0.8
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        onlineDot.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    private func loadAvatar(from urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
        } else {
            imageView.image = UIImage(systemName: "person.circle.fill")
            imageView.tintColor = UIColor(white: 0.5, alpha: 1.0)
            imageView.contentMode = .center
            imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientOverlay.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientOverlay.bounds
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with item: RecommendedSpecialistItem) {
        nameLabel.text = item.fullName
        professionLabel.text = item.specialization
        ratingLabel.text = "\(Int(round(item.rating)))"
        reviewsLabel.text = item.reviewsCount
        onlineBadge.isHidden = !item.isOnline
        loadAvatar(from: item.avatarUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        nameLabel.text = nil
        professionLabel.text = nil
        ratingLabel.text = nil
        reviewsLabel.text = nil
        onlineBadge.isHidden = true
        cardView.transform = .identity
        cardView.layer.shadowOpacity = 0.3
    }
}
