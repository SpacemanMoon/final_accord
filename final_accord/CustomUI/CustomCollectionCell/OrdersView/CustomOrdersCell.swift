import UIKit

final class CustomOrdersCell: UITableViewCell {
    
    // MARK: - Private UIComponents
    
    private let containerView = UIView()
    private let masterNameLabel = UILabel()
    private let masterSpecializationLabel = UILabel()
    private let issueLabel = UILabel()
    private let dateLabel = UILabel()
    private let scheduledDateLabel = UILabel()
    private let statusLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let reviewButton = UIButton(type: .system)
    
    // MARK: - Properties
    
    static let reuseidentifier: String = "CustomOrdersCell"
    
    var onActionButtonTap: (() -> Void)?
    var onReviewButtonTap: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        masterNameLabel.textColor = .white
        masterNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        masterSpecializationLabel.textColor = .white.withAlphaComponent(0.7)
        masterSpecializationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        masterSpecializationLabel.isHidden = true
        
        issueLabel.textColor = .white.withAlphaComponent(0.8)
        issueLabel.font = .systemFont(ofSize: 14)
        issueLabel.numberOfLines = 2
        
        dateLabel.textColor = .white.withAlphaComponent(0.6)
        dateLabel.font = .systemFont(ofSize: 12)
        
        scheduledDateLabel.textColor = .white.withAlphaComponent(0.6)
        scheduledDateLabel.font = .systemFont(ofSize: 12)
        scheduledDateLabel.isHidden = true
        
        statusLabel.textColor = .systemGreen
        statusLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 8
        actionButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        reviewButton.setTitle("Оставить отзыв", for: .normal)
        reviewButton.setTitleColor(.white, for: .normal)
        reviewButton.layer.cornerRadius = 8
        reviewButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        reviewButton.isHidden = true
        reviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(containerView)
        containerView.addSubview(masterNameLabel)
        containerView.addSubview(masterSpecializationLabel)
        containerView.addSubview(issueLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(scheduledDateLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(reviewButton)
    }
    
    private func setupConstraints() {
        [containerView, masterNameLabel, masterSpecializationLabel,
         issueLabel, dateLabel, scheduledDateLabel, statusLabel,
         actionButton, reviewButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            masterNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            masterNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            masterSpecializationLabel.centerYAnchor.constraint(equalTo: masterNameLabel.centerYAnchor),
            masterSpecializationLabel.leadingAnchor.constraint(equalTo: masterNameLabel.trailingAnchor, constant: 4),
            masterSpecializationLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -8),
            
            statusLabel.centerYAnchor.constraint(equalTo: masterNameLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            issueLabel.topAnchor.constraint(equalTo: masterNameLabel.bottomAnchor, constant: 4),
            issueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            issueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: issueLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            scheduledDateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            scheduledDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            scheduledDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            actionButton.topAnchor.constraint(equalTo: scheduledDateLabel.bottomAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 30),
            
            reviewButton.topAnchor.constraint(equalTo: scheduledDateLabel.bottomAnchor, constant: 8),
            reviewButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            reviewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            reviewButton.widthAnchor.constraint(equalToConstant: 120),
            reviewButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func dateFromString(_ date: String, _ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: "\(date) \(time)")
    }
    
    // MARK: - Public Methods
    
    func configure(with order: OrderFirestore) {
        masterNameLabel.text = order.masterName
        
        if let specialization = order.specialization, !specialization.isEmpty {
            masterSpecializationLabel.text = "• \(specialization)"
            masterSpecializationLabel.isHidden = false
        } else {
            masterSpecializationLabel.isHidden = true
        }
        
        issueLabel.text = order.issueDescription
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = "Создан: \(formatter.string(from: order.dateTime))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateTimeString = "\(order.selectDate) \(order.selectTime)"
        
        if let scheduledDate = dateFormatter.date(from: dateTimeString) {
            scheduledDateLabel.text = "Выполнение: \(formatter.string(from: scheduledDate))"
            scheduledDateLabel.isHidden = false
        } else {
            scheduledDateLabel.isHidden = true
        }
        
        switch order.status {
        case .active:
            statusLabel.text = "Активен"
            statusLabel.textColor = .systemGreen
        case .completed:
            statusLabel.text = "Завершен"
            statusLabel.textColor = .systemBlue
        case .cancelled:
            statusLabel.text = "Отменен"
            statusLabel.textColor = .systemRed
        }
    }
    
    func configureActionButton(with action: OrderAction, isHidden: Bool) {
        actionButton.setTitle(action.title, for: .normal)
        actionButton.isHidden = isHidden
        
        switch action {
        case .complete:
            actionButton.backgroundColor = .systemGreen
        case .cancel:
            actionButton.backgroundColor = .systemRed
        }
    }
    
    func configureReviewButton(isHidden: Bool) {
        reviewButton.isHidden = isHidden
    }
    
    // MARK: - Actions
    
    @objc private func actionButtonTapped() {
        onActionButtonTap?()
    }
    
    @objc private func reviewButtonTapped() {
        onReviewButtonTap?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        masterNameLabel.text = nil
        masterSpecializationLabel.text = nil
        issueLabel.text = nil
        dateLabel.text = nil
        scheduledDateLabel.text = nil
        statusLabel.text = nil
        
        masterSpecializationLabel.isHidden = true
        scheduledDateLabel.isHidden = true
        reviewButton.isHidden = true
        
        actionButton.isHidden = false
        actionButton.backgroundColor = .systemRed
        actionButton.setTitle(nil, for: .normal)
        
        onActionButtonTap = nil
        onReviewButtonTap = nil
    }
}
