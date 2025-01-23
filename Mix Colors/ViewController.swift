import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    // MARK: - UI
    
    private var nameAppLabel = UILabel(text: NSLocalizedString("nameApp", comment: ""), size: 30)
    
    private var colorOneStackView = UIStackView(axis: .vertical)
    private lazy var colorOneLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorOneButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorOneButton = UIButton(color: .red)
    
    private var plusLabel = UILabel(text: "+", size: 30)
    
    private var colorTwoStackView = UIStackView(axis: .vertical)
    private lazy var colorTwoLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorTwoButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorTwoButton = UIButton(color: .red)
    
    private var equaleLabel = UILabel(text: "=", size: 30)
    
    private var colorResultStackView = UIStackView(axis: .vertical)
    private lazy var colorResultLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorResultButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorResultButton = UIButton(color: .red)
    
    private lazy var languageSegmentedControl: UISegmentedControl = {
        let element = UISegmentedControl(items: ["en", "ru"])
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
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
        updateUIForCurrentTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateUIForCurrentTheme()
        }
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
        if let sender = self.view.viewWithTag(viewController.view.tag == 1 ? 2 : 1) as? UIButton {
            colorResultButton.backgroundColor = viewController.selectedColor.mix(with: sender.backgroundColor ?? .white)
        }
        changedColorName()
    }
    
    private func changedColorName() {
        colorOneLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorOneButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorTwoLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorTwoButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorResultLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorResultButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
    }
    
    func closestColorName(to color: UIColor) -> String? {
        let colorNames: [String: UIColor] = [
            "colorRed": .red,
            "colorGreen": .green,
            "colorBlue": .blue,
            "colorYellow": .yellow,
            "colorOrange": .orange,
            "colorPurple": .purple,
            "colorBrown": .brown,
            "colorGray": .gray,
            "colorBlack": .black,
            "colorWhite": .white
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
    
    @objc func languageChanged(_ sender: UISegmentedControl) {
        let selectedLanguage: String

        switch sender.selectedSegmentIndex {
        case 0:
            selectedLanguage = "en"
        case 1:
            selectedLanguage = "ru"
        default:
            selectedLanguage = "en"
        }

        setLanguage(selectedLanguage)
    }

    func setLanguage(_ language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        Bundle.setLanguage(language)
        updateUIForCurrentLanguage()
    }
    
    func updateUIForCurrentLanguage() {
        nameAppLabel.text = Bundle.localizedString(forKey: "nameApp", value: nil, table: nil)
        changedColorName()
        
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        updateSegmentedControl(for: currentLanguage)
    }
    
    func updateSegmentedControl(for language: String) {
        if language == "ru" {
            languageSegmentedControl.selectedSegmentIndex = 1
        } else {
            languageSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
    private func updateUIForCurrentTheme() {
            if traitCollection.userInterfaceStyle == .dark {
                // Для темной темы
                view.backgroundColor = .black
                nameAppLabel.textColor = .white
                colorOneLabel.textColor = .white
                colorTwoLabel.textColor = .white
                colorResultLabel.textColor = .white
                plusLabel.textColor = .white
                equaleLabel.textColor = .white
            } else {
                // Для светлой темы
                view.backgroundColor = .white
                nameAppLabel.textColor = .black
                colorOneLabel.textColor = .black
                colorTwoLabel.textColor = .black
                colorResultLabel.textColor = .black
                plusLabel.textColor = .black
                equaleLabel.textColor = .black
            }
        }
    
}

extension ViewController {
    
    // MARK: - Set Views
    
    private func setViews() {
        
        colorOneButton.tag = 1
        colorTwoButton.tag = 2
        
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
        
        view.addSubview(languageSegmentedControl)
        
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        updateSegmentedControl(for: currentLanguage)
        
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged(_:)), for: .valueChanged)
        
        
        colorOneButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        colorTwoButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        changedColorName()
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
            colorResultButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            languageSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
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
            colorResultButton.widthAnchor.constraint(equalToConstant: sizeButtons),
            
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            languageSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
    }
}

