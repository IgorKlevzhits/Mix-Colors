import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    // MARK: - UI
    
    private var nameAppLabel = UILabel(text: "Mix Colors", size: 30)
    
    private var colorOneStackView = UIStackView(axis: .vertical)
    private var colorOneLabel = UILabel(text: "Red", size: 20)
    private var colorOneButton = UIButton(color: .red)
    
    private var plusLabel = UILabel(text: "+", size: 30)
    
    private var colorTwoStackView = UIStackView(axis: .vertical)
    private var colorTwoLabel = UILabel(text: "Red", size: 20)
    private var colorTwoButton = UIButton(color: .red)
    
    private var equaleLabel = UILabel(text: "=", size: 30)
    
    private var colorResultStackView = UIStackView(axis: .vertical)
    private var colorResultLabel = UILabel(text: "Red", size: 20)
    private var colorResultButton = UIButton(color: .red)
    
    // MARK: - Private Properties
    
    private lazy var sizeButtons: CGFloat = 100
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    private enum ColorButtons {
        case colorOneButton
        case colorTwoButton
        case colorResultButton
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraintsForPortrait()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.layoutIfNeeded()
        coordinator.animate(alongsideTransition: { _ in
            if UIDevice.current.orientation.isLandscape {
                self.updateConstraintsForLandscape()
            } else {
                self.updateConstraintsForPortrait()
            }
            
        }, completion: nil)
    }
    func updateConstraintsForLandscape() {
        setupConstraintsForLandscape()
    }
    func updateConstraintsForPortrait() {
        setupConstraintsForPortrait()
    }
    
    // MARK: - Methods
    
    @objc private func colorChanged(sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.selectedColor = sender.backgroundColor ?? .white
        colorPickerVC.delegate = self
        colorPickerVC.modalPresentationStyle = .popover
        colorPickerVC.view.tag = sender.tag
        present(colorPickerVC, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        if let sender = self.view.viewWithTag(viewController.view.tag) as? UIButton {
            sender.backgroundColor = viewController.selectedColor
        }
        // Если нужно изменить только одну кнопку (например, colorOneButton):
        // colorOneButton.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if let sender = self.view.viewWithTag(viewController.view.tag == 1 ? 2 : 1) as? UIButton {
            colorResultButton.backgroundColor = viewController.selectedColor.mix(with: sender.backgroundColor ?? .white)
        }
        colorOneLabel.text = closestColorName(to: colorOneButton.backgroundColor ?? .white)
        colorTwoLabel.text = closestColorName(to: colorTwoButton.backgroundColor ?? .white)
        colorResultLabel.text = closestColorName(to: colorResultButton.backgroundColor ?? .white)
    }

    func closestColorName(to color: UIColor) -> String? {
        let colorNames: [String: UIColor] = [
            "Red": .red,
            "Green": .green,
            "Blue": .blue,
            "Yellow": .yellow,
            "Orange": .orange,
            "Purple": .purple,
            "Brown": .brown,
            "Gray": .gray,
            "Black": .black,
            "White": .white
        ]
        
        var closestName: String?
        var smallestDistance: CGFloat = .greatestFiniteMagnitude
        
        for (name, namedColor) in colorNames {
            let distance = colorDistance(from: color, to: namedColor)
            if distance < smallestDistance {
                smallestDistance = distance
                closestName = name
            }
        }
        
        return closestName
    }

    func colorDistance(from color1: UIColor, to color2: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let redDiff = r1 - r2
        let greenDiff = g1 - g2
        let blueDiff = b1 - b2
        
        return sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)
    }

    
}

extension ViewController {
    
    // MARK: - Set Views
    
    private func setViews() {
        
        colorOneButton.tag = 1
        colorTwoButton.tag = 2
        
        view.backgroundColor = .white
        
        view.addSubview(nameAppLabel)
        
        view.addSubview(colorOneStackView)
        colorOneStackView.addArrangedSubview(colorOneLabel)
        colorOneStackView.addArrangedSubview(colorOneButton)
        
        view.addSubview(plusLabel)
        
        view.addSubview(colorTwoStackView)
        colorTwoStackView.addArrangedSubview(colorTwoLabel)
        colorTwoStackView.addArrangedSubview(colorTwoButton)
        
        view.addSubview(equaleLabel)
        
        view.addSubview(colorResultStackView)
        colorResultStackView.addArrangedSubview(colorResultLabel)
        colorResultStackView.addArrangedSubview(colorResultButton)
        
        colorOneButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        colorTwoButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
    }
    
    // MARK: - Setup Constraints

    private func setupConstraintsForPortrait() {
        
        deactivateConstraints()
        
        portraitConstraints = [
            nameAppLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameAppLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            colorTwoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorTwoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorTwoButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorTwoButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            colorOneStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / -4),
            colorOneStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorOneButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorOneButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            plusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / -8),
            plusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            equaleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 8),
            equaleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorResultStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 4),
            colorResultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorResultButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorResultButton.widthAnchor.constraint(equalToConstant: sizeButtons)
        ]
        NSLayoutConstraint.activate(portraitConstraints)
    }

    private func setupConstraintsForLandscape() {
        
        deactivateConstraints()
        
        landscapeConstraints = [
            nameAppLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameAppLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            colorTwoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorTwoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorTwoButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorTwoButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            colorOneStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorOneStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.height / -2),
            colorOneButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorOneButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            plusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.height / -4),
            
            equaleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            equaleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.height / 4),
            
            colorResultStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorResultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.height / 2),
            colorResultButton.heightAnchor.constraint(equalToConstant: sizeButtons),
            colorResultButton.widthAnchor.constraint(equalToConstant: sizeButtons)
        ]
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
    }
}

extension UILabel {
    convenience init(text: String, size: CGFloat) {
        self.init()
        self.text = text
        self.textAlignment = .center
        self.numberOfLines = 0
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
        // Извлекаем компоненты цвета (красный, зеленый, синий, альфа)
        let components1 = self.cgColor.components ?? [0, 0, 0, 0]
        let components2 = color.cgColor.components ?? [0, 0, 0, 0]
        
        // Смешиваем компоненты (по каналам)
        let r = components1[0] + (components2[0] - components1[0]) * 0.5
        let g = components1[1] + (components2[1] - components1[1]) * 0.5
        let b = components1[2] + (components2[2] - components1[2]) * 0.5
        let a = components1[3] + (components2[3] - components1[3]) * 0.5
        
        // Возвращаем смешанный цвет
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
