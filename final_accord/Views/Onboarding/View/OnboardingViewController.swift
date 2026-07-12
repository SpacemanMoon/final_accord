import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray.withAlphaComponent(0.5)
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    // MARK: - Properties
    
    var presenter: OnboardingPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(onboardingCollectionView)
        view.addSubview(pageControl)
        
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
        onboardingCollectionView.register(CustomOnboardingCell.self, forCellWithReuseIdentifier: CustomOnboardingCell.reuseidentifier)
    }
    
    private func setupConstraints() {
        [onboardingCollectionView, pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            onboardingCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.itemsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomOnboardingCell.reuseidentifier,
            for: indexPath
        ) as? CustomOnboardingCell else {
            return UICollectionViewCell()
        }
        
        guard let presenter = presenter else { return cell }
        
        let item = presenter.item(at: indexPath.item)
        cell.configure(with: item)
        cell.configureButtons(isLastPage: presenter.isLastPage(at: indexPath.item))
        
        cell.onNextButtonTapped = { [weak self] in
            self?.presenter?.nextButtonTapped()
        }
        
        cell.onSkipButtonTapped = { [weak self] in
            self?.presenter?.skipButtonTapped()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        if width > 0 {
            let page = Int(scrollView.contentOffset.x / width)
            presenter?.didScrollToPage(page)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {
    
    func scrollToItem(at index: Int) {
        let nextIndexPath = IndexPath(item: index, section: 0)
        onboardingCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func reloadData() {
        onboardingCollectionView.reloadData()
    }
    
    func updateUI(page: Int, totalPages: Int, isLastPage: Bool) {
        pageControl.currentPage = page
        pageControl.numberOfPages = totalPages
        
        if let cell = onboardingCollectionView.visibleCells.first as? CustomOnboardingCell {
            cell.configureButtons(isLastPage: isLastPage)
        }
    }
}
