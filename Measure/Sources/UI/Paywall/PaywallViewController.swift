import UIKit
import ApphudSDK
import AlertKit
import Combine
import ApphudSDK


final class PaywallViewController: BaseViewController {

    // MARK: - UI Elements
    
    private let myTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(hexString: "#1D3C2B")
        label.textAlignment = .center
        label.text = "Choose Your Plan!"
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(hexString: "#A6ADB3")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "All the following options include unlimited \naccess"
        return label
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Close")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        button.tintColor = UIColor(hexString: "#0A9E03")
        return button
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Try 3 day for Free!")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        return button
    }()
    
    private var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Paywall-Top")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var annuallyButton: CustomButton = {
        let button = CustomButton()
        button.configure(topText: "Bill annually ", price: PremiumManager.shared.annuallyPrice, periodText: "Bill annually", isChosen: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isLarge = true
        button.orangeImageView.isHidden = false
        button.addBottomText()
        button.addTarget(self, action: #selector(annuallyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var weeklyButton: CustomButton = {
        let button = CustomButton()
        button.configure(topText: "Bill weekly  ", price: PremiumManager.shared.weeklyPrice, periodText: "week", isChosen: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.orangeImageView.isHidden = true
        button.addBottomText()
        button.addTarget(self, action: #selector(weeklyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
//        skipButton.isHidden = true
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showCloseButton), userInfo: nil, repeats: false)
        
        PremiumManager.shared.$weeklyPrice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPrice in
                self?.updatePriceButtons()
            }
            .store(in: &cancellables)

        PremiumManager.shared.$annuallyPrice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPrice in
                self?.updatePriceButtons()
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Theme.buttonStyle(continueButton, title: "Try 3 day for Free!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func updatePriceButtons() {
        weeklyButton.configure(topText: "Bill weekly", price: PremiumManager.shared.weeklyPrice, periodText: "week", isChosen: false)
        annuallyButton.configure(topText: "Bill annually", price: PremiumManager.shared.annuallyPrice, periodText: "year", isChosen: true)
    }
    
    @objc func skipPressed() {
        closeAction()
    }
    
    func closeAction() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            MainCoordinator(navigationController: self.navigationController!).start()
        }
    }
    
    @objc private func showCloseButton() {
        skipButton.isHidden = false
        skipButton.setImage(UIImage(named: "Close")!, for: .normal)
    }
    
    private func setupLayout() {
        view.addSubview(myTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(backgroundImageView)
        view.addSubview(skipButton)
        view.addSubview(weeklyButton)
        view.addSubview(annuallyButton)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            skipButton.heightAnchor.constraint(equalToConstant: 38),
            skipButton.widthAnchor.constraint(equalToConstant: 36),
            
            myTitleLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 22),
            myTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subTitleLabel.topAnchor.constraint(equalTo: myTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            backgroundImageView.bottomAnchor.constraint(equalTo: annuallyButton.topAnchor, constant: -16),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 338),
            
            annuallyButton.bottomAnchor.constraint(equalTo: weeklyButton.topAnchor, constant: -18),
            annuallyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            annuallyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            annuallyButton.heightAnchor.constraint(equalToConstant: 100),
            
            weeklyButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -32),
            weeklyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            weeklyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            weeklyButton.heightAnchor.constraint(equalToConstant: 80),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func createBottomButton(withTitle title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.setTitleColor(UIColor(hexString: "#8F9A8C"), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Button Actions

    @objc private func weeklyButtonTapped() {
        selectButton(weeklyButton)
    }

    @objc private func annuallyButtonTapped() {
        selectButton(annuallyButton)
    }
    
    @objc private func restoreTapped() {
        Apphud.restorePurchases { subscriptions, purchase, error in
            if Apphud.hasActiveSubscription() {
                AlertKitAPI.present(
                    title: "Restore successful",
                    style: .iOS17AppleMusic,
                    haptic: .success
                )
            }
        }
    }
    
    @objc private func privacyTapped() {
        openURL(Url.privacy.rawValue)
    }
    
    @objc private func termsTapped() {
        openURL(Url.terms.rawValue)
    }

    private func selectButton(_ selectedButton: CustomButton) {
        weeklyButton.isChoosen = false
        annuallyButton.isChoosen = false
        
        selectedButton.isChoosen = true
    }
    
    @objc private func buyTapped() {
        if weeklyButton.isChoosen {
            if let product = PremiumManager.weeklyProduct {
                Apphud.purchase(product) { [self] result in
                    if result.success {
                        closeAction()
                    }
                }
            }
        } else if annuallyButton.isChoosen {
            if let product = PremiumManager.annuallyProduct {
                Apphud.purchase(product) { [self] result in
                    if result.success {
                        closeAction()
                    }
                }
            }
        }
    }
}
