import UIKit

final class CustomButton: UIButton {

    // MARK: - UI Elements

    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    private let justLabel = UILabel()
    private let discountLabel = UILabel()
    private let checkBoxImageView = UIImageView()
    let orangeImageView = UIImageView()
    
    var isLarge: Bool = false
    
    // Свойство для определения, выбрана ли кнопка
    var isChoosen: Bool = false {
        didSet {
            updateCheckBoxState()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .white
        
        topLabel.textAlignment = .left
        topLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        topLabel.textColor = UIColor(hexString: "#1D3C2B")

        bottomLabel.textAlignment = .left
        bottomLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bottomLabel.textColor = UIColor.red
        
        justLabel.textAlignment = .left
        justLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        justLabel.textColor = UIColor(hexString: "#838D87")
        justLabel.text = "just $4,15/month"
        
        discountLabel.textAlignment = .left
        discountLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        discountLabel.textColor = UIColor(hexString: "#FFFFFF")
        discountLabel.text = "Save 66%"
        
        checkBoxImageView.contentMode = .scaleAspectFit

        // Добавляем элементы на кнопку
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(checkBoxImageView)
        addSubview(orangeImageView)
        addSubview(justLabel)
        addSubview(discountLabel)
        
        // Устанавливаем Auto Layout для элементов
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        orangeImageView.translatesAutoresizingMaskIntoConstraints = false
        justLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        orangeImageView.image = UIImage(named: "Paywall-Orange")!
        
        NSLayoutConstraint.activate([
            // TopLabel сверху, левая часть
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkBoxImageView.leadingAnchor, constant: -8),

            // BottomLabel снизу, левая часть
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 4),
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkBoxImageView.leadingAnchor, constant: -8),
//            bottomLabel.bottomAnchor.constraint(equalTo: justLabel.topAnchor, constant: -16),

            // CheckBox справа по центру вертикали
            checkBoxImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBoxImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            orangeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            orangeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            orangeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            orangeImageView.widthAnchor.constraint(equalToConstant: 160),
        ])

        // Настраиваем начальное состояние чекбокса
        updateCheckBoxState()
    }

    // MARK: - Public Methods

    func configure(topText: String, price: String, periodText: String, isChosen: Bool) {
        topLabel.text = topText
        
        let attributedText = createAttributedString(price: price, periodText: periodText)
        bottomLabel.attributedText = attributedText
        
        self.isChoosen = isChosen
    }

    // MARK: - Private Methods

    private func createAttributedString(price: String, periodText: String) -> NSAttributedString {
        let fullText = NSMutableAttributedString()
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .heavy),
            .foregroundColor: UIColor(hexString: "#F6E650")!
        ]
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .heavy),
            .foregroundColor: UIColor(hexString: "#F6E650")!
        ]
        
        let priceText = NSAttributedString(string: price, attributes: priceAttributes)
        fullText.append(priceText)
        
        let period = NSAttributedString(string: " per \(periodText)", attributes: regularAttributes)
        fullText.append(period)
        
        return fullText
    }
    
    func addBottomText() {
        if isLarge {
            NSLayoutConstraint.activate([
                justLabel.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 4),
                justLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                justLabel.heightAnchor.constraint(equalToConstant: 16),
                
                discountLabel.trailingAnchor.constraint(equalTo: orangeImageView.trailingAnchor, constant: -16),
                discountLabel.centerYAnchor.constraint(equalTo: orangeImageView.centerYAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                justLabel.heightAnchor.constraint(equalToConstant: 0)
            ])
        }
    }
    
    // Обновляем изображение чекбокса и обводку в зависимости от выбранного состояния
    private func updateCheckBoxState() {

        // Устанавливаем обводку в зависимости от состояния кнопки
        if isChoosen {
            layer.borderColor = UIColor(hexString: "#D4D7C9")?.cgColor // Обводка активной кнопки
            layer.borderWidth = 1.0
        } else {
            layer.borderColor = UIColor(hexString: "#8F9A8C")?.withAlphaComponent(0.1).cgColor // Обводка неактивной кнопки
            layer.borderWidth = 1.0
        }
    }
}
