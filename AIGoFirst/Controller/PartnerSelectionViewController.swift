import UIKit

// Hex 색상 문자열을 UIColor로 변환하는 헬퍼 함수 (Int(String, radix:) 사용)
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    guard cString.count == 6, let rgbValue = UInt32(cString, radix: 16) else {
        print("Warning: Invalid hex string: \(hex). Using gray color.")
        return UIColor.gray
    }

    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

    return UIColor(
        red: red,
        green: green,
        blue: blue,
        alpha: CGFloat(1.0)
    )
}

// ConfessionPartner enum 정의
enum ConfessionPartner: CaseIterable {
    case girl, nun, monk, boy

    var name: String {
        switch self {
        case .girl: return "내 친구"
        case .nun: return "수녀님"
        case .monk: return "스님"
        case .boy: return "내 친구"
        }
    }

    var imageName: String {
        switch self {
        case .girl: return "girl"
        case .nun: return "Nun"
        case .monk: return "Monk"
        case .boy: return "boy"
        }
    }
    
    var goodImageName: String {
        switch self {
        case .girl: return "girl_good"
        case .nun: return "Nun_good"
        case .monk: return "Monk_good"
        case .boy: return "boy_good"
        }
    }

    var guideText: String {
        switch self {
        case .girl:
            return "친한 친구에게 털어놓듯 편하게\n마음 속 고민을 털어놓아보세요!"
        case .nun:
            return "편안하게 기대어 위로받고 싶을 때\n수녀님께 고민을 털어놓는건 어때요?"
        case .monk:
            return "복잡한 생각들 속에서 길을 잃었다면?\n스님과 대화하고 평온을 찾아보아요!"
        case .boy:
            return "따뜻한 위로와 지지가 필요하다면?\n친구에게 마음 솔직하게 말해보아요!"
        }
    }

    var backgroundColorHex: String {
        switch self {
        case .girl: return "#F2F2F2"
        case .nun: return "#F0ECFA"
        case .monk: return "#F5EFD2"
        case .boy: return "#E6F0DC"
        }
    }

    var backgroundColor: UIColor {
        return hexStringToUIColor(hex: self.backgroundColorHex)
    }
}

class PartnerSelectionViewController: UIViewController {
    private var selectedPartner: ConfessionPartner? {
        didSet { updateUIForSelection() }
    }

    // 상단 안내 라벨
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 고해성사 파트너를\n선택해 주세요" // 초기 텍스트
        // 폰트 크기 20, 볼드체
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 파트너 버튼들을 담을 배열
    private var partnerButtons: [UIButton] = []

    // 하단 선택하기 버튼
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // 버튼 타이틀 폰트는 20pt 유지
        button.isEnabled = false
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupLayout() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])

        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 16
        gridStack.distribution = .fillEqually
        gridStack.translatesAutoresizingMaskIntoConstraints = false

        for row in 0..<2 {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 16
            hStack.distribution = .fillEqually

            for col in 0..<2 {
                let idx = row * 2 + col
                let partner = ConfessionPartner.allCases[idx]
                let btn = makePartnerButton(for: partner, index: idx)
                partnerButtons.append(btn)
                hStack.addArrangedSubview(btn)
            }
            gridStack.addArrangedSubview(hStack)
        }

        view.addSubview(gridStack)
        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 62),
            gridStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            gridStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            gridStack.heightAnchor.constraint(equalTo: gridStack.widthAnchor)
        ])

        view.addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    // 개별 파트너 선택 버튼 생성 함수
    private func makePartnerButton(for partner: ConfessionPartner, index: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.tag = index
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.backgroundColor = partner.backgroundColor // 파트너별 배경색 적용

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // 이미지 비율 유지하며 크기 조절
        imageView.image = UIImage(named: partner.imageName) // 파트너 이미지 이름 사용
        imageView.translatesAutoresizingMaskIntoConstraints = false
        btn.addSubview(imageView)

        let nameLabel = UILabel()
        nameLabel.text = partner.name // 파트너 이름 사용
        nameLabel.textColor = .darkGray // 텍스트 색상
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium) // 파트너 이름 폰트는 18pt 유지
        nameLabel.textAlignment = .center // 중앙 정렬
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        btn.addSubview(nameLabel)

        
        NSLayoutConstraint.activate([
            // 이미지 뷰 제약: 상단에서 16pt, 좌우 16pt 패딩
            imageView.topAnchor.constraint(equalTo: btn.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -16),

            // 이미지 뷰의 가로세로 비율 제약 추가 (1:1 비율)
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0),

            // 이름 라벨 제약: 이미지 뷰 바로 아래에 8pt 간격, 버튼 좌우 전체 너비, 버튼 하단에서 12pt 위
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), // 이미지 뷰 아래에 연결
            nameLabel.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: btn.bottomAnchor, constant: -12),
        ])

        btn.addTarget(self, action: #selector(partnerButtonTapped(_:)), for: .touchUpInside)
        return btn
    }

    @objc private func partnerButtonTapped(_ sender: UIButton) {
        let partner = ConfessionPartner.allCases[sender.tag]
        selectedPartner = partner
    }

    private func updateUIForSelection() {
        for (idx, btn) in partnerButtons.enumerated() {
            if ConfessionPartner.allCases[idx] == selectedPartner {
                btn.layer.borderColor = UIColor.black.cgColor
            } else {
                btn.layer.borderColor = UIColor.clear.cgColor
            }
        }

        if let partner = selectedPartner {
            // 선택된 파트너의 guideText로 guideLabel 텍스트 업데이트
            guideLabel.text = partner.guideText
            selectButton.isEnabled = true
            selectButton.alpha = 1.0
        } else {
            // 선택 해제 시 초기 텍스트로 복원
            guideLabel.text = "오늘의 고해성사 파트너를\n선택해 주세요"
            selectButton.isEnabled = false
            selectButton.alpha = 0.5
        }
    }

    @objc private func selectButtonTapped() {
        guard let partner = selectedPartner else { return }
        let chatVC = ConfessionChatViewController(partner: partner)
        if let nav = navigationController {
            nav.pushViewController(chatVC, animated: true)
        } else {
            chatVC.modalPresentationStyle = .fullScreen
            present(chatVC, animated: true, completion: nil)
        }
    }
}
