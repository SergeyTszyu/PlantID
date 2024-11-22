//
//  OnboardingFirstViewController.swift
//  PlantID

import UIKit
import SwiftUI

final class OnboardingFirstViewController: BaseViewController {
    
    // MARK: -
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "onboardingFirst")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hexString: "#000000")!.withAlphaComponent(0).cgColor,
            UIColor(hexString: "#10271A")!.withAlphaComponent(0.7).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0) // Начало сверху
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Конец снизу
        return layer
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.whiteColor
        label.font = Fonts.bold.addFont(35)
        label.textAlignment = .center
        label.text = "Identify plant"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.whiteColor
        label.font = Fonts.medium.addFont(18)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Discover how to identify and care for \nplants from all over the world"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Get Started!")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        return button
    }()
    
    private func addGradient() {
        gradientLayer.frame = backgroundImageView.bounds
        backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    private lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let restoreButton = createBottomButton(withTitle: "Restore Purchases", action: #selector(restoreTapped))
        let privacyButton = createBottomButton(withTitle: "Terms of Use", action: #selector(privacyTapped))
        let termsButton = createBottomButton(withTitle: "Privacy Policy", action: #selector(termsTapped))

        stackView.addArrangedSubview(termsButton)
        stackView.addArrangedSubview(restoreButton)
        stackView.addArrangedSubview(privacyButton)

        return stackView
    }()
    
    // MARK: - Properties
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundImageView.bounds
        Theme.buttonStyle(continueButton, title: "Get Started!")
    }
    
    @objc private func restoreTapped() {
        
    }
    
    @objc private func privacyTapped() {
        openURL(Url.privacy.rawValue)
    }
    
    @objc private func termsTapped() {
        openURL(Url.terms.rawValue)
    }

}

private extension OnboardingFirstViewController {
    
    func configure() {
        setupHierarchy()
        setupConstraints()
        addGradient()
    }
    
    func setupHierarchy() {
        view.addSubviews([backgroundImageView,
                          titleLabel,
                          subtitleLabel,
                          continueButton,
                          bottomButtonsStackView])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor, constant: -80),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -4),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            subtitleLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -56),
        ])
    }
    
    @objc func continuePressed() {
        self.delegateRouting?.routeToPreparing()
    }
    
    @objc func skipPressed() {
        self.delegateRouting?.routeToTrialView()
    }
    
    func createBottomButton(withTitle title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor(hexString: "#CFCFCF"), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
