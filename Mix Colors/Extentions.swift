import UIKit

extension Bundle {
    private static var bundle: Bundle?

    class func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return }
        
        self.bundle = bundle
    }
    
    class func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = self.bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return Bundle.main.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension UILabel {
    convenience init(text: String, size: CGFloat) {
        self.init()
        self.text = text
        self.textAlignment = .center
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.font = .systemFont(ofSize: size)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIButton {
    convenience init(color: UIColor) {
        self.init(type: .system)
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false

    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
        self.spacing = 10
        self.translatesAutoresizingMaskIntoConstraints = false

    }
}

extension UIColor {
    func mix(with color: UIColor) -> UIColor {
        
        let componentsColorOne = self.cgColor.components ?? [0, 0, 0, 0]
        let componentsColorTwo = color.cgColor.components ?? [0, 0, 0, 0]
        
        let r = componentsColorOne[0] + (componentsColorTwo[0] - componentsColorOne[0]) * 0.5
        let g = componentsColorOne[1] + (componentsColorTwo[1] - componentsColorOne[1]) * 0.5
        let b = componentsColorOne[2] + (componentsColorTwo[2] - componentsColorOne[2]) * 0.5
        let a = componentsColorOne[3] + (componentsColorTwo[3] - componentsColorOne[3]) * 0.5
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
