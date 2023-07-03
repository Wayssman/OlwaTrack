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
    private let headerContentView = UIView()
    private let addTrackButton = UIButton()
    private let tracksCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
}

// MARK: - UICollectionViewDataSource
extension ImportedTracksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImportedTracksCollectionCell = collectionView.dequeueCell(at: indexPath)
        cell.configure(title: fakeModel[indexPath.item])
        
        return cell
    }
}

extension ImportedTracksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trackEditController = TrackEditViewController()
        trackEditController.modalPresentationStyle = .pageSheet
        present(trackEditController, animated: true)
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
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            tracksCollectionView.topAnchor.constraint(equalTo: headerContentView.bottomAnchor),
            tracksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tracksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tracksCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerContentView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContentView.heightAnchor.constraint(equalToConstant: 100),
            
                addTrackButton.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor, constant: -14),
                addTrackButton.bottomAnchor.constraint(equalTo: headerContentView.bottomAnchor, constant: -14),
                addTrackButton.heightAnchor.constraint(equalToConstant: 35),
                addTrackButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // View
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        // Tracks Collection View
        tracksCollectionView.showsVerticalScrollIndicator = false
        tracksCollectionView.showsHorizontalScrollIndicator = false
        tracksCollectionView.alwaysBounceVertical = true
        tracksCollectionView.contentInset = .init(top: 13, left: 0, bottom: -13, right: 0)
        tracksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tracksCollectionView.registerCell(reuseable: ImportedTracksCollectionCell.self)
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        view.addSubview(tracksCollectionView)
        
        // Tracks Content View
        headerContentView.backgroundColor = .white
        headerContentView.layer.shadowOffset = .init(width: 0, height: 0)
        headerContentView.layer.shadowColor = UIColor.black.cgColor
        headerContentView.layer.shadowRadius = 10
        headerContentView.layer.shadowOpacity = 0.25
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContentView)
        
        // Add Track Button
        addTrackButton.backgroundColor = UIColor("#3A3A3C")
        addTrackButton.layer.cornerRadius = 8
        addTrackButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        addTrackButton.setTitle("Add Track", for: [])
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        headerContentView.addSubview(addTrackButton)
    }
}
