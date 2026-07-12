import UIKit

final class PickerTextField: UITextField {
    
    // MARK: - Private Properties
    
    private let pickerView = UIPickerView()
    
    // MARK: - Properties
    
    var items: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    var onSelect: ((String) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        inputView = pickerView
        inputAccessoryView = nil
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension PickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < items.count else { return }
        text = items[row]
        onSelect?(items[row])
    }
}
