import UIKit



class ConfessionChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let partner: ConfessionPartner
    private var messages: [(String, Bool)] = [] // (메시지, isUser)

    // MARK: - UI
    private let partnerImageView = UIImageView()

    // 파트너 이름 라벨 - 폰트 크기 18 볼드체
    private let partnerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18) // 18 bold
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        setupUI() // UI 요소 추가 및 기본 설정 (addSubviews 포함)
        setupPartnerHeader() // 파트너 헤더 설정 (이미지, 이름 텍스트 등)
        setupTableView() // 테이블 뷰 설정
        setupInputBar() // 입력 바 설정 (플레이스홀더 색상 수정 포함)
        setupLayout() // 레이아웃 제약 설정

        // viewDidLoad에서 파트너 이름을 설정
        partnerNameLabel.text = partner.name

        // 네비게이션 바 설정
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // "끝내기" 버튼을 네비게이션 바 오른쪽에 추가
        let endButton = UIBarButtonItem(title: "끝내기", style: .plain, target: self, action: #selector(showEndScreen)) // 액션 함수 연결
        navigationItem.rightBarButtonItem = endButton
    }

    // MARK: - Setup UI elements (Helper function)
    private func setupUI() {
         // Add subviews to the main view
         view.addSubview(partnerImageView)
         view.addSubview(partnerNameLabel)
         view.addSubview(tableView)
         view.addSubview(inputContainer)
         // Add subviews to the input container
         inputContainer.addSubview(inputField)
         inputContainer.addSubview(sendButton)

        // Basic configurations (Image source, contentMode)
        partnerImageView.image = UIImage(named: partner.imageName)
        partnerImageView.contentMode = .scaleAspectFit

        // sendButton action connection
         sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }

    private func setupPartnerHeader() {
        // 파트너 이름 라벨 설정
        partnerNameLabel.text = partner.name // 이름 설정
        partnerNameLabel.textColor = .white // 텍스트 색상
        partnerNameLabel.textAlignment = .center
        // 뷰에 추가는 setupUI에서 수행
        partnerImageView.translatesAutoresizingMaskIntoConstraints = false
        partnerNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // 뷰에 추가는 setupUI에서 수행
    }

    private func setupInputBar() {
        inputContainer.backgroundColor = UIColor(white: 0.15, alpha: 1) // 입력 바 배경색
        inputField.backgroundColor = .clear // 입력 필드 배경색 투명
        inputField.textColor = .white // 입력 필드 입력 텍스트 색상
        inputField.font = UIFont.systemFont(ofSize: 16) // 입력 필드 입력 텍스트 폰트
        inputField.delegate = self // 델리게이트 설정

        // 플레이스홀더 텍스트와 색상 설정
        let placeholderText = "고민을 입력하세요..."
        // Hex #C7C7C7에 해당하는 UIColor
        let placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1.0)
        // attributedPlaceholder를 사용하여 플레이스홀더 색상 적용
        inputField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: placeholderColor])


        sendButton.setTitle("전송", for: .normal) // 전송 버튼 타이틀
        // 전송 버튼 색상은 제공해주신 코드에 맞춰 systemPurple로 유지
        sendButton.setTitleColor(.systemPurple, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // 액션 연결은 setupUI에서 수행
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        // 뷰에 추가는 setupUI에서 수행
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            // 파트너 이미지 및 이름 라벨 제약 (Safe Area 아래에 배치)
            partnerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            partnerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            partnerImageView.widthAnchor.constraint(equalToConstant: 48),
            partnerImageView.heightAnchor.constraint(equalToConstant: 48),

            partnerNameLabel.topAnchor.constraint(equalTo: partnerImageView.bottomAnchor, constant: 4),
            partnerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 테이블 뷰 제약 (파트너 이름 아래부터 입력 바 위까지)
            tableView.topAnchor.constraint(equalTo: partnerNameLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),

            // 입력 바 컨테이너 제약 (하단 Safe Area 위, 좌우 전체 너비)
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 56),

            // 입력 필드 제약 (입력 바 컨테이너 내부에 배치)
            inputField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            inputField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            inputField.heightAnchor.constraint(equalToConstant: 36),

            // 전송 버튼 제약 (입력 필드 오른쪽, 입력 바 컨테이너 우측)
            sendButton.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
        ])
    }

    // MARK: - 채팅 TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let (msg, isUser) = messages[indexPath.row]

        // 메시지 텍스트 설정
        cell.textLabel?.text = msg
        cell.textLabel?.textColor = isUser ? .systemPurple : .white
        cell.textLabel?.textAlignment = isUser ? .right : .left
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }

    // MARK: - 채팅 TableView Delegate (필요시 추가 구현)

    // MARK: - 메시지 전송
    @objc private func sendTapped() {
        guard let text = inputField.text, !text.isEmpty else { return }

        messages.append((text, true))
        tableView.reloadData()

        inputField.text = ""

        // TODO: 실제 AI 답변 연동 로직 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.messages.append((self.partner.name + "의 응답이 여기에 표시됩니다.", false))
            self.tableView.reloadData()
            // 최신 메시지로 스크롤 (필요시)
            let lastRow = self.messages.count - 1
            if lastRow >= 0 {
                 self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
            }
        }
    }

    // 키보드 Return 키 탭 시 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }

    // MARK: - "끝내기" 버튼 액션
    @objc private func showEndScreen() {
        // ChatEndViewController 인스턴스 생성
        let endVC = ChatEndViewController(partner: self.partner)
        // ChatEndViewController의 delegate를 현재 뷰 컨트롤러(self)로 설정
        endVC.delegate = self

        // ChatEndViewController를 모달로 띄웁니다.
        // .fullScreen 스타일은 뒤에 있는 뷰 컨트롤러를 완전히 가립니다.
        endVC.modalPresentationStyle = .fullScreen
        present(endVC, animated: true, completion: nil)
    }
}

// MARK: - ChatEndViewControllerDelegate 구현
// ConfessionChatViewController가 ChatEndViewController의 delegate 역할을 수행합니다.
extension ConfessionChatViewController: ChatEndViewControllerDelegate {

    // "조금 더 이야기 나누기" 버튼이 눌렸을 때 호출
    func chatMoreRequested(for partner: ConfessionPartner) {
        print("\(partner.name)와 조금 더 이야기 나누기 요청됨")
    }

    // "기록 삭제하기" 버튼이 눌렸을 때 호출 - 첫 화면으로 돌아가도록 수정
    func deleteRecordRequested(for partner: ConfessionPartner) {
        print("\(partner.name)와 대화 기록 삭제 요청됨 (첫 화면으로 이동)")
        navigationController?.popToRootViewController(animated: true) // 수정된 부분

        // TODO: 실제 대화 기록 삭제 로직을 여기에 추가할 예정
    }

    func backToMainRequested() {
         print("메인 화면으로 돌아가기 요청됨")
         navigationController?.popToRootViewController(animated: true)
    }
}
