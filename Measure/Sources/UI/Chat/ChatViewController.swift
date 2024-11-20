import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let messageInputContainer = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    // MARK: - Data Model
    var messages: [(String, Bool)] = [
        ("Hi! How can I help you?", true)
    ]
    
    // MARK: - OpenAI API Key
    private let openAIKey = "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"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardNotifications()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        // Вычисляем реальную высоту клавиатуры, учитывая высоту таб-бара
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let adjustedKeyboardHeight = keyboardFrame.height - tabBarHeight
        
        UIView.animate(withDuration: duration) {
            self.messageInputContainer.transform = CGAffineTransform(translationX: 0, y: -adjustedKeyboardHeight)
            self.tableView.contentInset.bottom = adjustedKeyboardHeight
            self.scrollToBottom()
        }
    }

    @objc private func handleKeyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            self.messageInputContainer.transform = .identity
            self.tableView.contentInset.bottom = 0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        // Message input container setup
        messageInputContainer.backgroundColor = .clear
        view.addSubview(messageInputContainer)
        
        // TextField setup
//        messageTextField.placeholder = "Type a message..."
//        messageTextField.borderStyle = .roundedRect
//        messageTextField.backgroundColor = UIColor(hexString: "#CFCFCF")?.withAlphaComponent(0.5)
//        messageTextField.layer.cornerRadius = 25
//        messageTextField.clipsToBounds = true
//        messageTextField.delegate = self
//        messageInputContainer.addSubview(messageTextField)
//
        
        // TextField setup
        messageTextField.placeholder = "Type a message..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.backgroundColor = UIColor(hexString: "#CFCFCF")?.withAlphaComponent(0.5)
        messageTextField.layer.cornerRadius = 25
        messageTextField.clipsToBounds = true
        messageTextField.delegate = self

        // Add padding to the left
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        messageTextField.leftView = paddingView
        messageTextField.leftViewMode = .always

        messageInputContainer.addSubview(messageTextField)
        
        // Send Button setup
        sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendButton.backgroundColor = UIColor(hexString: "#FE8331")
        sendButton.layer.cornerRadius = 25 // Половина ширины и высоты (50 / 2)
        sendButton.tintColor = .white
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        messageInputContainer.addSubview(sendButton)
        
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainer.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor),
            
            // Message input container constraints
            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageInputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // TextField constraints
            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 0),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Send Button constraints
            sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Ensure TextField does not overlap with Send Button
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16)
        ])
    }

    
    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        cell.configure(with: message.0, isBot: message.1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - Actions
    @objc private func handleSend() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        messages.append((text, false))
        messageTextField.text = nil
        tableView.reloadData()
        scrollToBottom()
        
        // Fetch response from ChatGPT
        fetchChatGPTResponse(for: text)
    }
    
    private func scrollToBottom() {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - ChatGPT API Integration
    private func fetchChatGPTResponse(for query: String) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
        
        let headers = [
            "Authorization": "Bearer \(openAIKey)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": query]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        self.messages.append((content, true))
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }
                }
            } catch {
                print("Error parsing response: \(error)")
            }
        }
        task.resume()
    }
}

// MARK: - Custom Chat Cell

class ChatMessageCell: UITableViewCell {
    private let messageLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let bubbleBackgroundView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Bubble background setup
        bubbleBackgroundView.layer.cornerRadius = 16
        bubbleBackgroundView.clipsToBounds = true
        contentView.addSubview(bubbleBackgroundView)
        
        // Message label setup
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = UIColor(hexString: "#1D3C2B")
        contentView.addSubview(messageLabel)
        
        // Avatar setup for bot
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(named: "Bot-Image")
        contentView.addSubview(avatarImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isBot: Bool) {
        messageLabel.text = text
        
        if isBot {
            // Бот: отображается аватар, закруглены верхние углы и правый нижний
            bubbleBackgroundView.backgroundColor = UIColor(hexString: "#CFCFCF")?.withAlphaComponent(0.6)
            messageLabel.textColor = .black
            avatarImageView.isHidden = false  // Аватар отображается у бота
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            // Пользователь: аватар не отображается, закруглены верхние углы и левый нижний
            bubbleBackgroundView.backgroundColor = UIColor(hexString: "#0A9E03")?.withAlphaComponent(0.6)
            messageLabel.textColor = .white
            avatarImageView.isHidden = true  // Аватар скрыт у пользователя
            bubbleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
        
        bubbleBackgroundView.layer.cornerRadius = 16
        bubbleBackgroundView.clipsToBounds = true
        
        setupConstraints(isBot: isBot)
    }
    
    private func setupConstraints(isBot: Bool) {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: isBot ? 50 : 0),
            avatarImageView.heightAnchor.constraint(equalToConstant: isBot ? 50 : 0),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: isBot ? avatarImageView.trailingAnchor : contentView.leadingAnchor, constant: isBot ? 8 : 60),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -20)
        ])
    }
}
