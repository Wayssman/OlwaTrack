//
//  ImportedTracksCollectionHeader.swift
//  OlwaTrack
//
//  Created by Alexandr Zhelanov on 23.09.2023.
//

import UIKit

protocol ImportedTracksCollectionHeaderDelegate: AnyObject {
    func didButtonTap()
}

final class ImportedTracksCollectionHeader: UICollectionReusableView {
    // MARK: Delegates
    weak var delegate: ImportedTracksCollectionHeaderDelegate?
    
    // MARK: Subviews
    private let headerTitle = UILabel()
    private let importButton = UIButton()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImportedTracksCollectionHeader {
    // MARK: User Interactivity
    @objc func buttonTapped() {
        delegate?.didButtonTap()
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -82),
            
            importButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            importButton.heightAnchor.constraint(equalToConstant: 42),
            importButton.widthAnchor.constraint(equalToConstant: 42),
            importButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // headerTitle
        headerTitle.textColor = UIColor("#3A3A3C")
        headerTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        headerTitle.numberOfLines = 1
        headerTitle.textAlignment = .left
        headerTitle.text = "Imported Tracks"
        
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerTitle)
        
        // importButton
        importButton.backgroundColor = UIColor("#3A3A3C")
        importButton.layer.cornerRadius = 8
        importButton.setImage(UIImage(named: "iconImport"), for: [])
        importButton.tintColor = .white
        importButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        importButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(importButton)
    }
}
