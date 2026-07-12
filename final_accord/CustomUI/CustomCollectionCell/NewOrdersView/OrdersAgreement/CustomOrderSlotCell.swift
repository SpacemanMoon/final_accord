import UIKit

final class CustomOrderSlotCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let backgroundCardView = CustomView(type: .clear)
    private let titleLabel = UILabel()
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CustomOrderSlotCell"
    
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
        backgroundCardView.layer.cornerRadius = 12
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.systemGray4.cgColor
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        backgroundCardView.addSubview(titleLabel)
        contentView.addSubview(backgroundCardView)
    }
    
    private func setupConstraints() {
        [backgroundCardView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with item: OrderSlotItem) {
        titleLabel.text = item.title
        
        if item.isSelected {
            let activeColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
            
            backgroundCardView.backgroundColor = activeColor
            backgroundCardView.layer.borderColor = UIColor.clear.cgColor
            titleLabel.textColor = .white
            
            backgroundCardView.layer.shadowColor = activeColor.cgColor
            backgroundCardView.layer.shadowOpacity = 0.3
            backgroundCardView.layer.shadowRadius = 4
            backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        } else {
            backgroundCardView.backgroundColor = .white
            backgroundCardView.layer.borderColor = UIColor.systemGray4.cgColor
            titleLabel.textColor = .black
            backgroundCardView.layer.shadowOpacity = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backgroundCardView.backgroundColor = .white
        backgroundCardView.layer.shadowOpacity = 0
        titleLabel.textColor = .black
    }
}
