import UIKit
import Kingfisher

final class CustomPromoCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CustomPromoCell"
    
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
        contentView.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        [imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            showPlaceholder()
            return
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] result in
                if case .failure = result {
                    self?.showPlaceholder()
                }
            }
        )
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
    }
    
    private func showPlaceholder() {
        imageView.image = UIImage(systemName: "questionmark.app.dashed")
        imageView.tintColor = UIColor(white: 0.6, alpha: 1.0)
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
    }
    
    // MARK: - Public Methods
    
    func configure(with item: PromoCellItem) {
        loadImage(from: item.imageUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
    }
}
