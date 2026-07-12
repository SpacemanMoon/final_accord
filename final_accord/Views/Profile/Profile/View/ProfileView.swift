import UIKit
import Photos
import AVFoundation

final class ProfileViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    
    private let profileContainerView = CustomBody()
    private let userInfoContainerView = CustomView(type: .card)
    private let avatarImageContainerView = CustomView(type: .circle)
    private let avatarImageView = UIImageView()
    private let stackUserInfo = UIStackView()
    private let clientIdLabel = UILabel()
    private let clientNameLabel = UILabel()
    private let clientEmailLabel = UILabel()
    
    private let controlMenuContainerView = CustomView(type: .card)
    
    private let noticeLabel = CustomLabel()
    private let noticeSwitch = UISwitch()
    
    private let phoneTitleLabel = CustomLabel()
    private let phoneTextField = UITextField()
    
    private let cityTitleLabel = CustomLabel()
    private let cityPickerTextField = PickerTextField()
    
    private let addressTitleLabel = CustomLabel()
    private let addressTextField = UITextField()
    
    private let myOrdersButton = UIButton()
    private let aboutCompanyButton = UIButton()
    private let deleteAccountButton = UIButton()
    
    private let footerView = CustomFooter()
    private let logoutButton = UIButton()
    
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCities()
        setupTapGesture()
        presenter?.viewDidLoad()
        setupNoticeSwitchState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        avatarImageContainerView.layer.cornerRadius = avatarImageContainerView.frame.width / 2
    }
    
    // MARK: - Private Methods
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndPicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupCities() {
        cityPickerTextField.items = presenter?.getCities() ?? []
    }
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Профиль")
        
        userInfoContainerView.backgroundColor = .darkGray.withAlphaComponent(0.15)
        
        stackUserInfo.axis = .vertical
        stackUserInfo.spacing = 5
        stackUserInfo.backgroundColor = .clear
        stackUserInfo.alignment = .leading
        stackUserInfo.distribution = .fillProportionally
        
        clientIdLabel.textColor = .gray
        clientIdLabel.font = .systemFont(ofSize: 12)
        
        clientNameLabel.textColor = .white
        clientNameLabel.font = .systemFont(ofSize: 14)
        
        clientEmailLabel.textColor = .white
        clientEmailLabel.font = .systemFont(ofSize: 14)
        
        [clientIdLabel, clientNameLabel, clientEmailLabel].forEach {
            stackUserInfo.addArrangedSubview($0)
        }
        
        avatarImageContainerView.backgroundColor = .clear
        avatarImageContainerView.layer.borderWidth = 2
        avatarImageContainerView.layer.borderColor = UIColor.white.cgColor
        avatarImageContainerView.clipsToBounds = true
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .white
        avatarImageView.backgroundColor = .darkGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageContainerView.addGestureRecognizer(tapGesture)
        avatarImageContainerView.isUserInteractionEnabled = true
        
        controlMenuContainerView.backgroundColor = .darkGray.withAlphaComponent(0.15)
        
        noticeLabel.textColor = .white
        noticeLabel.text = "Уведомления о заказе"
        
        noticeSwitch.onTintColor = .green
        noticeSwitch.addTarget(self, action: #selector(noticeSwitchToggled), for: .valueChanged)
        
        phoneTitleLabel.text = "Телефон"
        phoneTitleLabel.font = .systemFont(ofSize: 13)
        phoneTitleLabel.textColor = .gray
        
        phoneTextField.placeholder = "Введите телефон"
        phoneTextField.textColor = .white
        phoneTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите телефон",
            attributes: [.foregroundColor: UIColor.gray]
        )
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.backgroundColor = .darkGray.withAlphaComponent(0.3)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.clearButtonMode = .whileEditing
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        
        cityTitleLabel.text = "Город"
        cityTitleLabel.font = .systemFont(ofSize: 13)
        cityTitleLabel.textColor = .gray
        
        cityPickerTextField.placeholder = "Выберите город"
        cityPickerTextField.textColor = .white
        cityPickerTextField.attributedPlaceholder = NSAttributedString(
            string: "Выберите город",
            attributes: [.foregroundColor: UIColor.gray]
        )
        cityPickerTextField.borderStyle = .roundedRect
        cityPickerTextField.backgroundColor = .darkGray.withAlphaComponent(0.3)
        cityPickerTextField.tintColor = .clear
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrowImageView.tintColor = .gray
        arrowImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cityPickerTextField.rightView = arrowImageView
        cityPickerTextField.rightViewMode = .always
        
        cityPickerTextField.onSelect = { [weak self] city in
            self?.presenter?.didChangeCity(city)
        }
        
        addressTitleLabel.text = "Адрес"
        addressTitleLabel.font = .systemFont(ofSize: 13)
        addressTitleLabel.textColor = .gray
        
        addressTextField.placeholder = "Введите адрес"
        addressTextField.textColor = .white
        addressTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите адрес",
            attributes: [.foregroundColor: UIColor.gray]
        )
        addressTextField.borderStyle = .roundedRect
        addressTextField.backgroundColor = .darkGray.withAlphaComponent(0.3)
        addressTextField.clearButtonMode = .whileEditing
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange), for: .editingChanged)
        
        myOrdersButton.setTitle("Мои заказы", for: .normal)
        myOrdersButton.backgroundColor = .clear
        myOrdersButton.setTitleColor(.white, for: .normal)
        myOrdersButton.contentHorizontalAlignment = .left
        myOrdersButton.addTarget(self, action: #selector(myOrdersButtonTapped), for: .touchUpInside)
        
        aboutCompanyButton.setTitle("О компании", for: .normal)
        aboutCompanyButton.backgroundColor = .clear
        aboutCompanyButton.setTitleColor(.white, for: .normal)
        aboutCompanyButton.contentHorizontalAlignment = .left
        aboutCompanyButton.addTarget(self, action: #selector(aboutCompanyButtonTapped), for: .touchUpInside)
        
        deleteAccountButton.setTitle("Удалить аккаунт", for: .normal)
        deleteAccountButton.backgroundColor = .clear
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.contentHorizontalAlignment = .left
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        logoutButton.setTitle("Выйти из профиля", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 16
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOpacity = 0.3
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        logoutButton.layer.shadowRadius = 4
        logoutButton.layer.masksToBounds = false
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(headerView)
        view.addSubview(profileContainerView)
        view.addSubview(footerView)
        view.addSubview(activityIndicator)
        
        profileContainerView.addSubview(userInfoContainerView)
        profileContainerView.addSubview(controlMenuContainerView)
        
        userInfoContainerView.addSubview(stackUserInfo)
        userInfoContainerView.addSubview(avatarImageContainerView)
        
        avatarImageContainerView.addSubview(avatarImageView)
        
        controlMenuContainerView.addSubview(noticeLabel)
        controlMenuContainerView.addSubview(noticeSwitch)
        
        controlMenuContainerView.addSubview(phoneTitleLabel)
        controlMenuContainerView.addSubview(phoneTextField)
        
        controlMenuContainerView.addSubview(cityTitleLabel)
        controlMenuContainerView.addSubview(cityPickerTextField)
        
        controlMenuContainerView.addSubview(addressTitleLabel)
        controlMenuContainerView.addSubview(addressTextField)
        
        controlMenuContainerView.addSubview(myOrdersButton)
        controlMenuContainerView.addSubview(aboutCompanyButton)
        controlMenuContainerView.addSubview(deleteAccountButton)
        
        footerView.addSubview(logoutButton)
        
        additionalSafeAreaInsets = .zero
    }
    
    private func setupNoticeSwitchState() {
        if let stateSwitch = presenter?.noticeToggle() {
            noticeSwitch.isOn = stateSwitch
        }
    }
    
    private func setupConstraints() {
        [headerView, profileContainerView, footerView, userInfoContainerView,
         stackUserInfo, avatarImageContainerView, avatarImageView,
         controlMenuContainerView, noticeLabel, noticeSwitch,
         phoneTitleLabel, phoneTextField, cityTitleLabel,
         cityPickerTextField, addressTitleLabel, addressTextField,
         myOrdersButton, aboutCompanyButton, deleteAccountButton,
         logoutButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            profileContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileContainerView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            userInfoContainerView.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: 5),
            userInfoContainerView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 10),
            userInfoContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -10),
            userInfoContainerView.heightAnchor.constraint(equalToConstant: 130),
            
            stackUserInfo.topAnchor.constraint(equalTo: userInfoContainerView.topAnchor, constant: 5),
            stackUserInfo.leadingAnchor.constraint(equalTo: userInfoContainerView.leadingAnchor, constant: 15),
            stackUserInfo.trailingAnchor.constraint(equalTo: avatarImageContainerView.leadingAnchor, constant: -2),
            stackUserInfo.bottomAnchor.constraint(equalTo: userInfoContainerView.bottomAnchor, constant: -10),
            
            avatarImageContainerView.topAnchor.constraint(equalTo: userInfoContainerView.topAnchor, constant: 5),
            avatarImageContainerView.trailingAnchor.constraint(equalTo: userInfoContainerView.trailingAnchor, constant: -10),
            avatarImageContainerView.heightAnchor.constraint(equalToConstant: 110),
            avatarImageContainerView.widthAnchor.constraint(equalToConstant: 110),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarImageContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarImageContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageContainerView.widthAnchor, multiplier: 0.9),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageContainerView.heightAnchor, multiplier: 0.9),
            
            controlMenuContainerView.topAnchor.constraint(equalTo: userInfoContainerView.bottomAnchor, constant: 10),
            controlMenuContainerView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 10),
            controlMenuContainerView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -10),
            controlMenuContainerView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: -20),
            
            noticeLabel.topAnchor.constraint(equalTo: controlMenuContainerView.topAnchor, constant: 15),
            noticeLabel.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            noticeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            noticeSwitch.topAnchor.constraint(equalTo: controlMenuContainerView.topAnchor, constant: 15),
            noticeSwitch.trailingAnchor.constraint(equalTo: controlMenuContainerView.trailingAnchor, constant: -15),
            noticeSwitch.heightAnchor.constraint(equalToConstant: 30),
            noticeSwitch.widthAnchor.constraint(equalToConstant: 60),
            
            phoneTitleLabel.topAnchor.constraint(equalTo: noticeLabel.bottomAnchor, constant: 12),
            phoneTitleLabel.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            phoneTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneTitleLabel.bottomAnchor, constant: 4),
            phoneTextField.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            phoneTextField.trailingAnchor.constraint(equalTo: controlMenuContainerView.trailingAnchor, constant: -10),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40),
            
            cityTitleLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            cityTitleLabel.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            cityTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            cityPickerTextField.topAnchor.constraint(equalTo: cityTitleLabel.bottomAnchor, constant: 4),
            cityPickerTextField.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            cityPickerTextField.trailingAnchor.constraint(equalTo: controlMenuContainerView.trailingAnchor, constant: -10),
            cityPickerTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addressTitleLabel.topAnchor.constraint(equalTo: cityPickerTextField.bottomAnchor, constant: 12),
            addressTitleLabel.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            addressTitleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            addressTextField.topAnchor.constraint(equalTo: addressTitleLabel.bottomAnchor, constant: 4),
            addressTextField.leadingAnchor.constraint(equalTo: controlMenuContainerView.leadingAnchor, constant: 10),
            addressTextField.trailingAnchor.constraint(equalTo: controlMenuContainerView.trailingAnchor, constant: -10),
            addressTextField.heightAnchor.constraint(equalToConstant: 40),
            
            myOrdersButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 15),
            myOrdersButton.widthAnchor.constraint(equalToConstant: 150),
            myOrdersButton.heightAnchor.constraint(equalToConstant: 40),
            
            aboutCompanyButton.topAnchor.constraint(equalTo: myOrdersButton.bottomAnchor, constant: 12),
            aboutCompanyButton.widthAnchor.constraint(equalToConstant: 150),
            aboutCompanyButton.heightAnchor.constraint(equalToConstant: 40),
            
            deleteAccountButton.topAnchor.constraint(equalTo: aboutCompanyButton.bottomAnchor, constant: 12),
            deleteAccountButton.widthAnchor.constraint(equalToConstant: 150),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -24),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboardAndPicker() {
        view.endEditing(true)
    }
    
    @objc private func noticeSwitchToggled() {
        let isOn = noticeSwitch.isOn
        presenter?.didChangeNoticeState(isOn: isOn)
    }
    
    @objc private func phoneTextFieldDidChange() {
        guard let phone = phoneTextField.text, !phone.isEmpty else { return }
        presenter?.didChangePhone(phone)
    }
    
    @objc private func addressTextFieldDidChange() {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        presenter?.didChangeAddress(address)
    }
    
    @objc private func myOrdersButtonTapped() {
        presenter?.didTapMyOrdersButton()
    }
    
    @objc private func aboutCompanyButtonTapped() {
        presenter?.didTapAboutCompanyButton()
    }
    
    @objc private func deleteAccountButtonTapped() {
        presenter?.didTapDeleteAccountButton()
    }
    
    @objc private func logoutButtonTapped() {
        presenter?.didTapLogout()
    }
    
    @objc private func avatarTapped() {
        presenter?.didTapAvatar()
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateProfile(with model: ProfileModel) {
        clientIdLabel.text = "ID: \(model.id)"
        clientNameLabel.text = "Имя: \(model.name)"
        clientEmailLabel.text = "Email: \(model.email)"
        
        phoneTextField.text = model.phone
        cityPickerTextField.text = model.city
        addressTextField.text = model.address
        
        noticeSwitch.isOn = model.pushNotificationsEnabled
    }
    
    func updatePushNotificationState(isOn: Bool) {
        noticeSwitch.isOn = isOn
    }
    
    func showDeleteAccountConfirmation(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Удаление аккаунта",
            message: "Вы уверены, что хотите удалить свой аккаунт? Это действие необратимо. Все ваши данные будут удалены.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(false)
        }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            completion(true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func showSuccessAndNavigate(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.presenter?.didTapDeleteAccountSuccess()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showReauthAlert(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Введите ваш пароль для подтверждения удаления аккаунта",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Пароль"
            textField.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(nil)
        }
        
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .destructive) { _ in
            let password = alert.textFields?.first?.text
            completion(password)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    func showAvatarPickerOptions() {
        let alertController = UIAlertController(
            title: "Выберите фото",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            self?.presenter?.didSelectCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { [weak self] _ in
            self?.presenter?.didSelectGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func updateAvatar(with imageData: Data) {
        DispatchQueue.main.async {
            guard let image = UIImage(data: imageData) else { return }
            self.avatarImageView.image = image
            self.avatarImageView.contentMode = .scaleAspectFill
            self.avatarImageView.clipsToBounds = true
            self.avatarImageView.setNeedsDisplay()
        }
    }
    
    func showCameraPicker() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            openCameraPicker()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.openCameraPicker()
                    } else {
                        self?.showError("Нет доступа к камере. Разрешите доступ в настройках.")
                    }
                }
            }
        case .denied, .restricted:
            showError("Нет доступа к камере. Разрешите доступ в настройках.")
        @unknown default:
            break
        }
    }
    
    func showGalleryPicker() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            openGalleryPicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.openGalleryPicker()
                    } else {
                        self?.showError("Нет доступа к галерее. Разрешите доступ в настройках.")
                    }
                }
            }
        case .denied, .restricted:
            showError("Нет доступа к галерее. Разрешите доступ в настройках.")
        @unknown default:
            break
        }
    }
    
    // MARK: - Private Helpers
    
    private func openCameraPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showError("Камера недоступна")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    private func openGalleryPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showError("Галерея недоступна")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
                self.showError("Не удалось получить изображение")
                return
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                self.showError("Не удалось обработать изображение")
                return
            }
            
            self.presenter?.didSelectImage(imageData)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Preview

#Preview {
    ProfileViewController()
}
