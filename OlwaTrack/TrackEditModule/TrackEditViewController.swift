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
    private let timelineContainer = UIView()
    private let timeline = TrackTimelineControl()
    private let leftTimeLabel = UILabel()
    private let remainTimeLabel = UILabel()
    private let trackTitleLabel = UILabel()
    private let playerButtonsStack = UIStackView()
    private let previousButton = UIButton()
    private let mainButton = UIButton()
    private let nextButton = UIButton()
    private let mixingContainer = UIView()
    private let trackSpeedLabel = UILabel()
    private let trackSpeedBar = OTOptionControl()
    
    private var timer: Timer?
    var progress: CGFloat = 0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.progress += (10 / 100)
            if self.progress >= 1 {
                self.progress = 0
            }
            self.timeline.configure(progress: self.progress)
        })
    }
}

private extension TrackEditViewController {
    // MARK: Setup
    func setup() {
        // View
        view.backgroundColor = .white
        
        // Timeline Container
        timelineContainer.backgroundColor = .white
        timelineContainer.layer.cornerRadius = 22
        timelineContainer.layer.shadowOffset = .zero
        timelineContainer.layer.shadowColor = UIColor.black.cgColor
        timelineContainer.layer.shadowOpacity = 0.25
        timelineContainer.layer.shadowRadius = 10
        timelineContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(timelineContainer)
        NSLayoutConstraint.activate([
            timelineContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            timelineContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            timelineContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            timelineContainer.heightAnchor.constraint(equalTo: timelineContainer.widthAnchor)
        ])
        
        // Timeline
        timeline.translatesAutoresizingMaskIntoConstraints = false
        
        timelineContainer.addSubview(timeline)
        NSLayoutConstraint.activate([
            timeline.topAnchor.constraint(equalTo: timelineContainer.topAnchor, constant: 20),
            timeline.leadingAnchor.constraint(equalTo: timelineContainer.leadingAnchor, constant: 20),
            timeline.trailingAnchor.constraint(equalTo: timelineContainer.trailingAnchor, constant: -20),
            timeline.bottomAnchor.constraint(equalTo: timelineContainer.bottomAnchor, constant: -20)
        ])
        
        // Left Time Label
        leftTimeLabel.text = "0:07:02"
        leftTimeLabel.font = .systemFont(ofSize: 11, weight: .regular)
        leftTimeLabel.textColor = UIColor("#3C3C43")?.withAlphaComponent(0.6)
        leftTimeLabel.textAlignment = .left
        leftTimeLabel.numberOfLines = 1
        leftTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timelineContainer.addSubview(leftTimeLabel)
        NSLayoutConstraint.activate([
            leftTimeLabel.leadingAnchor.constraint(equalTo: timelineContainer.leadingAnchor, constant: 16),
            leftTimeLabel.bottomAnchor.constraint(equalTo: timelineContainer.bottomAnchor, constant: -13)
        ])
        
        // Remain Time Label
        remainTimeLabel.text = "-0:24:02"
        remainTimeLabel.font = .systemFont(ofSize: 11, weight: .regular)
        remainTimeLabel.textColor = UIColor("#3C3C43")?.withAlphaComponent(0.6)
        remainTimeLabel.textAlignment = .right
        remainTimeLabel.numberOfLines = 1
        remainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timelineContainer.addSubview(remainTimeLabel)
        NSLayoutConstraint.activate([
            remainTimeLabel.trailingAnchor.constraint(equalTo: timelineContainer.trailingAnchor, constant: -16),
            remainTimeLabel.bottomAnchor.constraint(equalTo: timelineContainer.bottomAnchor, constant: -13)
        ])
        
        // Track Title Label
        trackTitleLabel.text = "Music File Name 1 - Very Long Long Naame"
        trackTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        trackTitleLabel.textColor = .black
        trackTitleLabel.textAlignment = .left
        trackTitleLabel.numberOfLines = 0
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackTitleLabel)
        NSLayoutConstraint.activate([
            trackTitleLabel.topAnchor.constraint(equalTo: timelineContainer.bottomAnchor, constant: 22),
            trackTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            trackTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
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
        NSLayoutConstraint.activate([
            exportButton.bottomAnchor.constraint(equalTo: timelineContainer.topAnchor, constant: -14),
            exportButton.trailingAnchor.constraint(equalTo: timelineContainer.trailingAnchor),
            exportButton.heightAnchor.constraint(equalToConstant: 48),
            exportButton.widthAnchor.constraint(equalToConstant: 156)
        ])
        
        // Player Buttons Stack
        playerButtonsStack.axis = .horizontal
        playerButtonsStack.spacing = 30
        playerButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(playerButtonsStack)
        NSLayoutConstraint.activate([
            playerButtonsStack.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 33),
            playerButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerButtonsStack.heightAnchor.constraint(equalToConstant: 24)
        ])
        
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
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        playerButtonsStack.addArrangedSubview(mainButton)
        
        // Next Button
        let nextButtonImage = UIImage(named: "iconForwardControl")?.withRenderingMode(.alwaysTemplate)
        
        nextButton.setImage(nextButtonImage, for: [])
        nextButton.tintColor = .systemBlue
        nextButton.adjustsImageWhenHighlighted = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        playerButtonsStack.addArrangedSubview(nextButton)
        
        // Mixing Container
        mixingContainer.backgroundColor = .white
        mixingContainer.layer.cornerRadius = 22
        mixingContainer.layer.shadowOffset = .zero
        mixingContainer.layer.shadowColor = UIColor.black.cgColor
        mixingContainer.layer.shadowOpacity = 0.25
        mixingContainer.layer.shadowRadius = 10
        mixingContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mixingContainer)
        NSLayoutConstraint.activate([
            mixingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            mixingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            mixingContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            mixingContainer.heightAnchor.constraint(equalToConstant: 102)
        ])
        
        // Track Speed Label
        trackSpeedLabel.text = "Track Speed:"
        trackSpeedLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        trackSpeedLabel.textColor = .black
        trackSpeedLabel.textAlignment = .left
        trackSpeedLabel.numberOfLines = 1
        trackSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mixingContainer.addSubview(trackSpeedLabel)
        NSLayoutConstraint.activate([
            trackSpeedLabel.topAnchor.constraint(equalTo: mixingContainer.topAnchor, constant: 15),
            trackSpeedLabel.leadingAnchor.constraint(equalTo: mixingContainer.leadingAnchor, constant: 16),
            trackSpeedLabel.trailingAnchor.constraint(equalTo: mixingContainer.trailingAnchor, constant: -16)
        ])
        
        // Track Speed Bar
        //trackSpeedBar.setProgress(30, animated: false)
        trackSpeedBar.translatesAutoresizingMaskIntoConstraints = false
        
        mixingContainer.addSubview(trackSpeedBar)
        NSLayoutConstraint.activate([
            trackSpeedBar.bottomAnchor.constraint(equalTo: mixingContainer.bottomAnchor, constant: -10),
            trackSpeedBar.leadingAnchor.constraint(equalTo: mixingContainer.leadingAnchor, constant: 20),
            trackSpeedBar.trailingAnchor.constraint(equalTo: mixingContainer.trailingAnchor, constant: -20),
            trackSpeedBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
