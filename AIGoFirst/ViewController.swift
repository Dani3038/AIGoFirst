import UIKit

class ViewController: UIViewController {
    // 시작화면 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "고해성사로\n무거운 마음의 짐을\n내려놓고 가세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    // 짐 덜어내러 가기 버튼
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("짐 덜어내러 가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    // 캐릭터 이미지(4명 단체)
    private let groupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Everybody")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        [titleLabel, groupImageView, startButton].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            // groupImageView: titleLabel 아래 42pt 간격으로 위치, 가로는 화면에 딱 맞게 (좌우 여백 0)
            groupImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
            groupImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groupImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            // startButton: 하단 Safe Area에서 40pt 위에 위치, 좌우 20pt 패딩, 높이 56pt
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])

        view.clipsToBounds = true // 뷰 경계를 넘어서는 내용(이미지)을 잘라냅니다.
    }

    @objc private func startButtonTapped() {
        let vc = PartnerSelectionViewController()
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
