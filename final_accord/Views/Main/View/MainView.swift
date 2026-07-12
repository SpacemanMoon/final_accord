import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    private let contentView = CustomBody()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let mainScrollView = UIScrollView()
    private let mainStackView = UIStackView()
    
    private let promoContainerView = UIView()
    private let promoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 15
        collectionView.clipsToBounds = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let promoPageControl = UIPageControl()
    
    private let popularServicesStackView = UIStackView()
    private let popularServicesLabel = CustomLabel(text: "Популярные услуги", type: .heading)
    private let popularServicesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let recommendedMastersStackView = UIStackView()
    private let recommendedMastersLabel = CustomLabel(text: "Рекомендуемые мастера", type: .heading)
    private let recommendedMastersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    var presenter: MainPresenterProtocol?
    private var promos: [PromoCellItem] = []
    private var services: [PopularServicesItem] = []
    private var masters: [RecommendedSpecialistItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
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
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Главная")
        
        refreshControl.tintColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(
            string: "Обновление данных...",
            attributes: [.foregroundColor: UIColor(white: 0.7, alpha: 1.0)]
        )
        mainScrollView.refreshControl = refreshControl
        
        activityIndicator.color = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        activityIndicator.hidesWhenStopped = true
        
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.alwaysBounceVertical = true
        mainScrollView.backgroundColor = .clear
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.distribution = .fill
        mainStackView.alignment = .fill
        mainStackView.backgroundColor = .clear
        
        promoContainerView.backgroundColor = .clear
        
        promoCollectionView.tag = 0
        promoCollectionView.register(CustomPromoCell.self, forCellWithReuseIdentifier: CustomPromoCell.reuseIdentifier)
        promoCollectionView.delegate = self
        promoCollectionView.dataSource = self
        
        promoPageControl.currentPageIndicatorTintColor = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        promoPageControl.pageIndicatorTintColor = UIColor(white: 0.4, alpha: 1.0)
        promoPageControl.numberOfPages = promos.count
        promoPageControl.currentPage = 0
        
        popularServicesStackView.axis = .vertical
        popularServicesStackView.spacing = 12
        popularServicesStackView.backgroundColor = .clear
        
        popularServicesCollectionView.tag = 1
        popularServicesCollectionView.register(CustomPopularServicesCell.self, forCellWithReuseIdentifier: CustomPopularServicesCell.reuseIdentifier)
        popularServicesCollectionView.delegate = self
        popularServicesCollectionView.dataSource = self
        
        popularServicesLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        recommendedMastersStackView.axis = .vertical
        recommendedMastersStackView.spacing = 12
        recommendedMastersStackView.backgroundColor = .clear
        
        recommendedMastersCollectionView.tag = 2
        recommendedMastersCollectionView.register(CustomRecommendedSpecialistCell.self, forCellWithReuseIdentifier: CustomRecommendedSpecialistCell.reuseIdentifier)
        recommendedMastersCollectionView.delegate = self
        recommendedMastersCollectionView.dataSource = self
        
        recommendedMastersLabel.textColor = UIColor(white: 0.95, alpha: 1.0)
        
        view.addSubview(headerView)
        view.addSubview(contentView)
        
        contentView.addSubview(mainScrollView)
        contentView.addSubview(activityIndicator)
        mainScrollView.addSubview(mainStackView)
        
        promoContainerView.addSubview(promoCollectionView)
        promoContainerView.addSubview(promoPageControl)
        mainStackView.addArrangedSubview(promoContainerView)
        
        popularServicesStackView.addArrangedSubview(popularServicesLabel)
        popularServicesStackView.addArrangedSubview(popularServicesCollectionView)
        mainStackView.addArrangedSubview(popularServicesStackView)
        
        recommendedMastersStackView.addArrangedSubview(recommendedMastersLabel)
        recommendedMastersStackView.addArrangedSubview(recommendedMastersCollectionView)
        mainStackView.addArrangedSubview(recommendedMastersStackView)
    }
    
    private func setupConstraints() {
        [headerView, contentView, activityIndicator, mainScrollView,
         mainStackView, promoContainerView, promoPageControl,
         popularServicesLabel, recommendedMastersLabel,
         popularServicesCollectionView, recommendedMastersCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            mainScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor),
            
            promoCollectionView.topAnchor.constraint(equalTo: promoContainerView.topAnchor),
            promoCollectionView.leadingAnchor.constraint(equalTo: promoContainerView.leadingAnchor, constant: 16),
            promoCollectionView.trailingAnchor.constraint(equalTo: promoContainerView.trailingAnchor, constant: -16),
            promoCollectionView.heightAnchor.constraint(equalToConstant: 170),
            
            promoPageControl.topAnchor.constraint(equalTo: promoCollectionView.bottomAnchor, constant: 8),
            promoPageControl.centerXAnchor.constraint(equalTo: promoContainerView.centerXAnchor),
            promoPageControl.bottomAnchor.constraint(equalTo: promoContainerView.bottomAnchor),
            
            popularServicesLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            popularServicesLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            popularServicesCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            recommendedMastersLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            recommendedMastersLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            recommendedMastersCollectionView.heightAnchor.constraint(equalToConstant: 420),
            recommendedMastersCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            recommendedMastersCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc private func handleRefresh() {
        presenter?.viewDidPullToRefresh()
    }
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func showLoading() {
        mainStackView.alpha = 0.0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mainStackView.alpha = 1.0
        }
    }
    
    func displayData(promos: [PromoCellItem], services: [PopularServicesItem], masters: [RecommendedSpecialistItem]) {
        self.promos = promos
        self.services = services
        self.masters = masters
        promoPageControl.numberOfPages = promos.count
        
        recommendedMastersLabel.text = "Рекомендуемые мастера (\(masters.count))"
        
        promoCollectionView.reloadData()
        popularServicesCollectionView.reloadData()
        recommendedMastersCollectionView.reloadData()
        
        hideLoading()
        refreshControl.endRefreshing()
    }
    
    func displayError(_ message: String) {
        hideLoading()
        refreshControl.endRefreshing()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return promos.count
        case 1:
            return services.count
        case 2:
            return masters.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomPromoCell.reuseIdentifier,
                for: indexPath
            ) as? CustomPromoCell else {
                return UICollectionViewCell()
            }
            
            guard indexPath.item < promos.count else { return cell }
            let promo = promos[indexPath.item]
            cell.configure(with: promo)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomPopularServicesCell.reuseIdentifier,
                for: indexPath
            ) as? CustomPopularServicesCell else {
                return UICollectionViewCell()
            }
            
            guard indexPath.item < services.count else { return cell }
            cell.configure(with: services[indexPath.item])
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRecommendedSpecialistCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRecommendedSpecialistCell else {
                return UICollectionViewCell()
            }
            
            guard indexPath.item < masters.count else { return cell }
            cell.configure(with: masters[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            let width = collectionView.frame.width
            return CGSize(width: width, height: 180)
            
        case 1:
            return CGSize(width: 80, height: 80)
            
        case 2:
            let padding: CGFloat = 12
            let availableWidth = collectionView.frame.width - padding
            let width = availableWidth / 2
            return CGSize(width: width, height: 250)
            
        default:
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.tag == 0 else { return }
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        guard page >= 0 && page < promoPageControl.numberOfPages else { return }
        
        promoPageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard collectionView.tag != 0 else { return }
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            cell?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard collectionView.tag != 0 else { return }
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            cell?.transform = .identity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            return
            
        case 1:
            presenter?.didSelectItemPopularService()
            
        case 2:
            guard indexPath.item < masters.count else { return }
            let master = masters[indexPath.item]
            presenter?.didSelectRecommendedMasters(with: master.id)
            
        default:
            break
        }
    }
}
