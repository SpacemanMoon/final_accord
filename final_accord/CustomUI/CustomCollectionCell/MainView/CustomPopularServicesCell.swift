import UIKit

final class CustomPopularServicesCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    static let reuseIdentifier = "CustomPopularServicesCell"
    
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
        containerView.backgroundColor = .cyan
        containerView.layer.cornerRadius = 16
        
        imageView.tintColor = UIColor(white: 1.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        
        descriptionLabel.font = .systemFont(ofSize: 10, weight: .medium)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        [containerView, imageView, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35),
            
            descriptionLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 26),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with item: PopularServicesItem) {
        imageView.image = UIImage(systemName: item.image)
        descriptionLabel.text = item.description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        descriptionLabel.text = nil
    }
}
