//
//  TrackEditViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 09.06.2023.
//

import UIKit
import AVFoundation

final class TrackEditViewController: UIViewController {
    // MARK: Dependencies
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let speedControl = AVAudioUnitVarispeed()
    
    // MARK: Properties
    private let audioFile: AVAudioFile?
    private var timer: Timer?
    private var audioFileScheduleOffset: TimeInterval = 0
    
    // MARK: Subviews
    private let exportButton = UIButton()
    private let timelinePanel = TrackTimelinePanel()
    private let trackTitleLabel = UILabel()
    private let playbackControlsPanel = TrackPlaybackControlsPanel()
    private let mixingContainer = MixingContainer()
    
    // MARK: Initializers
    init(trackUrl: URL) {
        self.audioFile = try? AVAudioFile(forReading: trackUrl)
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
        
        prepareAudioEngine()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAudio()
    }
}

private extension TrackEditViewController {
    // MARK: Internal
    func getPlayerTime() -> TimeInterval {
        guard
            let nodeTime = playerNode.lastRenderTime,
            let playerTime = playerNode.playerTime(forNodeTime: nodeTime)
        else {
            return 0
        }
        
        return Double(playerTime.sampleTime) / playerTime.sampleRate
    }
    
    func playAudio() {
        do {
            try audioEngine.start()
            playerNode.play()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                guard
                    let self = self,
                    let audioFile = audioFile
                else { return }
                
                let audioLengthSamples = audioFile.length
                let audioSampleRate = audioFile.processingFormat.sampleRate
                let audioLengthInSeconds = Double(audioLengthSamples) / audioSampleRate
                
                let fullPlayingTime = self.getPlayerTime() + audioFileScheduleOffset
                if fullPlayingTime > audioLengthInSeconds {
                    stopAudio()
                    prepareAudioEngine()
                } else {
                    self.timelinePanel.update(currentTimeInSeconds: self.getPlayerTime() + audioFileScheduleOffset)
                }
            })
            playbackControlsPanel.setState(isPlaying: true)
        } catch {
            print(error)
            /* Handle the error. */
        }
    }
    
    func pauseAudio() {
        playbackControlsPanel.setState(isPlaying: false)
        timer?.invalidate()
        timer = nil
        playerNode.pause()
        audioEngine.pause()
    }
    
    func stopAudio() {
        playbackControlsPanel.setState(isPlaying: false)
        timer?.invalidate()
        timer = nil
        playerNode.stop()
        audioEngine.stop()
    }
    
    func prepareAudioEngine() {
        guard let audioFile = self.audioFile else {
            // Write Error Handling
            dismiss(animated: true)
            return
        }
        audioEngine.attach(playerNode)
        audioEngine.attach(speedControl)
        
        audioEngine.connect(playerNode, to: speedControl, format: audioFile.processingFormat)
        audioEngine.connect(speedControl, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        playerNode.scheduleFile(audioFile, at: nil)
        audioFileScheduleOffset = 0
        
        let audioLengthSamples = audioFile.length
        let audioSampleRate = audioFile.processingFormat.sampleRate
        let audioLengthInSeconds = Double(audioLengthSamples) / audioSampleRate
        
        timelinePanel.configure(lengthInSeconds: audioLengthInSeconds)
    }
    
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
        timelinePanel.currentTimeDidChange = { [weak self] timeInSeconds in
            guard
                let self = self,
                let audioFile = self.audioFile
            else { return }
            
            playerNode.stop()
            
            let audioSampleRate = audioFile.processingFormat.sampleRate
            let offsetSamples = AVAudioFramePosition(timeInSeconds * audioSampleRate)
            let frameCount = AVAudioFrameCount(audioFile.length)
            let newFrameCount = frameCount - AVAudioFrameCount(offsetSamples)
            
            playerNode.scheduleSegment(
                audioFile,
                startingFrame: offsetSamples,
                frameCount: newFrameCount,
                at: nil
            )
            audioFileScheduleOffset = timeInSeconds
            
            playerNode.play()
        
        }
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
        playbackControlsPanel.didMainButtonTapped = { [weak self] in
            guard let self = self else { return }
            if playerNode.isPlaying {
                pauseAudio()
            } else {
                playAudio()
            }
        }
        
        playbackControlsPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackControlsPanel)
        
        // Mixing Container
        mixingContainer.playbackSpeedValueDidChange = { [weak self] value in
            guard let self = self else { return }
            print(value)
            speedControl.rate = value
        }
        
        mixingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mixingContainer)
    }
}
