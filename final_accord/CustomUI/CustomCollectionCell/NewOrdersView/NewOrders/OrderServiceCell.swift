import UIKit
import Kingfisher

final class OrderServiceCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let containerView = UIView()
    private let serviceImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "OrderServiceCell"
    
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
        containerView.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.masksToBounds = false
        
        serviceImageView.contentMode = .scaleAspectFill
        serviceImageView.clipsToBounds = true
        serviceImageView.layer.cornerRadius = 8
        serviceImageView.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        serviceImageView.tintColor = UIColor(white: 0.5, alpha: 1.0)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(containerView)
        containerView.addSubview(serviceImageView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        [containerView, serviceImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            serviceImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            serviceImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            serviceImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            serviceImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            titleLabel.topAnchor.constraint(equalTo: serviceImageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with item: OrderServiceItem, isSelected: Bool = false) {
        titleLabel.text = item.title
        
        if let imageUrlString = item.imageUrl,
           let url = URL(string: imageUrlString) {
            serviceImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "wrench.fill")
            )
        } else {
            serviceImageView.image = UIImage(systemName: "wrench.fill")
            serviceImageView.tintColor = UIColor(white: 0.5, alpha: 1.0)
        }
        
        containerView.layer.borderWidth = isSelected ? 2 : 0
        containerView.layer.borderColor = isSelected ? UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0).cgColor : UIColor.clear.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        serviceImageView.kf.cancelDownloadTask()
        serviceImageView.image = nil
        serviceImageView.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        titleLabel.text = nil
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
    }
}
