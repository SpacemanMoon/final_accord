import UIKit

final class CustomOnboardingCell: UICollectionViewCell {
    
    // MARK: - Private UIComponents
    
    private let imageView = UIImageView()
    private let skipButton = UIButton()
    private let nextButton = UIButton()
    
    // MARK: - Properties
    
    static let reuseidentifier = "CustomOnboardingCell"
    
    var onNextButtonTapped: (() -> Void)?
    var onSkipButtonTapped: (() -> Void)?
    
    private var model: OnboardingItem?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 1.0
        
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        skipButton.setTitleColor(.white, for: .normal)
        
        nextButton.setTitle("Далее", for: .normal)
        nextButton.backgroundColor = .green
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 12.0
        nextButton.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(skipButton)
        contentView.addSubview(nextButton)
        contentView.sendSubviewToBack(imageView)
    }
    
    private func setupConstraints() {
        [imageView, skipButton, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            skipButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
            
            nextButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        skipButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        
        let releaseEvents: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel]
        nextButton.addTarget(self, action: #selector(buttonReleased), for: releaseEvents)
        skipButton.addTarget(self, action: #selector(buttonReleased), for: releaseEvents)
    }
    
    // MARK: - Actions
    
    @objc private func nextTapped() {
        onNextButtonTapped?()
    }
    
    @objc private func skipTapped() {
        onSkipButtonTapped?()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with model: OnboardingItem) {
        self.model = model
        imageView.image = UIImage(named: model.image)
    }
    
    func configureButtons(isLastPage: Bool) {
        if isLastPage {
            skipButton.isHidden = true
            nextButton.setTitle("Начать", for: .normal)
        } else {
            skipButton.isHidden = false
            nextButton.setTitle("Далее", for: .normal)
        }
    }
    
    func hideSkipButton() {
        skipButton.isHidden = true
    }
    
    func showSkipButton() {
        skipButton.isHidden = false
    }
    
    func setNextButtonTitle(_ title: String) {
        nextButton.setTitle(title, for: .normal)
    }
    
    func setNextButtonColor(_ color: UIColor) {
        nextButton.backgroundColor = color
    }
}
