import UIKit

class ConfessionChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let partner: ConfessionPartner
    private var messages: [(String, Bool)] = [] // (메시지, isUser)
    
    // MARK: - UI
    private let partnerImageView = UIImageView()
    private let partnerNameLabel = UILabel()
    private let tableView = UITableView()
    private let inputContainer = UIView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    // MARK: - Init
    init(partner: ConfessionPartner) {
        self.partner = partner
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPartnerHeader()
        setupTableView()
        setupInputBar()
        setupLayout()
    }
    private func setupPartnerHeader() {
        partnerImageView.image = UIImage(named: partner.imageName)
        partnerImageView.contentMode = .scaleAspectFit
        partnerNameLabel.text = partner.name
        partnerNameLabel.textColor = .white
        partnerNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        partnerNameLabel.textAlignment = .center
        view.addSubview(partnerImageView)
        view.addSubview(partnerNameLabel)
        partnerImageView.translatesAutoresizingMaskIntoConstraints = false
        partnerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            partnerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            partnerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            partnerImageView.widthAnchor.constraint(equalToConstant: 48),
            partnerImageView.heightAnchor.constraint(equalToConstant: 48),
            partnerNameLabel.topAnchor.constraint(equalTo: partnerImageView.bottomAnchor, constant: 4),
            partnerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    private func setupInputBar() {
        inputContainer.backgroundColor = UIColor(white: 0.15, alpha: 1)
        inputField.backgroundColor = .clear
        inputField.textColor = .white
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.delegate = self
        inputField.placeholder = "고민을 입력하세요..."
        sendButton.setTitle("전송", for: .normal)
        sendButton.setTitleColor(.systemPurple, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainer)
        inputContainer.addSubview(inputField)
        inputContainer.addSubview(sendButton)
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: partnerNameLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 56),
            inputField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            inputField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            sendButton.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            inputField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    // MARK: - 채팅 TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let (msg, isUser) = messages[indexPath.row]
        cell.textLabel?.text = msg
        cell.textLabel?.textColor = isUser ? .systemPurple : .white
        cell.textLabel?.textAlignment = isUser ? .right : .left
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    // MARK: - 전송
    @objc private func sendTapped() {
        guard let text = inputField.text, !text.isEmpty else { return }
        messages.append((text, true))
        tableView.reloadData()
        inputField.text = ""
        // TODO: AI 답변 추가
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.messages.append((self.partner.name + "의 응답이 여기에 표시됩니다.", false))
            self.tableView.reloadData()
        }
    }
    // 키보드 Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
} 