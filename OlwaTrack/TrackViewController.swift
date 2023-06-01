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
    private let player: AVAudioPlayer
    private let trackUrl: URL
    
    // MARK: Subviews
    private let trackTimeBar = UISlider()
    private let trackStateButton = UIButton()
    
    // MARK: Initializers
    init?(
        trackUrl: URL
    ) {
        self.trackUrl = trackUrl
        do {
            self.player = try AVAudioPlayer(contentsOf: trackUrl)
        } catch {
            print(error)
            return nil
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
    }
}

private extension TrackViewController {
    // MARK: User Interactivity
    @objc func changeTrackState() {
        if player.prepareToPlay() {
            player.play()
        }
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
            trackTimeBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: Setup
    func setup() {
        setupTrackTimeBar()
        setupTrackStateButton()
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
}
