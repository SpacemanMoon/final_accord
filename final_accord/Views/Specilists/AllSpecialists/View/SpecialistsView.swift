import UIKit

final class SpecialistsViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    private let footerView = CustomFooter()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    
    private let specialistsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = true
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    
    var presenter: SpecialistsPresenterProtocol?
    private var specialists: [SpecialistItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        view.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)
        
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Специалисты")
        
        view.addSubview(headerView)
        view.addSubview(specialistsCollectionView)
        view.addSubview(footerView)
        view.addSubview(activityIndicator)
    }
    
    private func setupCollectionView() {
        specialistsCollectionView.alwaysBounceVertical = true
        specialistsCollectionView.register(
            CustomSpecialistCell.self,
            forCellWithReuseIdentifier: CustomSpecialistCell.reuseIdentifier
        )
        specialistsCollectionView.dataSource = self
        specialistsCollectionView.delegate = self
    }
    
    private func setupConstraints() {
        [headerView, specialistsCollectionView, footerView, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            specialistsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            specialistsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            specialistsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            specialistsCollectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SpecialistsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomSpecialistCell.reuseIdentifier,
            for: indexPath
        ) as? CustomSpecialistCell else {
            return UICollectionViewCell()
        }
        
        let specialist = specialists[indexPath.item]
        cell.configure(with: specialist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectSpecialist(at: indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - SpecialistsViewProtocol

extension SpecialistsViewController: SpecialistsViewProtocol {
    
    func showLoading() {
        specialistsCollectionView.alpha = 0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.specialistsCollectionView.alpha = 1.0
        }
    }
    
    func showSpecialists(_ specialists: [SpecialistItem]) {
        self.specialists = specialists
        specialistsCollectionView.reloadData()
        
        if specialists.isEmpty {
            showLoading()
        } else {
            hideLoading()
        }
    }
    
    func showError(_ error: Error) {
        // Error handling can be implemented here
    }
}
