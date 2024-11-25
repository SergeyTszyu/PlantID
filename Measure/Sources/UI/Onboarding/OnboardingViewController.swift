//
//  OnboardingViewController.swift

import UIKit
import StoreKit
import SwiftUI

import UIKit

final class OnboardingViewController: BaseViewController, UIPageViewControllerDelegate {
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?
    private var continueButtonTrailingConstraint: NSLayoutConstraint?
    private var continueButtonWidthConstraint: NSLayoutConstraint?
    
    @AppStorage("isLaunchedBefore") var isLaunchedBefore = false

    // MARK: - UI Elements
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        
        for view in pageVC.view.subviews {
            if let subview = view as? UIScrollView {
                subview.isScrollEnabled = false
            }
        }
        return pageVC
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Next")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        
        stackView.addArrangedSubview(restoreButton)
        stackView.addArrangedSubview(termsButton)
        stackView.addArrangedSubview(privacyButton)
        
        return stackView
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor((UIColor(hexString: "#A6ADB3")), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        button.tintColor = UIColor(hexString: "#404A3E")
        return button
    }()
    
    @objc private func skipPressed() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first else {
             return
         }
         
         let paywallViewController = PaywallViewController()
        
         window.rootViewController = UINavigationController(rootViewController: paywallViewController)
         UIView.transition(with: window,
                           duration: 0.6,
                           options: .transitionCrossDissolve,
                           animations: nil)
    }
    
    private var pages: [UIViewController] = []
    private var currentIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageViewController()
        setupContinueButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if currentIndex == pages.count - 1 {
            continueButton.isHidden = true
            bottomButtonsStackView.isHidden = true
            skipButton.isHidden = true
        } else {
            Theme.buttonStyle(continueButton, title: "Next")
        }
    }
    
    private func setupPages() {
        let page1 = Onboarding1ViewController()
        let page2 = Onboarding2ViewController()
        let page3 = OnboardingReviewViewController()
        let page4 = PaywallViewController()
        
        pages = [page1, page2, page3, page4]
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        guard let firstPage = pages.first else { return }
        pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(bottomButtonsStackView)
        view.addSubview(skipButton)
    }
    
    private func setupContinueButton() {
        view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            skipButton.heightAnchor.constraint(equalToConstant: 38)
        ])

        if currentIndex == 0 {
            continueButtonTrailingConstraint = continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)

            NSLayoutConstraint.activate([
                continueButtonTrailingConstraint!,
                continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -154),
                continueButton.widthAnchor.constraint(equalToConstant: 172),
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else if currentIndex == 1 { // Для второго индекса
            continueButtonWidthConstraint = continueButton.widthAnchor.constraint(equalToConstant: 172)
            // Убираем trailingAnchor
            if let trailingConstraint = continueButtonTrailingConstraint {
                NSLayoutConstraint.deactivate([trailingConstraint])
            }
            // Применяем only leadingAnchor для выравнивания кнопки
            NSLayoutConstraint.activate([
                continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -154),
                continueButtonWidthConstraint!,
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            if let trailingConstraint = continueButtonTrailingConstraint {
                NSLayoutConstraint.deactivate([continueButtonWidthConstraint!])
            }
            NSLayoutConstraint.activate([
                continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
        }
    }
    
    func createBottomButton(withTitle title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(UIColor(hexString: "#1D3C2B"), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func restoreTapped() {
        
    }
    
    @objc private func privacyTapped() {
        openURL(Url.privacy.rawValue)
    }
    
    @objc private func termsTapped() {
        openURL(Url.terms.rawValue)
    }

    // MARK: - Actions
    
    @objc private func continueButtonTapped() {
        guard currentIndex < pages.count - 1 else { // Проверка, что не выходим за пределы
            delegateRouting?.routeToMainView()
            return
        }
        self.isLaunchedBefore = true
        currentIndex += 1
        
        let nextPage = pages[currentIndex]
        pageViewController.setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
        
        if nextPage is OnboardingReviewViewController {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                DispatchQueue.main.async {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
         }
        
        setupContinueButton()
    }

}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
