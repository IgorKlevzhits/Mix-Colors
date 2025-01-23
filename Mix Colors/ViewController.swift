import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    // MARK: - UI
    
    private var nameAppLabel = UILabel(text: NSLocalizedString("nameApp", comment: ""), size: 30)
    
    private var colorOneStackView = UIStackView(axis: .vertical)
    private lazy var colorOneLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorOneButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorOneButton = UIButton(color: .red)
    
    private var colorThreeStackView = UIStackView(axis: .vertical)
    private lazy var colorThreeLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorThreeButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorThreeButton = UIButton(color: .blue)
    
    private var plusLabel = UILabel(text: "+", size: 30)
    
    private var colorTwoStackView = UIStackView(axis: .vertical)
    private lazy var colorTwoLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorTwoButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorTwoButton = UIButton(color: .green)
    
    private var colorFourStackView = UIStackView(axis: .vertical)
    private lazy var colorFourLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorFourButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorFourButton = UIButton(color: .purple)
    
    private var equaleLabel = UILabel(text: "=", size: 30)
    
    private var colorResultStackView = UIStackView(axis: .vertical)
    private lazy var colorResultLabel = UILabel(text: Bundle.localizedString(forKey: closestColorName(to: colorResultButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil), size: 20)
    private var colorResultButton = UIButton(color: .red)
    
    private lazy var languageSegmentedControl: UISegmentedControl = {
        let element = UISegmentedControl(items: ["en", "ru"])
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var colorsStepper: UIStepper = {
        let element = UIStepper()
        element.minimumValue = 2
        element.maximumValue = 4
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private var constraintForColorOneStackView: CGFloat = 0
    private var constraintForColorTwoStackView: CGFloat = 0
    private var constraintForColorOneLandscapeStackView: CGFloat = -0.055
    private var constraintForColorTwoLandscapeStackView: CGFloat = 0.0625
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
        updateUIForCurrentTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustLayoutForCurrentOrientation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateUIForCurrentTheme()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // При изменении ориентации, обновляем интерфейс
        coordinator.animate(alongsideTransition: { _ in
            self.adjustLayoutForCurrentOrientation()
        }, completion: nil)
    }

    private func adjustLayoutForCurrentOrientation() {
        if UIDevice.current.orientation.isLandscape {
            setupConstraintsForLandscape()
        } else {
            setupConstraintsForPortrait()
        }
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
        updateResultColor()
        changedColorName()
    }
    
    private func updateResultColor() {
        if colorsStepper.value == 2 {
            colorResultButton.backgroundColor = colorOneButton.backgroundColor?.mix(with: [colorTwoButton.backgroundColor ?? .white])
        } else if colorsStepper.value == 3 {
            colorResultButton.backgroundColor = colorOneButton.backgroundColor?.mix(with: [colorTwoButton.backgroundColor ?? .white,
                                                                                           colorThreeButton.backgroundColor ?? .white
                                                                                          ])
        } else {
            colorResultButton.backgroundColor = colorOneButton.backgroundColor?.mix(with: [colorTwoButton.backgroundColor ?? .white,
                                                                                           colorThreeButton.backgroundColor ?? .white,
                                                                                           colorFourButton.backgroundColor ?? .white
                                                                                          ])
        }
    }
    
    private func changedColorName() {
        colorOneLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorOneButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorTwoLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorTwoButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorResultLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorResultButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorThreeLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorThreeButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
        colorFourLabel.text = Bundle.localizedString(forKey: closestColorName(to: colorFourButton.backgroundColor ?? .white) ?? "error", value: nil, table: nil)
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
                view.backgroundColor = .black
                nameAppLabel.textColor = .white
                colorOneLabel.textColor = .white
                colorTwoLabel.textColor = .white
                colorResultLabel.textColor = .white
                plusLabel.textColor = .white
                equaleLabel.textColor = .white
            } else {
                view.backgroundColor = .white
                nameAppLabel.textColor = .black
                colorOneLabel.textColor = .black
                colorTwoLabel.textColor = .black
                colorResultLabel.textColor = .black
                plusLabel.textColor = .black
                equaleLabel.textColor = .black
            }
        }
    
    @objc func changedCountsColors(sender: UIStepper) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            if UIDevice.current.orientation.isLandscape {
                if sender.value == 3 {
                    self.constraintForColorOneLandscapeStackView = 0
                    self.constraintForColorTwoLandscapeStackView = 0.0625
                    self.constraintForColorOneStackView = -0.2
                    self.constraintForColorTwoStackView = 0
                    
                    self.colorThreeStackView.alpha = 1
                    self.colorFourStackView.alpha = 0
                    
                    self.updateConstraintsForButtonsLandscape()
                    self.updateResultColor()
                    self.changedColorName()
                } else if sender.value == 4 {
                    self.constraintForColorOneLandscapeStackView = 0
                    self.constraintForColorTwoLandscapeStackView = 0
                    self.constraintForColorOneStackView = -0.2
                    self.constraintForColorTwoStackView = -0.2
                    
                    self.colorThreeStackView.alpha = 1
                    self.colorFourStackView.alpha = 1
                    
                    self.updateConstraintsForButtonsLandscape()
                    self.updateResultColor()
                    self.changedColorName()
                } else {
                    self.constraintForColorOneLandscapeStackView = -0.055
                    self.constraintForColorTwoLandscapeStackView = 0.0625
                    self.constraintForColorOneStackView = 0
                    self.constraintForColorTwoStackView = 0
                    
                    self.colorThreeStackView.alpha = 0
                    self.colorFourStackView.alpha = 0
                    
                    self.updateConstraintsForButtonsLandscape()
                    self.updateResultColor()
                    self.changedColorName()
                }
            } else {
                if sender.value == 3 {
                    self.constraintForColorOneStackView = -0.2
                    self.constraintForColorTwoStackView = 0
                    self.constraintForColorOneLandscapeStackView = 0
                    self.constraintForColorTwoLandscapeStackView = 0.0625
                    
                    self.colorThreeStackView.alpha = 1
                    self.colorFourStackView.alpha = 0
                    
                    self.updateConstraintsForButtons()
                    self.updateResultColor()
                    self.changedColorName()
                } else if sender.value == 4 {
                    self.constraintForColorOneStackView = -0.2
                    self.constraintForColorTwoStackView = -0.2
                    self.constraintForColorOneLandscapeStackView = 0
                    self.constraintForColorTwoLandscapeStackView = 0
                    
                    self.colorThreeStackView.alpha = 1
                    self.colorFourStackView.alpha = 1
                    
                    self.updateConstraintsForButtons()
                    self.updateResultColor()
                    self.changedColorName()
                } else {
                    self.constraintForColorOneStackView = 0
                    self.constraintForColorTwoStackView = 0
                    self.constraintForColorOneLandscapeStackView = -0.055
                    self.constraintForColorTwoLandscapeStackView = 0.0625
                    
                    self.colorThreeStackView.alpha = 0
                    self.colorFourStackView.alpha = 0
                    
                    self.updateConstraintsForButtons()
                    self.updateResultColor()
                    self.changedColorName()
                }
            }
            self.view.layoutIfNeeded()
        })
    }
    
    private func updateConstraintsForButtonsLandscape() {
        for constraint in self.view.constraints {
            if constraint.firstItem as? UIView == colorOneStackView && constraint.firstAttribute == .centerX {
                constraint.constant = view.safeAreaLayoutGuide.layoutFrame.width * (-0.375 - constraintForColorOneLandscapeStackView)
            }
            if constraint.firstItem as? UIView == colorTwoStackView && constraint.firstAttribute == .centerX {
                constraint.constant = view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorTwoLandscapeStackView
            }
        }
        self.view.setNeedsLayout()
    }

    private func updateConstraintsForButtons() {
        for constraint in self.view.constraints {
            if constraint.firstItem as? UIView == colorOneStackView && constraint.firstAttribute == .centerX {
                constraint.constant = view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorOneStackView
            }
            if constraint.firstItem as? UIView == colorTwoStackView && constraint.firstAttribute == .centerX {
                constraint.constant = view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorTwoStackView
            }
        }
        self.view.setNeedsLayout()
    }

    
}

extension ViewController {
    
    // MARK: - Set Views
    
    private func setViews() {
        
        colorOneButton.tag = 1
        colorTwoButton.tag = 2
        colorThreeButton.tag = 3
        colorFourButton.tag = 4
        
        view.addSubview(nameAppLabel)
        
        view.addSubview(colorOneStackView)
        colorOneStackView.addArrangedSubview(colorOneLabel)
        colorOneStackView.addArrangedSubview(colorOneButton)
        
        view.addSubview(colorThreeStackView)
        colorThreeStackView.addArrangedSubview(colorThreeLabel)
        colorThreeStackView.addArrangedSubview(colorThreeButton)
        
        view.addSubview(plusLabel)
        
        view.addSubview(colorTwoStackView)
        colorTwoStackView.addArrangedSubview(colorTwoLabel)
        colorTwoStackView.addArrangedSubview(colorTwoButton)
        
        view.addSubview(colorFourStackView)
        colorFourStackView.addArrangedSubview(colorFourLabel)
        colorFourStackView.addArrangedSubview(colorFourButton)
        
        view.addSubview(equaleLabel)
        
        view.addSubview(colorResultStackView)
        colorResultStackView.addArrangedSubview(colorResultLabel)
        colorResultStackView.addArrangedSubview(colorResultButton)
        
        view.addSubview(languageSegmentedControl)
        view.addSubview(colorsStepper)
        
        colorThreeStackView.alpha = 0
        colorFourStackView.alpha = 0
        
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        updateSegmentedControl(for: currentLanguage)
        
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged(_:)), for: .valueChanged)
        colorsStepper.addTarget(self, action: #selector(changedCountsColors), for: .valueChanged)
        
        colorOneButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        colorTwoButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        colorThreeButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        colorFourButton.addTarget(self, action: #selector(colorChanged), for: .touchUpInside)
        changedColorName()
        updateResultColor()
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraintsForPortrait() {
        
        deactivateConstraints()
        
        portraitConstraints = [
            nameAppLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameAppLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            colorTwoStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorTwoStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorTwoStackView),
            colorTwoButton.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            colorTwoButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            
            colorFourStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorFourStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  view.safeAreaLayoutGuide.layoutFrame.width * 0.2),
            colorFourButton.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            colorFourButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            
            colorOneStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: view.frame.height / -4),
            colorOneStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorOneStackView),
            colorOneButton.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            colorOneButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            
            colorThreeStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: view.frame.height / -4),
            colorThreeStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * 0.2),
            colorThreeButton.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            colorThreeButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            
            plusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / -8),
            plusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            equaleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 8),
            equaleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            colorResultStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: view.frame.height / 4),
            colorResultStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            colorResultButton.heightAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            colorResultButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.2),
            
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            languageSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            colorsStepper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            colorsStepper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(portraitConstraints)
    }
    
    private func setupConstraintsForLandscape() {
        
        deactivateConstraints()
        
        landscapeConstraints = [
            nameAppLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameAppLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            colorTwoStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorTwoStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * constraintForColorTwoLandscapeStackView),
            colorTwoButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            colorTwoButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
            colorFourStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorFourStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant:  view.safeAreaLayoutGuide.layoutFrame.width * 0.125),
            colorFourButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            colorFourButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
            colorOneStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorOneStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * (-0.375 - constraintForColorOneLandscapeStackView)),
            colorOneButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            colorOneButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
            colorThreeStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorThreeStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * -0.25),
            colorThreeButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            colorThreeButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
            plusLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            plusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * -0.125),
            
            equaleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            equaleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * 0.25),
            
            colorResultStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            colorResultStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.width * 0.375),
            colorResultButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            colorResultButton.widthAnchor.constraint(equalToConstant: view.frame.height * 0.2),
            
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            languageSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            colorsStepper.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            colorsStepper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(landscapeConstraints)
    }
    
    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
    }
}

