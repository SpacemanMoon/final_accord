import UIKit

final class CustomHeader: UIView {
    
    // MARK: - Private UIComponents
    
    private let containerView = UIView()
    private let logoContainerView = UIView()
    private let logoImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let screenTitleLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoContainerView.layer.cornerRadius = logoContainerView.frame.height / 2
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        backgroundColor = .clear
        
        containerView.backgroundColor = .clear
        
        logoContainerView.backgroundColor = .white.withAlphaComponent(0.15)
        logoContainerView.clipsToBounds = true
        
        logoImageView.image = UIImage(systemName: "hammer.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        
        appNameLabel.text = "Центр мастеров"
        appNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        appNameLabel.textColor = .white
        
        screenTitleLabel.textColor = .white.withAlphaComponent(0.8)
        screenTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        screenTitleLabel.textAlignment = .right
        
        separatorView.backgroundColor = .systemGray5
        
        addSubview(containerView)
        containerView.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        containerView.addSubview(appNameLabel)
        containerView.addSubview(screenTitleLabel)
        containerView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        [containerView, logoContainerView, logoImageView,
         appNameLabel, screenTitleLabel, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logoContainerView.widthAnchor.constraint(equalToConstant: 36),
            logoContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor, multiplier: 0.6),
            
            appNameLabel.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: 10),
            appNameLabel.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            
            screenTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            screenTitleLabel.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            screenTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: appNameLabel.trailingAnchor, constant: 12),
            
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - CustomHeaderProtocol

extension CustomHeader: CustomHeaderProtocol {
    
    func configure(title: String) {
        screenTitleLabel.text = title
    }
}
