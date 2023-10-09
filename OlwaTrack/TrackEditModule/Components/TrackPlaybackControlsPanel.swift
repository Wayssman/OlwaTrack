//
//  TrackPlaybackControlsPanel.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.07.2023.
//

import UIKit

protocol TrackPlaybackControlsPanelDelegate: AnyObject {
    func didRepeatButtonTapped()
    func didPreviousButtonTapped()
    func didMainButtonTapped()
    func didNextButtonTapped()
}

final class TrackPlaybackControlsPanel: UIView {
    // MARK: Delegates
    weak var delegate: TrackPlaybackControlsPanelDelegate?
    
    // MARK: Subviews
    private let playerButtonsStack = UIStackView()
    private let repeatButton = UIButton()
    private let previousButton = UIButton()
    private let mainButton = UIButton()
    private let nextButton = UIButton()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Interface
    func setState(isPlaying: Bool) {
        let playButtonImage = UIImage(named: "iconPlayControl")?.withRenderingMode(.alwaysTemplate)
        let pauseButtonImage = UIImage(named: "iconPauseControl")?.withRenderingMode(.alwaysTemplate)
        mainButton.setImage(isPlaying ? pauseButtonImage : playButtonImage, for: [])
    }
    
    func setState(isPeviousEnabled: Bool) {
        previousButton.isEnabled = isPeviousEnabled
    }
    
    func setState(isNextEnabled: Bool) {
        nextButton.isEnabled = isNextEnabled
    }
}

private extension TrackPlaybackControlsPanel {
    // MARK: User Interactive
    @objc func repeatButtonTapped() {
        delegate?.didRepeatButtonTapped()
    }
    
    @objc func previousButtonTapped() {
        delegate?.didPreviousButtonTapped()
    }
    
    @objc func mainButtonTapped() {
        delegate?.didMainButtonTapped()
    }
    
    @objc func nextButtonTapped() {
        delegate?.didNextButtonTapped()
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            playerButtonsStack.topAnchor.constraint(equalTo: topAnchor),
            playerButtonsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            playerButtonsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            repeatButton.trailingAnchor.constraint(equalTo: playerButtonsStack.leadingAnchor, constant: -35),
            repeatButton.centerYAnchor.constraint(equalTo: playerButtonsStack.centerYAnchor),
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Player Buttons Stack
        playerButtonsStack.axis = .horizontal
        playerButtonsStack.spacing = 35
        playerButtonsStack.alignment = .center
        playerButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerButtonsStack)
        
        // Repeat Button
        let repeatImageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let repeatImage = UIImage(
            systemName: "repeat.1", 
            withConfiguration: repeatImageConfiguration
        )?.withRenderingMode(.alwaysTemplate)
        repeatButton.setImage(repeatImage, for: [])
        repeatButton.tintColor = UIColor("#3A3A3C")?.withAlphaComponent(0.5)
        repeatButton.adjustsImageWhenHighlighted = false
        repeatButton.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
        
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(repeatButton)
        
        // Previous Button
        let previousButtonImage = UIImage(named: "iconBackControl")?.withRenderingMode(.alwaysTemplate)
        previousButton.setImage(previousButtonImage, for: [])
        previousButton.tintColor = UIColor("#BF6437")
        previousButton.adjustsImageWhenHighlighted = false
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(previousButton)
        
        // Main Button
        let mainButtonImage = UIImage(named: "iconPlayControl")?.withRenderingMode(.alwaysTemplate)
        mainButton.setImage(mainButtonImage, for: [])
        mainButton.tintColor = UIColor("#BF6437")
        mainButton.adjustsImageWhenHighlighted = false
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(mainButton)
        
        // Next Button
        let nextButtonImage = UIImage(named: "iconForwardControl")?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(nextButtonImage, for: [])
        nextButton.tintColor = UIColor("#BF6437")
        nextButton.adjustsImageWhenHighlighted = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(nextButton)
    }
}
