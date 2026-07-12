import UIKit

// MARK: - AboutUsViewController
final class AboutUsViewController: UIViewController {
    
    // MARK: - Private UIComponents
    private let headerView = CustomHeader()
    private let bodyView = CustomBody()
    private let infoContainerView = CustomView(type: .card)
    private let infoAboutCompanyLabel = CustomLabel()
    private let contactsContainerView = CustomView(type: .card)
    private let stackContacts = UIStackView()
    private let emailLabel = CustomLabel()
    private let phoneLabel = CustomLabel()
    private let telegramLabel = CustomLabel()
    private let instagramLabel = CustomLabel()
    private let vkontakteLabel = CustomLabel()
    private let directorNameLabel = CustomLabel()
    private let mainOfficeLabel = CustomLabel()
    private let footerView = CustomFooter()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    var presenter: AboutUsPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        view.addSubview(headerView)
        view.addSubview(bodyView)
        view.addSubview(footerView)
        view.addSubview(activityIndicator)
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "О нас")
        
        bodyView.addSubview(infoContainerView)
        infoContainerView.addSubview(infoAboutCompanyLabel)
        bodyView.addSubview(contactsContainerView)
        contactsContainerView.addSubview(stackContacts)
        
        infoContainerView.backgroundColor = .darkGray.withAlphaComponent(0.15)
        
        infoAboutCompanyLabel.textColor = .white
        infoAboutCompanyLabel.numberOfLines = 0
        infoAboutCompanyLabel.font = .systemFont(ofSize: 16)
        
        contactsContainerView.backgroundColor = .darkGray.withAlphaComponent(0.15)
        
        stackContacts.translatesAutoresizingMaskIntoConstraints = false
        stackContacts.backgroundColor = .clear
        stackContacts.axis = .vertical
        stackContacts.spacing = 10
        stackContacts.alignment = .leading
        stackContacts.distribution = .fillEqually
        
        [emailLabel, phoneLabel, telegramLabel, instagramLabel,
         vkontakteLabel, directorNameLabel, mainOfficeLabel].forEach {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 15)
            $0.numberOfLines = 0
            stackContacts.addArrangedSubview($0)
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        additionalSafeAreaInsets = .zero
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            bodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            infoContainerView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 10),
            infoContainerView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
            infoContainerView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -10),
            infoContainerView.heightAnchor.constraint(equalToConstant: 300),
            
            infoAboutCompanyLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 10),
            infoAboutCompanyLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 10),
            infoAboutCompanyLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -10),
            infoAboutCompanyLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -10),
            
            contactsContainerView.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: 20),
            contactsContainerView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
            contactsContainerView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -10),
            contactsContainerView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -10),
            
            stackContacts.topAnchor.constraint(equalTo: contactsContainerView.topAnchor, constant: 10),
            stackContacts.leadingAnchor.constraint(equalTo: contactsContainerView.leadingAnchor, constant: 10),
            stackContacts.trailingAnchor.constraint(equalTo: contactsContainerView.trailingAnchor, constant: -10),
            stackContacts.bottomAnchor.constraint(equalTo: contactsContainerView.bottomAnchor, constant: -10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AboutUsViewProtocol
extension AboutUsViewController: AboutUsViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayAboutData(_ data: AboutUsModel) {
        infoAboutCompanyLabel.text = data.infoAboutCompany
        
        emailLabel.text = "Email: \(data.email)"
        phoneLabel.text = "Телефон: \(data.phone)"
        telegramLabel.text = "Telegram: \(data.telegram)"
        instagramLabel.text = "Instagram: \(data.instagram)"
        vkontakteLabel.text = "VK: \(data.vkontakte)"
        directorNameLabel.text = "Директор: \(data.directorName)"
        mainOfficeLabel.text = "Офис: \(data.mainOfficeAddress)"
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
}

// MARK: - Preview
#Preview {
    AboutUsViewController()
}
