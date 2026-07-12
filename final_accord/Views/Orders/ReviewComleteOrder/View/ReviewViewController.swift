import UIKit

final class ReviewViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    private let bodyView = CustomBody()
    private let footerView = CustomFooter()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let masterNameLabel = UILabel()
    private let orderInfoLabel = UILabel()
    private let ratingLabel = UILabel()
    private let starsStackView = UIStackView()
    private let ratingDescriptionLabel = UILabel()
    private let commentTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let characterCountLabel = UILabel()
    private let sendReviewButton = UIButton()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    var presenter: ReviewPresenterProtocol?
    private var selectedRating: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupStars()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Оставить отзыв")
        
        masterNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        masterNameLabel.textColor = .white
        masterNameLabel.textAlignment = .center
        
        orderInfoLabel.font = .systemFont(ofSize: 14)
        orderInfoLabel.textColor = .white.withAlphaComponent(0.8)
        orderInfoLabel.textAlignment = .center
        
        ratingLabel.text = "Оцените качество работы"
        ratingLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        ratingLabel.textColor = .white
        ratingLabel.textAlignment = .center
        
        starsStackView.axis = .horizontal
        starsStackView.spacing = 12
        starsStackView.distribution = .fillEqually
        
        ratingDescriptionLabel.text = "Выберите оценку"
        ratingDescriptionLabel.font = .systemFont(ofSize: 16)
        ratingDescriptionLabel.textColor = .white.withAlphaComponent(0.7)
        ratingDescriptionLabel.textAlignment = .center
        
        commentTextView.font = .systemFont(ofSize: 16)
        commentTextView.textColor = .white
        commentTextView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        commentTextView.layer.cornerRadius = 12
        commentTextView.layer.masksToBounds = true
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.textContainer.lineFragmentPadding = 0
        commentTextView.delegate = self
        
        placeholderLabel.text = "Напишите ваш отзыв..."
        placeholderLabel.font = .systemFont(ofSize: 16)
        placeholderLabel.textColor = .white.withAlphaComponent(0.5)
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.backgroundColor = .clear
        
        characterCountLabel.text = "0/150"
        characterCountLabel.font = .systemFont(ofSize: 12)
        characterCountLabel.textColor = .white.withAlphaComponent(0.6)
        characterCountLabel.textAlignment = .right
        
        footerView.backgroundColor = .clear
        
        sendReviewButton.setTitle("Отправить отзыв", for: .normal)
        sendReviewButton.backgroundColor = UIColor.systemGreen
        sendReviewButton.setTitleColor(.white, for: .normal)
        sendReviewButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        sendReviewButton.layer.cornerRadius = 16
        sendReviewButton.layer.masksToBounds = true
        sendReviewButton.isEnabled = false
        sendReviewButton.alpha = 0.5
        sendReviewButton.addTarget(self, action: #selector(sendReviewTapped), for: .touchUpInside)
        
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(masterNameLabel)
        contentView.addSubview(orderInfoLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(starsStackView)
        contentView.addSubview(ratingDescriptionLabel)
        contentView.addSubview(commentTextView)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(characterCountLabel)
        
        view.addSubview(footerView)
        footerView.addSubview(sendReviewButton)
        view.addSubview(activityIndicator)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        [scrollView, contentView, headerView, masterNameLabel, orderInfoLabel,
         ratingLabel, starsStackView, ratingDescriptionLabel, commentTextView,
         placeholderLabel, characterCountLabel, footerView, sendReviewButton,
         activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            masterNameLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            masterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            masterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            orderInfoLabel.topAnchor.constraint(equalTo: masterNameLabel.bottomAnchor, constant: 8),
            orderInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            orderInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: orderInfoLabel.bottomAnchor, constant: 24),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            starsStackView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            starsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starsStackView.heightAnchor.constraint(equalToConstant: 44),
            starsStackView.widthAnchor.constraint(equalToConstant: 250),
            
            ratingDescriptionLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 12),
            ratingDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            commentTextView.topAnchor.constraint(equalTo: ratingDescriptionLabel.bottomAnchor, constant: 24),
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTextView.heightAnchor.constraint(equalToConstant: 120),
            
            placeholderLabel.topAnchor.constraint(equalTo: commentTextView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: commentTextView.leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: -12),
            
            characterCountLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 4),
            characterCountLabel.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: -4),
            characterCountLabel.heightAnchor.constraint(equalToConstant: 20),
            characterCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 100),
            
            sendReviewButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            sendReviewButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 24),
            sendReviewButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -24),
            sendReviewButton.heightAnchor.constraint(equalToConstant: 56),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupStars() {
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.setTitle("☆", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 36)
            button.tintColor = .systemYellow
            button.tag = i
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starsStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    
    @objc private func starTapped(_ sender: UIButton) {
        selectedRating = sender.tag
        
        for case let star as UIButton in starsStackView.arrangedSubviews {
            star.setTitle(star.tag <= selectedRating ? "★" : "☆", for: .normal)
        }
        
        let ratingTexts = ["", "Ужасно", "Плохо", "Нормально", "Хорошо", "Отлично"]
        ratingDescriptionLabel.text = ratingTexts[selectedRating]
        ratingDescriptionLabel.textColor = .white
        
        presenter?.didSelectRating(selectedRating)
    }
    
    @objc private func sendReviewTapped() {
        let comment = commentTextView.text ?? ""
        presenter?.didTapSendReview(comment: comment)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ReviewViewProtocol

extension ReviewViewController: ReviewViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
        sendReviewButton.isEnabled = false
        sendReviewButton.setTitle("Отправка...", for: .normal)
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        sendReviewButton.setTitle("Отправить отзыв", for: .normal)
    }
    
    func updateSubmitButtonState(isEnabled: Bool) {
        sendReviewButton.isEnabled = isEnabled
        sendReviewButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showOrderInfo(masterName: String, orderDate: String) {
        masterNameLabel.text = "Мастер: \(masterName)"
        orderInfoLabel.text = "Заказ от \(orderDate)"
    }
    
    func updateCharacterCount(current: Int, max: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.characterCountLabel.text = "\(current)/\(max)"
            self?.characterCountLabel.textColor = current > max ? .systemRed : .white.withAlphaComponent(0.6)
        }
    }
}

// MARK: - UITextViewDelegate

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        presenter?.didChangeComment(textView.text)
    }
}

// MARK: - Preview

#Preview {
    ReviewViewController()
}
