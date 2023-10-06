//
//  ImportedTracksCollectionCell.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit
import AVFoundation

protocol ImportedTracksCollectionCellDelegate: AnyObject {
    func didRemoveTrackFile(_ trackFile: ImportedTrackFile)
}

final class ImportedTracksCollectionCell: UICollectionViewCell {
    // MARK: Delegates
    weak var delegate: ImportedTracksCollectionCellDelegate?
    
    // MARK: Properties
    private var trackFile: ImportedTrackFile?
    
    // MARK: Subviews
    private let trackPreview = UIImageView()
    private let trackInfoStack = UIStackView()
        private let trackTitle = UILabel()
        private let trackLength = UILabel()
    private let trackRemoveButton = UIButton()
    
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
        
        trackFile = nil
        trackPreview.image = nil
        trackTitle.text = ""
        trackLength.text = ""
    }
    
    // MARK: Interface
    func configure(trackFile: ImportedTrackFile) {
        self.trackFile = trackFile
        
        var finalTitleText = ""
        if let artist = trackFile.info.artist {
            finalTitleText += "\(artist) – "
        }
        finalTitleText += trackFile.info.title ?? trackFile.fileName
        
        let sampleRate = trackFile.audioFile.processingFormat.sampleRate
        let audioLength = Double(trackFile.audioFile.length)
        let seconds = audioLength / sampleRate
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let trackLength = formatter.string(from: seconds) ?? "00:00"
        
        fillContent(
            preview: trackFile.info.artwork,
            title: finalTitleText,
            length: trackLength
        )
    }
}

private extension ImportedTracksCollectionCell {
    // MARK: Internal
    func fillContent(preview: Data?, title: String, length: String) {
        trackPreview.image = UIImage(data: preview ?? Data())
        trackTitle.text = title
        trackLength.text = length
    }
    
    // MARK: User Interactivity
    @objc private func removeAction() {
        guard let trackFile = self.trackFile else {
            return
        }
        delegate?.didRemoveTrackFile(trackFile)
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            trackPreview.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackPreview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackPreview.widthAnchor.constraint(equalToConstant: 56),
            trackPreview.heightAnchor.constraint(equalToConstant: 56),
            
            trackInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackInfoStack.leadingAnchor.constraint(equalTo: trackPreview.trailingAnchor, constant: 10),
            trackInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -57),
            
            trackRemoveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackRemoveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trackRemoveButton.heightAnchor.constraint(equalToConstant: 20),
            trackRemoveButton.widthAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Track Preview
        trackPreview.layer.cornerRadius = 8
        trackPreview.contentMode = .scaleAspectFit
        trackPreview.layer.masksToBounds = true
        trackPreview.backgroundColor = UIColor("#F2E4CE")
        
        trackPreview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackPreview)
        
        // Track Info Stack
        trackInfoStack.axis = .vertical
        trackInfoStack.spacing = 10
        
        trackInfoStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackInfoStack)
        
        // Track Title
        trackTitle.numberOfLines = 2
        trackTitle.textAlignment = .left
        trackTitle.font = .systemFont(ofSize: 16, weight: .regular)
        trackTitle.textColor = UIColor("#3A3A3C")
        
        trackTitle.translatesAutoresizingMaskIntoConstraints = false
        trackInfoStack.addArrangedSubview(trackTitle)
        
        // Track Length
        trackLength.numberOfLines = 1
        trackLength.textAlignment = .left
        trackLength.font = .systemFont(ofSize: 12, weight: .regular)
        trackLength.textColor = UIColor("#3A3A3C")?.withAlphaComponent(0.5)
        
        trackLength.translatesAutoresizingMaskIntoConstraints = false
        trackInfoStack.addArrangedSubview(trackLength)
        
        // Track Remove Button
        trackRemoveButton.setImage(UIImage(named: "iconDelete"), for: [])
        trackRemoveButton.tintColor = UIColor("#3A3A3C")
        trackRemoveButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        
        trackRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackRemoveButton)
    }
}
