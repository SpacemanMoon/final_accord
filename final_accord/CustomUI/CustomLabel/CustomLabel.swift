import UIKit

final class CustomLabel: UILabel {
    
    // MARK: - Types
    
    enum LabelType {
        case title
        case heading
        case body
        case caption
        case error
        
        var fontSize: CGFloat {
            switch self {
            case .title: return 28
            case .heading: return 19
            case .body: return 16
            case .caption: return 12
            case .error: return 14
            }
        }
        
        var fontWeight: UIFont.Weight {
            switch self {
            case .title: return .bold
            case .heading: return .semibold
            case .body: return .regular
            case .caption: return .regular
            case .error: return .medium
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .error: return .systemRed
            default: return .label
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
    
    convenience init(text: String? = nil, type: LabelType = .body) {
        self.init(frame: .zero)
        self.text = text
        font = UIFont.systemFont(ofSize: type.fontSize, weight: type.fontWeight)
        textColor = .white
    }
    
    convenience init(text: String? = nil, size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .label) {
        self.init(frame: .zero)
        self.text = text
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textColor = color
    }
    
    // MARK: - Private Methods
    
    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
}
