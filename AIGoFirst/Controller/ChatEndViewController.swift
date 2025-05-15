import UIKit

// ChatEndViewController에서 발생하는 이벤트를 전달하기 위한 Delegate 프로토콜
protocol ChatEndViewControllerDelegate: AnyObject {
    func chatMoreRequested(for partner: ConfessionPartner)
    func deleteRecordRequested(for partner: ConfessionPartner)
    func backToMainRequested()
}

class ChatEndViewController: UIViewController {

    weak var delegate: ChatEndViewControllerDelegate?
    private let partner: ConfessionPartner

    // MARK: - UI 요소

    // 메시지 라벨
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "당신 최고야.\n내일도 힘든 일이 있으면\n나에게 찾아와!"
        label.font = UIFont.boldSystemFont(ofSize: 26) // 이미지에 맞춰 폰트 크기 조정
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black // 검은색 텍스트
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 파트너 이미지 뷰
    private let partnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // 이미지 비율 유지
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // "조금 더 이야기 나누기" 버튼
    private let chatMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("조금 더 이야기 나누기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor // 테두리 색상
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // 폰트
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // "기록 삭제하기" 버튼
    private let deleteRecordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록 삭제하기", for: .normal)
        button.setTitleColor(.white, for: .normal) // 하얀색 텍스트
        button.backgroundColor = .darkGray // 어두운 회색 배경
        button.layer.cornerRadius = 12 // 둥근 모서리
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // 폰트
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - 초기화 (이전과 동일)

    init(partner: ConfessionPartner) {
        self.partner = partner
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 뷰 생명주기 (이전과 동일)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setupUI() // UI 요소 추가
        setupLayout() // 레이아웃 제약 설정

        // 파트너 이미지 설정
        partnerImageView.image = UIImage(named: partner.goodImageName)

        // 버튼 액션 연결
        chatMoreButton.addTarget(self, action: #selector(chatMoreButtonTapped), for: .touchUpInside)
        deleteRecordButton.addTarget(self, action: #selector(deleteRecordButtonTapped), for: .touchUpInside)
    }

    // MARK: - UI 설정 (이전과 동일)

    private func setupUI() {
        view.addSubview(messageLabel)
        view.addSubview(partnerImageView)
        view.addSubview(chatMoreButton)
        view.addSubview(deleteRecordButton)
    }

    // MARK: - 레이아웃 설정 (수정된 부분)

    private func setupLayout() {
        // 버튼 높이 상수
        let buttonHeightConstant: CGFloat = 56

        NSLayoutConstraint.activate([
            // 메시지 라벨 제약
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80), // Safe Area 상단에서 간격
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 중앙 정렬
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20), // 좌측 최소 여백
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20), // 우측 최대 여백

            // 파트너 이미지 뷰 제약
            partnerImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40), // 메시지 라벨 아래 간격
            partnerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 중앙 정렬
            partnerImageView.widthAnchor.constraint(equalToConstant: 300), // 이미지 너비 240pt로 수정
            partnerImageView.heightAnchor.constraint(equalToConstant: 300), // 이미지 높이 240pt로 수정

            // "조금 더 이야기 나누기" 버튼 제약
            chatMoreButton.topAnchor.constraint(equalTo: partnerImageView.bottomAnchor, constant: 90), // 파트너 이미지 아래 간격
            chatMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 중앙 정렬 여기서는 이미지에 맞춰 중앙 정렬 유지)
            // chatMoreButton.widthAnchor.constraint(equalToConstant: buttonWidthConstant), // 기존 고정 너비 제약 제거
            chatMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 첫 페이지 버튼과 너비를 맞추기 위해 좌우 제약 사용
            chatMoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // 첫 페이지 버튼과 너비를 맞추기 위해 좌우 제약 사용
            chatMoreButton.heightAnchor.constraint(equalToConstant: buttonHeightConstant), // 높이 56pt로 설정

            // "기록 삭제하기" 버튼 제약
            deleteRecordButton.topAnchor.constraint(equalTo: chatMoreButton.bottomAnchor, constant: 15), // 위 버튼 아래 간격 15pt로 수정
            deleteRecordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 좌측 여백 20pt (첫 페이지 버튼과 동일)
            deleteRecordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // 우측 여백 20pt (첫 페이지 버튼과 동일)
            deleteRecordButton.heightAnchor.constraint(equalToConstant: buttonHeightConstant), // 높이 56pt (첫 페이지 버튼과 동일)

            
        ])

    }


    // MARK: - 버튼 액션 (이전과 동일)

    @objc private func chatMoreButtonTapped() {
        print("조금 더 이야기 나누기 버튼 탭")
        delegate?.chatMoreRequested(for: partner)
        dismiss(animated: true, completion: nil)
    }

    @objc private func deleteRecordButtonTapped() {
        print("기록 삭제하기 버튼 탭")
        delegate?.deleteRecordRequested(for: partner)
        dismiss(animated: true, completion: nil)
    }

    @objc private func backToMainButtonTapped() {
         delegate?.backToMainRequested()
         dismiss(animated: true, completion: nil)
    }
}
