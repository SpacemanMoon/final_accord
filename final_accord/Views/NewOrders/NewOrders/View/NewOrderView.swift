import UIKit

final class NewOrderViewController: UIViewController {
    
    // MARK: - Private UIComponents
    private let headerView = CustomHeader()
    private let footerView = CustomFooter()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    
    private let createAnOrderButton = UIButton(type: .system)
    private let orderFormScrollView = UIScrollView()
    private let formContentStackView = UIStackView()
    private let servicesTitleLabel = UILabel()
    private let specialistsTitleLabel = UILabel()
    private let servicesCollectionView: UICollectionView
    private let specialistSelectionCollectionView: UICollectionView
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    var presenter: NewOrderPresenterProtocol?
    private var servicesItems: [OrderServiceItem] = []
    private var specialistItems: [OrderSpecialistItem] = []
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let servicesLayout = UICollectionViewFlowLayout()
        servicesLayout.scrollDirection = .horizontal
        servicesLayout.minimumInteritemSpacing = 15
        servicesLayout.minimumLineSpacing = 20
        
        let specialistsLayout = UICollectionViewFlowLayout()
        specialistsLayout.scrollDirection = .horizontal
        specialistsLayout.minimumInteritemSpacing = 15
        specialistsLayout.minimumLineSpacing = 15
        
        servicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: servicesLayout)
        specialistSelectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: specialistsLayout)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Новый заказ")
        
        orderFormScrollView.showsVerticalScrollIndicator = false
        orderFormScrollView.backgroundColor = .clear
        
        formContentStackView.axis = .vertical
        formContentStackView.spacing = 16
        formContentStackView.backgroundColor = .clear
        
        servicesTitleLabel.text = "Выберите услугу"
        servicesTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        servicesTitleLabel.textColor = .white
        
        specialistsTitleLabel.text = "Выберите мастера"
        specialistsTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        specialistsTitleLabel.textColor = .white
        
        servicesCollectionView.backgroundColor = .clear
        servicesCollectionView.showsHorizontalScrollIndicator = false
        servicesCollectionView.layer.cornerRadius = 15
        servicesCollectionView.tag = 0
        servicesCollectionView.alpha = 0
        servicesCollectionView.dataSource = self
        servicesCollectionView.delegate = self
        servicesCollectionView.register(OrderServiceCell.self, forCellWithReuseIdentifier: OrderServiceCell.reuseIdentifier)
        
        specialistSelectionCollectionView.backgroundColor = .clear
        specialistSelectionCollectionView.showsHorizontalScrollIndicator = false
        specialistSelectionCollectionView.layer.cornerRadius = 15
        specialistSelectionCollectionView.tag = 1
        specialistSelectionCollectionView.alpha = 0
        specialistSelectionCollectionView.dataSource = self
        specialistSelectionCollectionView.delegate = self
        specialistSelectionCollectionView.register(OrderSpecialistCell.self, forCellWithReuseIdentifier: OrderSpecialistCell.reuseIdentifier)
        
        createAnOrderButton.setTitle("Создать заказ", for: .normal)
        createAnOrderButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        createAnOrderButton.setTitleColor(.white, for: .normal)
        createAnOrderButton.layer.cornerRadius = 12
        createAnOrderButton.backgroundColor = .systemGray4
        createAnOrderButton.alpha = 0.6
        createAnOrderButton.isEnabled = false
        createAnOrderButton.addTarget(self, action: #selector(createAnOrderButtonTapped), for: .touchUpInside)
        
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(headerView)
        view.addSubview(orderFormScrollView)
        view.addSubview(footerView)
        view.addSubview(createAnOrderButton)
        view.addSubview(activityIndicator)
        
        orderFormScrollView.addSubview(formContentStackView)
        
        formContentStackView.addArrangedSubview(servicesTitleLabel)
        formContentStackView.addArrangedSubview(servicesCollectionView)
        formContentStackView.addArrangedSubview(specialistsTitleLabel)
        formContentStackView.addArrangedSubview(specialistSelectionCollectionView)
    }
    
    private func setupConstraints() {
        [headerView, orderFormScrollView, footerView, createAnOrderButton,
         activityIndicator, formContentStackView, servicesTitleLabel,
         specialistsTitleLabel, servicesCollectionView,
         specialistSelectionCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            orderFormScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            orderFormScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderFormScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            orderFormScrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            formContentStackView.topAnchor.constraint(equalTo: orderFormScrollView.contentLayoutGuide.topAnchor),
            formContentStackView.leadingAnchor.constraint(equalTo: orderFormScrollView.contentLayoutGuide.leadingAnchor),
            formContentStackView.trailingAnchor.constraint(equalTo: orderFormScrollView.contentLayoutGuide.trailingAnchor),
            formContentStackView.bottomAnchor.constraint(equalTo: orderFormScrollView.contentLayoutGuide.bottomAnchor),
            formContentStackView.widthAnchor.constraint(equalTo: orderFormScrollView.frameLayoutGuide.widthAnchor),
            
            servicesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            specialistSelectionCollectionView.heightAnchor.constraint(equalToConstant: 260),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            createAnOrderButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 24),
            createAnOrderButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -24),
            createAnOrderButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            createAnOrderButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func createAnOrderButtonTapped() {
        presenter?.didTapCreateOrder()
    }
}

// MARK: - NewOrderViewProtocol

extension NewOrderViewController: NewOrderViewProtocol {
    
    func updateServices(with items: [OrderServiceItem]) {
        servicesItems = items
        servicesCollectionView.reloadData()
        servicesCollectionView.alpha = 1.0
        specialistsTitleLabel.isHidden = true
        specialistSelectionCollectionView.isHidden = true
    }
    
    func updateSpecialists(with items: [OrderSpecialistItem]) {
        specialistItems = items
        specialistSelectionCollectionView.reloadData()
        let hasSpecialists = !items.isEmpty
        specialistsTitleLabel.isHidden = !hasSpecialists
        specialistSelectionCollectionView.isHidden = !hasSpecialists
        
        if hasSpecialists {
            specialistSelectionCollectionView.alpha = 1.0
        }
    }
    
    func updateButtonState(isEnabled: Bool) {
        createAnOrderButton.isEnabled = isEnabled
        createAnOrderButton.backgroundColor = isEnabled ? .green : .systemGray4
        createAnOrderButton.alpha = isEnabled ? 1.0 : 0.6
    }
    
    func showError(_ error: String) {
        hideLoading()
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess() {
        hideLoading()
        let alert = UIAlertController(title: "Успешно", message: "Заказ создан!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        servicesCollectionView.alpha = 0
        specialistSelectionCollectionView.alpha = 0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.servicesCollectionView.alpha = 1.0
            self?.specialistSelectionCollectionView.alpha = 1.0
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NewOrderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return servicesItems.count
        case 1:
            return specialistItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == servicesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderServiceCell.reuseIdentifier,
                for: indexPath
            ) as? OrderServiceCell else {
                return UICollectionViewCell()
            }
            let item = servicesItems[indexPath.item]
            let isSelected = presenter?.isServiceSelected(at: indexPath.item) ?? false
            cell.configure(with: item, isSelected: isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderSpecialistCell.reuseIdentifier,
                for: indexPath
            ) as? OrderSpecialistCell else {
                return UICollectionViewCell()
            }
            let item = specialistItems[indexPath.item]
            let isSelected = presenter?.isSpecialistSelected(at: indexPath.item) ?? false
            cell.configure(with: item, isSelected: isSelected)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewOrderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: 130, height: 200)
        case 1:
            return CGSize(width: view.frame.width / 2, height: 260)
        default:
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegate
extension NewOrderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCollectionView {
            presenter?.didSelectService(at: indexPath.item)
        } else {
            presenter?.didSelectSpecialist(at: indexPath.item)
        }
    }
}
