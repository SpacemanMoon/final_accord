import UIKit

final class CustomView: UIView {
    
    // MARK: - Types
    
    enum ViewType {
        case card
        case rounded
        case circle
        case bordered
        case clear
        
        var cornerRadius: CGFloat {
            switch self {
            case .card: return 16
            case .rounded: return 12
            case .circle: return 999
            case .bordered: return 8
            case .clear: return 0
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .card: return .secondarySystemBackground
            case .rounded: return .systemBackground
            case .circle: return .systemBlue
            case .bordered: return .clear
            case .clear: return .clear
            }
        }
        
        var hasShadow: Bool {
            switch self {
            case .card: return true
            default: return false
            }
        }
        
        var hasBorder: Bool {
            switch self {
            case .bordered: return true
            default: return false
            }
        }
    }
    
    // MARK: - Properties
    
    private var type: ViewType = .clear
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: ViewType = .clear) {
        self.init(frame: .zero)
        self.type = type
        applySettings()
    }
    
    convenience init(color: UIColor, cornerRadius: CGFloat = 0) {
        self.init(frame: .zero)
        self.type = .clear
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if type == .circle {
            layer.cornerRadius = bounds.width / 2
        }
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applySettings() {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = type.cornerRadius
        
        if type.hasShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 8
        }
        
        if type.hasBorder {
            layer.borderColor = UIColor.separator.cgColor
            layer.borderWidth = 1
        }
        
        if type == .clear {
            backgroundColor = .clear
        }
    }
}
