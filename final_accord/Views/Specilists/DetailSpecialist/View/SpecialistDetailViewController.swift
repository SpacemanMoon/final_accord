import UIKit

final class SpecialistDetailViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    // MARK: - Properties
    
    var presenter: SpecialistDetailPresenterProtocol?
    private var specialistDetail: SpecialistItem?
    
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
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(CustomSpecialistPhotoCell.self, forCellWithReuseIdentifier: CustomSpecialistPhotoCell.reuseIdentifier)
        
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        infoCollectionView.register(SpecialistDetailInfoCell.self, forCellWithReuseIdentifier: SpecialistDetailInfoCell.reuseIdentifier)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor(red: 0.22, green: 0.42, blue: 0.86, alpha: 1.0)
        
        view.addSubview(headerView)
        view.addSubview(photoCollectionView)
        view.addSubview(infoCollectionView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        [headerView, photoCollectionView, infoCollectionView, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            photoCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            infoCollectionView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor),
            infoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - SpecialistDetailViewProtocol

extension SpecialistDetailViewController: SpecialistDetailViewProtocol {
    
    func showError(_ message: String) {
        hideLoading()
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSpecialist(_ specialist: SpecialistItem) {
        specialistDetail = specialist
        photoCollectionView.reloadData()
        infoCollectionView.reloadData()
        hideLoading()
    }
    
    func showLoading() {
        photoCollectionView.alpha = 0
        infoCollectionView.alpha = 0
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.photoCollectionView.alpha = 1.0
            self?.infoCollectionView.alpha = 1.0
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SpecialistDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialistDetail != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let specialist = specialistDetail else {
            return UICollectionViewCell()
        }
        
        if collectionView == photoCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomSpecialistPhotoCell.reuseIdentifier,
                for: indexPath
            ) as? CustomSpecialistPhotoCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: specialist)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SpecialistDetailInfoCell.reuseIdentifier,
                for: indexPath
            ) as? SpecialistDetailInfoCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: specialist)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpecialistDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photoCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: 600)
        }
    }
}
