import UIKit
import Kingfisher

final class OrderSpecialistCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let professionLabel = UILabel()
    private let ratingLabel = UILabel()
    private let reviewLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let starImageView = UIImageView()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "OrderSpecialistCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        containerView.backgroundColor = UIColor(white: 0.15, alpha: 0.9)
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.clipsToBounds = true
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        avatarImageView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = UIColor(white: 0.4, alpha: 1.0)
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        nameLabel.numberOfLines = 2
        
        professionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        professionLabel.textColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        professionLabel.numberOfLines = 1
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 4
        ratingStackView.alignment = .center
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1.0)
        starImageView.contentMode = .scaleAspectFit
        
        ratingLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        ratingLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        reviewLabel.font = .systemFont(ofSize: 13, weight: .regular)
        reviewLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        reviewLabel.numberOfLines = 3
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(professionLabel)
        containerView.addSubview(ratingStackView)
        containerView.addSubview(reviewLabel)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        [containerView, avatarImageView, nameLabel, professionLabel,
         ratingStackView, starImageView, ratingLabel, reviewLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.33),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            professionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            ratingStackView.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),
            
            reviewLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            reviewLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            reviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            reviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func loadAvatar(from urlString: String?) {
        if let avatarUrlString = urlString,
           let url = URL(string: avatarUrlString) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill")
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
            avatarImageView.tintColor = UIColor(white: 0.4, alpha: 1.0)
        }
    }
    
    private func updateSelectionState(isSelected: Bool) {
        containerView.layer.borderWidth = isSelected ? 2 : 0
        containerView.layer.borderColor = isSelected ? UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0).cgColor : UIColor.clear.cgColor
        containerView.backgroundColor = isSelected ? UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 0.3) : UIColor(white: 0.15, alpha: 0.9)
    }
    
    // MARK: - Public Methods
    
    func configure(with item: OrderSpecialistItem, isSelected: Bool = false) {
        nameLabel.text = item.fullName
        professionLabel.text = item.profession
        let roundedRating = Int(round(item.rating))
        ratingLabel.text = "\(max(0, min(5, roundedRating)))"
        reviewLabel.text = item.reviewText
        
        loadAvatar(from: item.avatarUrl)
        updateSelectionState(isSelected: isSelected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
        avatarImageView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        nameLabel.text = nil
        professionLabel.text = nil
        ratingLabel.text = nil
        reviewLabel.text = nil
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.backgroundColor = UIColor(white: 0.15, alpha: 0.9)
    }
}
