//
//  OnboardingReviewViewController.swift
//  PlantID

import UIKit

struct Review {
    var image: UIImage
}

final class OnboardingReviewViewController: BaseViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Elements

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .zero
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = UIColor(hexString: "#1D3C2B")
        label.textAlignment = .center
        label.text = "What users think"
        return label
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#CFCFCF")
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#FE8331")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(hexString: "#838D87")
        label.text = "Trusted by users for real impact and \npositive results daily."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let reviews = [Review(image: UIImage(named: "Review1")!),
                           Review(image: UIImage(named: "Review2")!),
                           Review(image: UIImage(named: "Review3")!),
                           Review(image: UIImage(named: "Review4")!)]
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
    
    @objc func skipPressed() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first else {
             return
         }
         
         let paywallViewController = PaywallViewController()
         window.rootViewController = UINavigationController(rootViewController: paywallViewController)
         UIView.transition(with: window,
                           duration: 0.5,
                           options: .transitionCrossDissolve,
                           animations: nil)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 132),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 248),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 54),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 316)
    }
}

extension OnboardingReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.item]
        cell.fill(review)
        return cell
    }
}

class ReviewCollectionViewCell: UICollectionViewCell {
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        reviewLabel.text = text
    }
}

extension OnboardingReviewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
