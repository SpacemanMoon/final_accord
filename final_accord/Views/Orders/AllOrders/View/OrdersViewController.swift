import UIKit

final class OrdersViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let headerView = CustomHeader()
    private let listContainerView = CustomBody()
    private let footerView = CustomFooter()
    private let segmentControl = UISegmentedControl(items: ["Активные", "Завершенные"])
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    private let backgroundGradient = CAGradientLayer.appBackgroundGradient()
    
    // MARK: - Properties
    
    var presenter: OrdersPresenterProtocol?
    private var currentSegment: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViews()
        setupConstraints()
        setupRefreshControl()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradient, at: 0)
        view.addSubview(headerView)
        view.addSubview(listContainerView)
        view.addSubview(footerView)
        
        listContainerView.addSubview(segmentControl)
        listContainerView.addSubview(tableView)
        listContainerView.addSubview(loadingIndicator)
        listContainerView.addSubview(emptyStateLabel)
    }
    
    private func configureViews() {
        headerView.layer.cornerRadius = 16
        headerView.layer.masksToBounds = true
        headerView.configure(title: "Мои заказы")
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CustomOrdersCell.self, forCellReuseIdentifier: CustomOrdersCell.reuseidentifier)
        
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshOrders), for: .valueChanged)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        
        emptyStateLabel.text = "Нет заказов"
        emptyStateLabel.textColor = .white
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.isHidden = true
    }
    
    private func setupConstraints() {
        [headerView, listContainerView, footerView, segmentControl, tableView, loadingIndicator, emptyStateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            listContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            listContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listContainerView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -12),
            
            segmentControl.topAnchor.constraint(equalTo: listContainerView.topAnchor, constant: 12),
            segmentControl.leadingAnchor.constraint(equalTo: listContainerView.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: listContainerView.trailingAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: listContainerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: listContainerView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: listContainerView.bottomAnchor, constant: -12),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: listContainerView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: listContainerView.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: listContainerView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: listContainerView.centerYAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged() {
        currentSegment = segmentControl.selectedSegmentIndex
        tableView.reloadData()
    }
    
    @objc private func refreshOrders() {
        presenter?.refreshOrders()
    }
}

// MARK: - OrdersViewProtocol

extension OrdersViewController: OrdersViewProtocol {
    
    func showOrders(activeOrders: [OrderFirestore], completedOrders: [OrderFirestore]) {
        tableView.reloadData()
        let isEmpty = activeOrders.isEmpty && completedOrders.isEmpty
        emptyStateLabel.isHidden = !isEmpty
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func updateOrderStatus(at index: Int, in section: OrdersSection) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showConfirmationAlert(title: String, message: String, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .destructive) { _ in
            confirmAction()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension OrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let orders = presenter?.getOrders(for: currentSegment) else { return }
        _ = orders[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK: - UITableViewDataSource

extension OrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getOrders(for: currentSegment).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomOrdersCell.reuseidentifier, for: indexPath) as? CustomOrdersCell else {
            return UITableViewCell()
        }
        
        guard let orders = presenter?.getOrders(for: currentSegment) else { return cell }
        let order = orders[indexPath.row]
        
        cell.configure(with: order)
        
        if let action = presenter?.getOrderAction(order) {
            cell.configureActionButton(with: action, isHidden: false)
            cell.onActionButtonTap = { [weak self] in
                self?.presenter?.didTapActionButton(on: order, at: indexPath.row, in: .active)
            }
        } else {
            cell.configureActionButton(with: .complete, isHidden: true)
            cell.onActionButtonTap = nil
        }
        
        let shouldShowReview = presenter?.shouldShowReviewButton(for: order) ?? false
        cell.configureReviewButton(isHidden: !shouldShowReview)
        if shouldShowReview {
            cell.onReviewButtonTap = { [weak self] in
                self?.presenter?.didTapReviewButton(on: order)
            }
        } else {
            cell.onReviewButtonTap = nil
        }
        
        return cell
    }
}
