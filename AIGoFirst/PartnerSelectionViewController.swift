import UIKit

enum ConfessionPartner: CaseIterable {
    case priest, nun, monk, pastor
    var name: String {
        switch self {
        case .priest: return "신부님"
        case .nun: return "수녀님"
        case .monk: return "스님"
        case .pastor: return "목사님"
        }
    }
    var imageName: String {
        switch self {
        case .priest: return "Priest"
        case .nun: return "Nun"
        case .monk: return "Monk"
        case .pastor: return "Pastor"
        }
    }
    var guideText: String {
        switch self {
        case .priest:
            return "깊은 지혜로 명쾌하게 해답을 주시는 신부님께 고민을 털어놓아보세요!"
        case .nun:
            return "편안하게 기대어 위로받고 싶을 때 수녀님께 고민을 털어놓는건 어때요?"
        case .monk:
            return "복잡한 생각들 속에서 길을 잃었다면? 스님과 대화하고 평온을 찾아보아요!"
        case .pastor:
            return "따뜻한 위로와 지지가 필요하다면? 목사님과 함께 마음을 나누어 보아요!"
        }
    }
}

class PartnerSelectionViewController: UIViewController {
    private var selectedPartner: ConfessionPartner? {
        didSet { updateUIForSelection() }
    }
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "오늘의 고해성사 파트너를\n선택해 주세요"
        return label
    }()
    private var partnerButtons: [UIButton] = []
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    private func setupLayout() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        // 2x2 그리드 스택뷰
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
            gridStack.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 32),
            gridStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            gridStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            gridStack.heightAnchor.constraint(equalTo: gridStack.widthAnchor)  // 정사각형 그리드
        ])
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            selectButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    private func makePartnerButton(for partner: ConfessionPartner, index: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.tag = index
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // 이미지 설정
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: partner.imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        btn.addSubview(imageView)
        
        // 이름 라벨 설정
        let nameLabel = UILabel()
        nameLabel.text = partner.name
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        btn.addSubview(nameLabel)
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: btn.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
            
            nameLabel.leadingAnchor.constraint(equalTo: btn.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: btn.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: btn.bottomAnchor, constant: -12)
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
            guideLabel.text = partner.guideText
            selectButton.isEnabled = true
            selectButton.alpha = 1.0
        } else {
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