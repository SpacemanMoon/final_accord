import UIKit

enum TextFieldType {
    case firstName
    case lastName
    case password
    case confirmPassword
    case phone
    case email
    
    var iconName: String {
        switch self {
        case .firstName: return "person.fill"
        case .lastName: return "person.fill"
        case .password: return "lock.fill"
        case .confirmPassword: return "lock.fill"
        case .phone: return "number.square.fill"
        case .email: return "envelope.fill"
        }
    }
    
    var placeholder: String {
        switch self {
        case .firstName: return "Введите имя"
        case .lastName: return "Введите фамилию"
        case .password: return "Введите пароль"
        case .confirmPassword: return "Подтвердите пароль"
        case .phone: return "Введите номер"
        case .email: return "Введите email"
        }
    }
}

final class CustomTextField: UITextField {
    
    // MARK: - Private UIComponents
    
    private let iconImageView = UIImageView()
    private let showPasswordButton = UIButton()
    private let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    private let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseStyle()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseStyle()
        setupSubviews()
    }
    
    // MARK: - Private Methods
    
    private func setupBaseStyle() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.7).cgColor
        layer.masksToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        textColor = .black
        
        updatePlaceholderColor()
    }
    
    private func setupSubviews() {
        iconImageView.frame = leftContainer.bounds
        iconImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        iconImageView.contentMode = .center
        iconImageView.tintColor = .black
        leftContainer.addSubview(iconImageView)
        
        showPasswordButton.frame = rightContainer.bounds
        showPasswordButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showPasswordButton.tintColor = .black
        showPasswordButton.addTarget(self, action: #selector(toggleSecureTextEntry), for: .touchUpInside)
        rightContainer.addSubview(showPasswordButton)
    }
    
    // MARK: - Public Methods
    
    func configure(with type: TextFieldType) {
        iconImageView.image = UIImage(systemName: type.iconName)
        placeholder = type.placeholder
        
        updatePlaceholderColor()
        
        leftView = leftContainer
        leftViewMode = .always
        
        if type == .password || type == .confirmPassword {
            isSecureTextEntry = true
            rightView = rightContainer
            rightViewMode = .always
        } else {
            isSecureTextEntry = false
            rightView = nil
            rightViewMode = .never
        }
    }

    private func updatePlaceholderColor() {
        guard let placeholderText = self.placeholder else { return }
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
    // MARK: - Actions
    
    @objc private func toggleSecureTextEntry() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
