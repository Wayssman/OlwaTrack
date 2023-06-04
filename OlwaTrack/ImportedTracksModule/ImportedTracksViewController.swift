//
//  ImportedTracksViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

final class ImportedTracksViewController: UIViewController {
    // MARK: Properties
    private let fakeModel = [
        "Music File Name 1 - Very Long Long Naame",
        "Music File Name 1 - Very Long Long Naame",
        "Music File Name 1 - Very Long Long Naame"
    ]
    
    // MARK: Subviews
    private let addTrackButton = UIButton()
    private let tracksContentView = UIView()
    private let tracksCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - UICollectionViewDataSource
extension ImportedTracksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImportedTracksCollectionCell.cellId,
            for: indexPath
        ) as? ImportedTracksCollectionCell else {
            fatalError()
        }
        
        cell.configure(title: fakeModel[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImportedTracksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 82)
    }
}

private extension ImportedTracksViewController {
    // MARK: User Interactivity
    @objc func addTrackButtonTapped() {
        
    }
    
    // MARK: Setup
    func setup() {
        // View
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        // Add Track Button
        addTrackButton.backgroundColor = UIColor("#3A3A3C")
        addTrackButton.layer.cornerRadius = 8
        addTrackButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        addTrackButton.setTitle("Add Track", for: [])
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        
        view.addSubview(addTrackButton)
        NSLayoutConstraint.activate([
            addTrackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            addTrackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            addTrackButton.heightAnchor.constraint(equalToConstant: 35),
            addTrackButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Tracks Content View
        tracksContentView.layer.cornerRadius = 20
        tracksContentView.layer.shadowOffset = .init(width: 0, height: 0)
        tracksContentView.layer.shadowColor = UIColor.black.cgColor
        tracksContentView.layer.shadowRadius = 10
        tracksContentView.layer.shadowOpacity = 0.25
        tracksContentView.clipsToBounds = false
        tracksContentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tracksContentView)
        NSLayoutConstraint.activate([
            tracksContentView.topAnchor.constraint(equalTo: addTrackButton.bottomAnchor, constant: 13),
            tracksContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tracksContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tracksContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        
        // Tracks Collection View
        tracksCollectionView.layer.cornerRadius = 20
        tracksCollectionView.showsVerticalScrollIndicator = false
        tracksCollectionView.showsHorizontalScrollIndicator = false
        tracksCollectionView.alwaysBounceVertical = true
        tracksCollectionView.contentInset = .init(top: 13, left: 0, bottom: -13, right: 0)
        tracksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        tracksCollectionView.register(
            ImportedTracksCollectionCell.self,
            forCellWithReuseIdentifier: ImportedTracksCollectionCell.cellId
        )
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        
        tracksContentView.addSubview(tracksCollectionView)
        NSLayoutConstraint.activate([
            tracksCollectionView.topAnchor.constraint(equalTo: tracksContentView.topAnchor),
            tracksCollectionView.leadingAnchor.constraint(equalTo: tracksContentView.leadingAnchor),
            tracksCollectionView.trailingAnchor.constraint(equalTo: tracksContentView.trailingAnchor),
            tracksCollectionView.bottomAnchor.constraint(equalTo: tracksContentView.bottomAnchor)
        ])
    }
}
