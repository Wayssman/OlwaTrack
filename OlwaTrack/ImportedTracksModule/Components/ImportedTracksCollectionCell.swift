//
//  ImportedTracksCollectionCell.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit
import AVFoundation

final class ImportedTracksCollectionCell: UICollectionViewCell {
    // MARK: Properties
    private var trackUrl: URL?
    
    // MARK: Subviews
    private let trackPreviewContainer = UIView()
    private let trackPreview = UIImageView()
    private let trackTitle = UILabel()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackUrl = nil
        trackPreview.image = nil
        trackTitle.text = ""
    }
    
    // MARK: Interface
    func configure(trackUrl: URL) {
        self.trackUrl = trackUrl
        loadFileInfo()
    }
}

private extension ImportedTracksCollectionCell {
    // MARK: Internal
    func fillContent(title: String, artist: String?, artwork: Data?) {
        var finalTitleText = ""
        if let artist = artist {
            finalTitleText += "\(artist) – "
        }
        finalTitleText += title
        trackTitle.text = finalTitleText
        
        if let artwork = artwork {
            trackPreview.image = UIImage(data: artwork)
        } else {
            trackPreview.image = UIImage(named: "ColoredPlaceholder")
        }
    }
    
    func loadFileInfo() {
        guard let trackUrl = trackUrl else {
            // TODO: Write Error Handling
            fillContent(title: "Unknown", artist: nil, artwork: nil)
            return
        }
        
        let asset = AVAsset(url: trackUrl)
        let metadataItems = asset.metadata
        
        var titleAssetValue: String?
        var artistAssetValue: String?
        var artworkAssetValue: Data?
        
        for item in metadataItems {
            guard
                let key = item.commonKey?.rawValue,
                let value = item.value
            else { continue }
            
            switch key {
            case "title":
                titleAssetValue = value as? String
            case "artist":
                artistAssetValue = value as? String
            case "artwork":
                artworkAssetValue = value as? Data
            default:
                break
            }
        }
        
        fillContent(
            title: titleAssetValue ?? trackUrl.deletingPathExtension().lastPathComponent,
            artist: artistAssetValue,
            artwork: artworkAssetValue
        )
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            trackPreviewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            trackPreviewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.5),
            trackPreviewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            trackPreviewContainer.widthAnchor.constraint(equalTo: trackPreviewContainer.heightAnchor),
                
                trackPreview.topAnchor.constraint(equalTo: trackPreviewContainer.topAnchor),
                trackPreview.leadingAnchor.constraint(equalTo: trackPreviewContainer.leadingAnchor),
                trackPreview.trailingAnchor.constraint(equalTo: trackPreviewContainer.trailingAnchor),
                trackPreview.bottomAnchor.constraint(equalTo: trackPreviewContainer.bottomAnchor),
            
            trackTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            trackTitle.leadingAnchor.constraint(equalTo: trackPreview.trailingAnchor, constant: 10),
            trackTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.5),
            trackTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Track Preview Container
        trackPreviewContainer.backgroundColor = .white
        trackPreviewContainer.layer.cornerRadius = 8
        trackPreviewContainer.layer.shadowOffset = .init(width: 0, height: 0)
        trackPreviewContainer.layer.shadowColor = UIColor.black.cgColor
        trackPreviewContainer.layer.shadowRadius = 4
        trackPreviewContainer.layer.shadowOpacity = 0.25
        trackPreviewContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackPreviewContainer)
        
        // Track Preview
        trackPreview.layer.cornerRadius = 8
        trackPreview.contentMode = .scaleAspectFit
        trackPreview.layer.masksToBounds = true
        trackPreview.translatesAutoresizingMaskIntoConstraints = false
        trackPreviewContainer.addSubview(trackPreview)
        
        // Track Title
        trackTitle.numberOfLines = 0
        trackTitle.contentMode = .center
        trackTitle.textAlignment = .left
        trackTitle.font = .systemFont(ofSize: 16, weight: .bold)
        trackTitle.textColor = .black
        trackTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackTitle)
    }
}
