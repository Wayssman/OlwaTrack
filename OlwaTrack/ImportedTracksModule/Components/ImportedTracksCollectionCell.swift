//
//  ImportedTracksCollectionCell.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

final class ImportedTracksCollectionCell: UICollectionViewCell {
    // MARK: Static
    static let cellId = "ImportedTracksCollectionCell"
    
    // MARK: Subviews
    private let trackPreview = UIImageView()
    private let trackTitle = UILabel()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackTitle.text = ""
    }
    
    // MARK: Interface
    func configure(title: String) {
        trackTitle.text = title
    }
}

private extension ImportedTracksCollectionCell {
    // MARK: Setup
    func setup() {
        // Track Preview
        trackPreview.backgroundColor = .white
        trackPreview.layer.cornerRadius = 8
        trackPreview.layer.shadowOffset = .init(width: 0, height: 0)
        trackPreview.layer.shadowColor = UIColor.black.cgColor
        trackPreview.layer.shadowRadius = 4
        trackPreview.layer.shadowOpacity = 0.25
        trackPreview.contentMode = .scaleAspectFit
        trackPreview.image = UIImage(named: "ColoredPlaceholder")
        trackPreview.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(trackPreview)
        NSLayoutConstraint.activate([
            trackPreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            trackPreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.5),
            trackPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            trackPreview.widthAnchor.constraint(equalTo: trackPreview.heightAnchor)
        ])
        
        // Track Title
        trackTitle.numberOfLines = 0
        trackTitle.contentMode = .center
        trackTitle.textAlignment = .left
        trackTitle.font = .systemFont(ofSize: 16, weight: .bold)
        trackTitle.textColor = .black
        trackTitle.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(trackTitle)
        NSLayoutConstraint.activate([
            trackTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            trackTitle.leadingAnchor.constraint(equalTo: trackPreview.trailingAnchor, constant: 10),
            trackTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.5),
            trackTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
}
