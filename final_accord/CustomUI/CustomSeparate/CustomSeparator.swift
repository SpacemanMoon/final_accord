import UIKit

final class CustomSeparator: UIView {
    
    // MARK: - Types
    
    enum SeparatorType {
        case horizontal
        case vertical
        
        var isHorizontal: Bool {
            switch self {
            case .horizontal: return true
            case .vertical: return false
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: SeparatorType = .horizontal, color: UIColor = .separator, thickness: CGFloat = 1) {
        self.init(frame: .zero)
        backgroundColor = color
        
        if type.isHorizontal {
            heightAnchor.constraint(equalToConstant: thickness).isActive = true
        } else {
            widthAnchor.constraint(equalToConstant: thickness).isActive = true
        }
    }
    
    convenience init(leading: CGFloat = 16, trailing: CGFloat = 16, color: UIColor = .separator, thickness: CGFloat = 1) {
        self.init(frame: .zero)
        backgroundColor = color
        heightAnchor.constraint(equalToConstant: thickness).isActive = true
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .separator
    }
}
