//
//  TabsControl.swift


import Foundation
import UIKit

@objc protocol TabsControlDelegate: AnyObject {
    func tabsControl(_ tabsControl: TabsControl, didSelectTabAtIndex index: Int)
}

final class TabsControl: UIView {
    
    // MARK: -
    
    private var buttons: [UIButton] = []
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private var selectionIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: - Private Properties
    
    fileprivate var previewIndex: Int = 0
    
    fileprivate var selectedTabIndex: Int = 0 {
        didSet {
            delegate?.tabsControl(self, didSelectTabAtIndex: selectedTabIndex)
        }
    }
    
    // MARK: -
    
    init(titles: [String]) {
        super.init(frame: .zero)
        setupView(titles)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Обновляем путь маски при изменении размера
        let cornerRadii = CGSize(width: 20, height: 20)
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    // MARK: - Public Properties
    
    weak var delegate: TabsControlDelegate?
    
    var numberOfSegments: Int {
        return buttons.count
    }
    
    // MARK: - Public Functions
    
    func setSelectedTabIndex(_ index: Int, animated: Bool = true) {
        
        previewIndex = selectedTabIndex
        selectedTabIndex = index
        
        if animated {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateButtonColors()
                strongSelf.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Private

private extension TabsControl {
    
    func setupView(_ titles: [String]) {
        // Общая настройка фона и углов
        backgroundColor = .clear
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // закругляем верхние углы родительского view
        layer.borderColor = UIColor(hexString: "#0A9E03")!.cgColor
        layer.borderWidth = 1
        // Добавляем stack view и кнопки
        addSubviews([selectionIndicatorView, buttonsStackView])
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        // Добавляем кнопки
        titles.enumerated().forEach { index, title in
            let button = createButton(with: title, tag: index)
            
            if index == 0 {
                button.layer.cornerRadius = 20
                button.layer.maskedCorners = [.layerMinXMinYCorner]
            } else if index == titles.count - 1 {
                button.layer.cornerRadius = 20
                button.layer.maskedCorners = [.layerMaxXMinYCorner]
            }
            
            buttons.append(button)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    func updateButtonColors() {
       buttons.enumerated().forEach { index, button in
           if index == selectedTabIndex {
               let textColor = UIColor(hexString: "#FFFFFF")!
               button.setTitleColor(textColor, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
               button.backgroundColor = UIColor(hexString: "#58855E")!
           } else {
               let textColor = UIColor(hexString: "#58855E")!
               button.setTitleColor(textColor, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
               button.backgroundColor = .clear
           }
       }
    }

    @objc func buttonAction(_ button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else {
            return
        }
        setSelectedTabIndex(index, animated: true)
    }
    
    func createButton(with title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hexString: "#FFFFFF")!, for: .normal)
        button.isExclusiveTouch = true
        button.tag = tag
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
}
