import UIKit
import Kingfisher

final class SpecialistDetailInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SpecialistDetailInfoCell"
    
    // MARK: - UI Elements
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let starsStackView = UIStackView()
    private let ratingContainerView = UIView()
    private let specializationLabel = UILabel()
    private let educationLabel = UILabel()
    private let shortInfoLabel = UILabel()
    private let reviewsTitleLabel = UILabel()
    private let reviewsStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        
        contentContainerView.addSubview(nameLabel)
        contentContainerView.addSubview(ratingContainerView)
        ratingContainerView.addSubview(starsStackView)
        ratingContainerView.addSubview(ratingLabel)
        contentContainerView.addSubview(specializationLabel)
        contentContainerView.addSubview(educationLabel)
        contentContainerView.addSubview(shortInfoLabel)
        contentContainerView.addSubview(reviewsTitleLabel)
        contentContainerView.addSubview(reviewsStackView)
        
        contentView.backgroundColor = .clear

        contentContainerView.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        contentContainerView.layer.cornerRadius = 16
        contentContainerView.layer.masksToBounds = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear

        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        ratingContainerView.backgroundColor = .clear
        
        ratingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        ratingLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        ratingLabel.textAlignment = .left
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        starsStackView.axis = .horizontal
        starsStackView.spacing = 2
        starsStackView.alignment = .center
        starsStackView.distribution = .fillEqually
        starsStackView.translatesAutoresizingMaskIntoConstraints = false

        specializationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        specializationLabel.textColor = UIColor(white: 0.85, alpha: 1.0)
        specializationLabel.textAlignment = .left
        specializationLabel.numberOfLines = 0
        specializationLabel.translatesAutoresizingMaskIntoConstraints = false

        educationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        educationLabel.textColor = UIColor(white: 0.85, alpha: 1.0)
        educationLabel.textAlignment = .left
        educationLabel.numberOfLines = 0
        educationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        shortInfoLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        shortInfoLabel.textColor = UIColor(white: 0.85, alpha: 1.0)
        shortInfoLabel.textAlignment = .left
        shortInfoLabel.numberOfLines = 0
        shortInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reviewsTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        reviewsTitleLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        reviewsTitleLabel.textAlignment = .left
        reviewsTitleLabel.text = "Отзывы"
        reviewsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reviewsStackView.axis = .vertical
        reviewsStackView.spacing = 12
        reviewsStackView.alignment = .fill
        reviewsStackView.distribution = .fill
        reviewsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24),

            nameLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            ratingContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingContainerView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            ratingContainerView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 30),

            starsStackView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
            starsStackView.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            starsStackView.widthAnchor.constraint(equalToConstant: 120),
            starsStackView.heightAnchor.constraint(equalToConstant: 24),

            ratingLabel.leadingAnchor.constraint(equalTo: starsStackView.trailingAnchor, constant: 12),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingContainerView.trailingAnchor),

            specializationLabel.topAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: 12),
            specializationLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            specializationLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            educationLabel.topAnchor.constraint(equalTo: specializationLabel.bottomAnchor, constant: 12),
            educationLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            educationLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            shortInfoLabel.topAnchor.constraint(equalTo: educationLabel.bottomAnchor, constant: 12),
            shortInfoLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            shortInfoLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),

            reviewsTitleLabel.topAnchor.constraint(equalTo: shortInfoLabel.bottomAnchor, constant: 16),
            reviewsTitleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            reviewsTitleLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            
            reviewsStackView.topAnchor.constraint(equalTo: reviewsTitleLabel.bottomAnchor, constant: 8),
            reviewsStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            reviewsStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            reviewsStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -20),
        ])
    }
    
    // MARK: - Configure
    func configure(with specialist: SpecialistItem) {
        nameLabel.text = "\(specialist.firstName) \(specialist.lastName)"
        configureStars(rating: specialist.rating)
        ratingLabel.text = "\(specialist.reviews.count) отзывов"
        
        configureLabel(specializationLabel, title: "Специализация", value: specialist.specialization)
        configureLabel(educationLabel, title: "Образование", value: specialist.education)
        configureLabel(shortInfoLabel, title: "О себе", value: specialist.shortInfo)
        
        configureReviews(specialist.reviews)
    }
    
    private func configureLabel(_ label: UILabel, title: String, value: String?) {
        guard let value = value, !value.isEmpty else {
            label.isHidden = true
            return
        }
        
        let attributedText = NSMutableAttributedString()
        let titleAttr = NSAttributedString(string: "\(title): ", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0.95, alpha: 1.0)
        ])
        let valueAttr = NSAttributedString(string: value, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor(white: 0.85, alpha: 1.0)
        ])
        attributedText.append(titleAttr)
        attributedText.append(valueAttr)
        label.attributedText = attributedText
        label.isHidden = false
    }

    private func configureReviews(_ reviews: [String]) {
        guard !reviews.isEmpty else {
            reviewsTitleLabel.isHidden = true
            reviewsStackView.isHidden = true
            return
        }
        
        reviewsTitleLabel.isHidden = false
        reviewsStackView.isHidden = false
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for review in reviews {
            let label = UILabel()
            label.text = "• \(review)"
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.textColor = UIColor(white: 0.8, alpha: 1.0)
            label.numberOfLines = 0
            reviewsStackView.addArrangedSubview(label)
        }
    }
    
    // MARK: - Private Methods
    private func configureStars(rating: Double) {
        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let roundedRating = Int(round(rating))
        let finalRating = max(0, min(5, roundedRating))
        for _ in 0..<finalRating {
            let star = createStarImageView(filled: true)
            starsStackView.addArrangedSubview(star)
        }

        let emptyStars = 5 - finalRating
        for _ in 0..<emptyStars {
            let star = createStarImageView(filled: false)
            starsStackView.addArrangedSubview(star)
        }
    }
    
    private func createStarImageView(filled: Bool, half: Bool = false) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if filled {
            imageView.image = UIImage(systemName: "star.fill")
            imageView.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        } else if half {
            imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            imageView.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        } else {
            imageView.image = UIImage(systemName: "star")
            imageView.tintColor = UIColor(white: 0.4, alpha: 1.0)
        }
        
        return imageView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        ratingLabel.text = nil
        
        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        specializationLabel.isHidden = false
        specializationLabel.attributedText = nil
        
        educationLabel.isHidden = false
        educationLabel.attributedText = nil
        
        shortInfoLabel.isHidden = false
        shortInfoLabel.attributedText = nil
        
        reviewsTitleLabel.isHidden = false
        reviewsStackView.isHidden = false
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
