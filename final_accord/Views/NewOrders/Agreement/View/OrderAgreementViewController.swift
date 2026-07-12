import UIKit
import Kingfisher

final class OrderAgreementViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    private let headerView = CustomHeader()
    private let footerView = CustomFooter()
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView()
    private let acceptButton = UIButton(type: .system)
    
    private let specialistCardView = CustomView(type: .card)
    private let avatarImageView = UIImageView()
    private let nameLabel = CustomLabel(text: "", type: .heading)
    private let professionLabel = CustomLabel(text: "", type: .body)
    private let ratingLabel = CustomLabel(text: "", type: .body)
    private let ratingStackView = UIStackView()
    private let starImageView = UIImageView()
    private let separatorView = CustomView(type: .bordered)
    private let infoTitleLabel = CustomLabel(text: "О специалисте:", type: .heading)
    private let infoLabel = CustomLabel(text: "", type: .body)
    
    private let problemTitleLabel = CustomLabel(text: "Опишите проблему:", type: .heading)
    private let problemTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let characterCountLabel = UILabel()
    private let maxCharacterLimit = 100
    
    private let dateTitleLabel = CustomLabel(text: "Выберите дату", type: .heading)
    private let timeTitleLabel = CustomLabel(text: "Доступное время", type: .heading)
    
    private let dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 0
        collectionView.bouncesHorizontally = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let timeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 1
        return collectionView
    }()
    
    // MARK: - Properties
    
    var presenter: OrderAgreementPresenterProtocol?
    private var dateSlots: [OrderSlotItem] = []
    private var timeSlots: [OrderSlotItem] = []
    private var selectedDateIndex: Int?
    private var selectedTimeIndex: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        view.backgroundColor = .clear
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Согласование")
        
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.backgroundColor = .clear
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.backgroundColor = .clear
        
        specialistCardView.backgroundColor = .darkGray.withAlphaComponent(0.9)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.backgroundColor = .systemGray6
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .systemGray4
        
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        
        professionLabel.textAlignment = .left
        professionLabel.textColor = .systemBlue
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 4
        ratingStackView.alignment = .center
        
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        starImageView.contentMode = .scaleAspectFit
        
        ratingLabel.textAlignment = .left
        
        infoTitleLabel.textAlignment = .left
        
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        
        problemTitleLabel.textColor = .white
        
        problemTextView.layer.borderColor = UIColor.black.cgColor
        problemTextView.layer.cornerRadius = 12
        problemTextView.layer.borderWidth = 2
        problemTextView.backgroundColor = .white
        problemTextView.font = .systemFont(ofSize: 16, weight: .regular)
        problemTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        problemTextView.delegate = self
        problemTextView.textColor = .black
        
        placeholderLabel.text = "Что у вас случилось?..."
        placeholderLabel.font = .systemFont(ofSize: 16, weight: .regular)
        placeholderLabel.textColor = .gray
        placeholderLabel.isUserInteractionEnabled = false
        
        characterCountLabel.text = "0 / \(maxCharacterLimit)"
        characterCountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        characterCountLabel.textColor = .gray
        characterCountLabel.textAlignment = .right
        
        dateTitleLabel.textColor = .white
        timeTitleLabel.textColor = .white
        
        acceptButton.setTitle("ВЫЗВАТЬ СПЕЦИАЛИСТА", for: .normal)
        acceptButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.layer.cornerRadius = 14
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = .systemGray4
        acceptButton.alpha = 0.6
        acceptButton.layer.shadowColor = acceptButton.backgroundColor?.cgColor
        acceptButton.layer.shadowRadius = 6
        acceptButton.layer.shadowOpacity = 0.3
        acceptButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        
        view.addSubview(headerView)
        view.addSubview(contentScrollView)
        view.addSubview(footerView)
        view.addSubview(acceptButton)
        view.addSubview(activityIndicator)
        
        contentScrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(specialistCardView)
        specialistCardView.addSubview(avatarImageView)
        specialistCardView.addSubview(nameLabel)
        specialistCardView.addSubview(professionLabel)
        specialistCardView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        specialistCardView.addSubview(separatorView)
        specialistCardView.addSubview(infoTitleLabel)
        specialistCardView.addSubview(infoLabel)
        
        contentStackView.addArrangedSubview(problemTitleLabel)
        contentStackView.addArrangedSubview(problemTextView)
        problemTextView.addSubview(placeholderLabel)
        contentStackView.addArrangedSubview(characterCountLabel)
        
        contentStackView.addArrangedSubview(dateTitleLabel)
        contentStackView.addArrangedSubview(dateCollectionView)
        contentStackView.addArrangedSubview(timeTitleLabel)
        contentStackView.addArrangedSubview(timeCollectionView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        [headerView, contentScrollView, footerView, acceptButton,
         activityIndicator, contentStackView, specialistCardView,
         avatarImageView, nameLabel, professionLabel, ratingStackView,
         separatorView, infoTitleLabel, infoLabel, problemTitleLabel,
         problemTextView, placeholderLabel, characterCountLabel,
         dateTitleLabel, timeTitleLabel, dateCollectionView,
         timeCollectionView, starImageView, ratingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            contentScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentScrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),
            
            specialistCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            avatarImageView.topAnchor.constraint(equalTo: specialistCardView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: specialistCardView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: specialistCardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: specialistCardView.trailingAnchor, constant: -16),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            professionLabel.trailingAnchor.constraint(equalTo: specialistCardView.trailingAnchor, constant: -16),
            
            ratingStackView.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            separatorView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: specialistCardView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: specialistCardView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            infoTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            infoTitleLabel.leadingAnchor.constraint(equalTo: specialistCardView.leadingAnchor, constant: 16),
            infoTitleLabel.trailingAnchor.constraint(equalTo: specialistCardView.trailingAnchor, constant: -16),
            
            infoLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: specialistCardView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: specialistCardView.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: specialistCardView.bottomAnchor, constant: -16),
            
            problemTextView.heightAnchor.constraint(equalToConstant: 100),
            
            placeholderLabel.topAnchor.constraint(equalTo: problemTextView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: problemTextView.leadingAnchor, constant: 15),
            placeholderLabel.trailingAnchor.constraint(equalTo: problemTextView.trailingAnchor, constant: -15),
            
            characterCountLabel.trailingAnchor.constraint(equalTo: problemTextView.trailingAnchor),
            characterCountLabel.topAnchor.constraint(equalTo: problemTextView.bottomAnchor, constant: 4),
            
            dateCollectionView.heightAnchor.constraint(equalToConstant: 44),
            timeCollectionView.heightAnchor.constraint(equalToConstant: 44),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 95),
            
            acceptButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            acceptButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12),
            acceptButton.heightAnchor.constraint(equalToConstant: 54),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDelegates() {
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        dateCollectionView.register(CustomOrderSlotCell.self, forCellWithReuseIdentifier: CustomOrderSlotCell.reuseIdentifier)
        
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.register(CustomOrderSlotCell.self, forCellWithReuseIdentifier: CustomOrderSlotCell.reuseIdentifier)
    }
    
    private func setupActions() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func acceptButtonTapped() {
        let description = problemTextView.text ?? ""
        presenter?.didTapAcceptOrder(with: description)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - OrderAgreementViewProtocol

extension OrderAgreementViewController: OrderAgreementViewProtocol {
    
    func configure(with service: ServiceFirestoreItem, specialist: SpecialistFirestore) {
        nameLabel.text = specialist.lastName + " " + specialist.firstName
        professionLabel.text = specialist.specialization
        ratingLabel.text = String(format: "%.1f", specialist.rating)
        infoLabel.text = specialist.shortsInfo ?? "Информация отсутствует"
        
        if let avatarUrl = specialist.avatarUrl,
           let url = URL(string: avatarUrl) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle.fill")
            )
        }
    }
    
    func getProblemDescription() -> String {
        return problemTextView.text ?? ""
    }
    
    func updateDateSlots(with items: [OrderSlotItem]) {
        dateSlots = items
        dateCollectionView.reloadData()
    }
    
    func updateTimeSlots(with items: [OrderSlotItem]) {
        timeSlots = items
        timeCollectionView.reloadData()
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess() {
        let alert = UIAlertController(title: "Успешно", message: "Заказ создан! Ожидайте звонка специалиста", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    func showLoading() {
        view.isUserInteractionEnabled = false
        contentScrollView.alpha = 0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentScrollView.alpha = 1.0
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func showNoAvailableSlots() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "На сегодня нет доступного времени для записи. Пожалуйста, выберите другую дату.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateAcceptButton(isEnabled: Bool) {
        acceptButton.isEnabled = isEnabled
        acceptButton.backgroundColor = isEnabled ? .green : .systemGray4
        acceptButton.alpha = isEnabled ? 1.0 : 0.6
    }
}

// MARK: - UICollectionViewDataSource

extension OrderAgreementViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return dateSlots.count
        case 1: return timeSlots.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomOrderSlotCell.reuseIdentifier,
            for: indexPath
        ) as? CustomOrderSlotCell else {
            return UICollectionViewCell()
        }
        
        let item: OrderSlotItem
        switch collectionView.tag {
        case 0: item = dateSlots[indexPath.item]
        case 1: item = timeSlots[indexPath.item]
        default: return UICollectionViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OrderAgreementViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            if let previous = selectedDateIndex {
                dateSlots[previous].isSelected = false
            }
            selectedDateIndex = indexPath.item
            dateSlots[indexPath.item].isSelected = true
            collectionView.reloadData()
            presenter?.didSelectDate(at: indexPath.item)
            
        case 1:
            if let previous = selectedTimeIndex {
                timeSlots[previous].isSelected = false
            }
            selectedTimeIndex = indexPath.item
            timeSlots[indexPath.item].isSelected = true
            collectionView.reloadData()
            presenter?.didSelectTime(at: indexPath.item)
            
        default: break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OrderAgreementViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

// MARK: - UITextViewDelegate

extension OrderAgreementViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        let count = textView.text.count
        characterCountLabel.text = "\(count) / \(maxCharacterLimit)"
        
        problemTextView.layer.borderColor = count >= maxCharacterLimit ? UIColor.red.cgColor : UIColor.black.cgColor
        presenter?.textViewDidChange(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxCharacterLimit
    }
}
