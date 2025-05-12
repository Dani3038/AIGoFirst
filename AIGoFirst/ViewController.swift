//
//  ViewController.swift
//  AIGoFirst
//
//  Created by 정다운 on 5/12/25.
//

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
        imageView.image = UIImage(named: "Everybody") // Assets에 Everybody.png 필요
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    private func setupLayout() {
        [groupImageView, titleLabel, startButton].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        NSLayoutConstraint.activate([
            groupImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            groupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            groupImageView.heightAnchor.constraint(equalTo: groupImageView.widthAnchor, multiplier: 0.6),

            titleLabel.topAnchor.constraint(equalTo: groupImageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])
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

