//
//  TrackViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 01.06.2023.
//

import UIKit
import AVFAudio
import Foundation

final class TrackViewController: UIViewController {
    // MARK: Properties
    //private let player: AVAudioPlayer
    //private let trackUrl: URL
    private let sourceFile: AVAudioFile
    private let format: AVAudioFormat
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let speed = AVAudioUnitVarispeed()
    
    // MARK: Subviews
    private let trackTimeBar = UISlider()
    private let trackStateButton = UIButton()
    private let trackSpeedBar = UISlider()
    
    // MARK: Initializers
    init?(
        trackUrl: URL
    ) {
        do {
            sourceFile = try AVAudioFile(forReading: trackUrl)
            format = sourceFile.processingFormat
        } catch {
            fatalError("1")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        
        engine.attach(player)
        engine.attach(speed)
        
        speed.rate = 1
        
        engine.connect(player, to: speed, format: format)
        engine.connect(speed, to: engine.mainMixerNode, format: format)
        
        player.scheduleFile(sourceFile, at: nil)
        
        do {
            try engine.start()
            player.play()
        } catch {
            fatalError("2")
        }
    }
}

private extension TrackViewController {
    // MARK: User Interactivity
    @objc func changeTrackSpeed() {
        //player.rate = trackSpeedBar.value
        speed.rate = trackSpeedBar.value
    }
    
    @objc func changeTrackState() {
        /*player.enableRate = true
        if player.prepareToPlay() {
            player.play()
        }*/
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            trackTimeBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackTimeBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackTimeBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            trackStateButton.topAnchor.constraint(equalTo: trackTimeBar.bottomAnchor, constant: 10),
            trackStateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackStateButton.widthAnchor.constraint(equalToConstant: 100),
            trackTimeBar.heightAnchor.constraint(equalToConstant: 40),
            
            trackSpeedBar.topAnchor.constraint(equalTo: trackStateButton.bottomAnchor, constant: 10),
            trackSpeedBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackSpeedBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: Setup
    func setup() {
        setupTrackTimeBar()
        setupTrackStateButton()
        setupTrackSpeedBar()
    }
    
    func setupTrackTimeBar() {
        trackTimeBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackTimeBar)
    }
    
    func setupTrackStateButton() {
        trackStateButton.setImage(.actions, for: [])
        trackStateButton.addTarget(self, action: #selector(changeTrackState), for: .touchUpInside)
        
        trackStateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackStateButton)
    }
    
    func setupTrackSpeedBar() {
        trackSpeedBar.minimumValue = 0.5
        trackSpeedBar.maximumValue = 2.0
        trackSpeedBar.value = 1.0
        trackSpeedBar.addTarget(self, action: #selector(changeTrackSpeed), for: .valueChanged)
        
        trackSpeedBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackSpeedBar)
    }
}
