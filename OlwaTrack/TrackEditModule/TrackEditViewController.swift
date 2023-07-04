//
//  TrackEditViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 09.06.2023.
//

import UIKit

final class TrackEditViewController: UIViewController {
    // MARK: Subviews
    private let exportButton = UIButton()
    private let timelinePanel = TrackTimelinePanel()
    private let trackTitleLabel = UILabel()
    private let playbackControlsPanel = TrackPlaybackControlsPanel()
    private let mixingContainer = MixingContainer()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

private extension TrackEditViewController {
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            timelinePanel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            timelinePanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            timelinePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            timelinePanel.heightAnchor.constraint(equalTo: timelinePanel.widthAnchor),
            
            trackTitleLabel.topAnchor.constraint(equalTo: timelinePanel.bottomAnchor, constant: 22),
            trackTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            trackTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            exportButton.bottomAnchor.constraint(equalTo: timelinePanel.topAnchor, constant: -14),
            exportButton.trailingAnchor.constraint(equalTo: timelinePanel.trailingAnchor),
            exportButton.heightAnchor.constraint(equalToConstant: 48),
            exportButton.widthAnchor.constraint(equalToConstant: 156),
            
            playbackControlsPanel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 33),
            playbackControlsPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playbackControlsPanel.heightAnchor.constraint(equalToConstant: 24),
            
            mixingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            mixingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            mixingContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            mixingContainer.heightAnchor.constraint(equalToConstant: 102)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // View
        view.backgroundColor = .white
        
        // Timeline Container
        timelinePanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timelinePanel)
        
        // Track Title Label
        trackTitleLabel.text = "Music File Name 1 - Very Long Long Naame"
        trackTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        trackTitleLabel.textColor = .black
        trackTitleLabel.textAlignment = .left
        trackTitleLabel.numberOfLines = 0
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackTitleLabel)
        
        // Export Button
        let exportButtonImage = UIImage(
            named: "iconExport"
        )?.withRenderingMode(.alwaysTemplate)
    
        exportButton.setTitle("Export Track", for: [])
        exportButton.setImage(exportButtonImage, for: [])
        exportButton.tintColor = .white
        exportButton.adjustsImageWhenHighlighted = false
        exportButton.setTitleColor(.white, for: [])
        exportButton.backgroundColor = UIColor("#1E1E1E")?.withAlphaComponent(0.75)
        exportButton.layer.cornerRadius = 13
        exportButton.imageEdgeInsets = .init(top: 0, left: 12, bottom: 2, right: 0)
        exportButton.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 12)
        exportButton.semanticContentAttribute = .forceRightToLeft
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exportButton)
        
        // Playback Controls Panel
        playbackControlsPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackControlsPanel)
        
        // Mixing Container
        mixingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mixingContainer)
    }
}
