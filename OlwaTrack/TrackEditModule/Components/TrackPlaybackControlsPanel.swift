//
//  TrackPlaybackControlsPanel.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.07.2023.
//

import UIKit

final class TrackPlaybackControlsPanel: UIView {
    // MARK: Callbacks
    var didMainButtonTapped: (() -> Void)?
    
    // MARK: Subviews
    private let playerButtonsStack = UIStackView()
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
    
    // MARK: Others
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

private extension TrackPlaybackControlsPanel {
    // MARK: User Interactive
    @objc func mainButtonTapped() {
        didMainButtonTapped?()
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            playerButtonsStack.topAnchor.constraint(equalTo: topAnchor),
            playerButtonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerButtonsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerButtonsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Player Buttons Stack
        playerButtonsStack.axis = .horizontal
        playerButtonsStack.spacing = 30
        //playerButtonsStack.isUserInteractionEnabled = false
        playerButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerButtonsStack)
        
        // Previous Button
        let previousButtonImage = UIImage(named: "iconBackControl")?.withRenderingMode(.alwaysTemplate)
        previousButton.setImage(previousButtonImage, for: [])
        previousButton.tintColor = .systemBlue
        previousButton.adjustsImageWhenHighlighted = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(previousButton)
        
        // Main Button
        let mainButtonImage = UIImage(named: "iconPlayControl")?.withRenderingMode(.alwaysTemplate)
        mainButton.setImage(mainButtonImage, for: [])
        mainButton.tintColor = .systemBlue
        mainButton.adjustsImageWhenHighlighted = false
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(mainButton)
        
        // Next Button
        let nextButtonImage = UIImage(named: "iconForwardControl")?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(nextButtonImage, for: [])
        nextButton.tintColor = .systemBlue
        nextButton.adjustsImageWhenHighlighted = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        playerButtonsStack.addArrangedSubview(nextButton)
    }
}
