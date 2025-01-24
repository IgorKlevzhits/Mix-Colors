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
    func mix(with colors: [UIColor]) -> UIColor {
        var allColors = [self] + colors
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        for color in allColors {
            guard let components = color.cgColor.components, components.count >= 4 else {
                return self
            }
            
            r += components[0]
            g += components[1]
            b += components[2]
            a += components[3]
        }
        
        let count = CGFloat(allColors.count)
        r /= count
        g /= count
        b /= count
        a /= count
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

