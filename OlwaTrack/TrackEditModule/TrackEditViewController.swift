//
//  TrackEditViewController.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 09.06.2023.
//

import UIKit
import AVFoundation

final class TrackEditViewController: UIViewController {
    // MARK: Constants
    let nameOfDirectoryForExport = "OlwaTrackForExport"
    
    // MARK: Dependencies
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let speedControl = AVAudioUnitVarispeed()
    
    // MARK: Properties
    private var trackIndex: Int
    private var trackList: [URL]
    private var audioFile: AVAudioFile?
    private var timer: Timer?
    private var audioFileScheduleOffset: TimeInterval = 0
    
    // MARK: Subviews
    private let exportButton = UIButton()
    private let timelinePanel = TrackTimelinePanel()
    private let trackTitleLabel = UILabel()
    private let playbackControlsPanel = TrackPlaybackControlsPanel()
    private let mixingContainer = MixingContainer()
    
    // MARK: Initializers
    init(trackIndex: Int, trackList: [URL]) {
        self.trackIndex = trackIndex
        self.trackList = trackList
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareTrackFile()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAudio()
    }
}

private extension TrackEditViewController {
    // MARK: Internal
    func prepareTrackFile() {
        guard
            trackIndex >= 0 && trackIndex < trackList.count,
            let trackFile = try? AVAudioFile(forReading: trackList[trackIndex])
        else {
            dismiss(animated: true)
            return
        }
        audioEngine.reset()
        self.audioFile = trackFile
        prepareAudioEngine()
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
        
        scheduleAudioFile(from: nil)
    }
    
    func scheduleAudioFile(from timeInSeconds: TimeInterval?) {
        guard let audioFile = audioFile else { return }
        let audioSampleRate = audioFile.processingFormat.sampleRate

        if let timeInSeconds = timeInSeconds {
            let offsetSamples = AVAudioFramePosition(audioSampleRate * timeInSeconds)
            let frameCount = AVAudioFrameCount(audioFile.length)
            let newFrameCount = frameCount - AVAudioFrameCount(offsetSamples)
            
            playerNode.scheduleSegment(
                audioFile,
                startingFrame: offsetSamples,
                frameCount: newFrameCount,
                at: nil
            )
        } else {
            let audioLengthInSeconds = Double(audioFile.length) / audioSampleRate
            
            playerNode.scheduleFile(audioFile, at: nil)
            audioFileScheduleOffset = 0
            timelinePanel.configure(lengthInSeconds: audioLengthInSeconds)
        }
    }
    
    func renderToFile() {
        guard
            let audioFile = audioFile,
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            // TODO: Write Error Handling
            return
        }
        
        audioFileScheduleOffset += getPlayerTime()
        stopAudio()
        playerNode.scheduleFile(audioFile, at: nil)
        
        do {
            let maxFrames: AVAudioFrameCount = 4096
            try audioEngine.enableManualRenderingMode(
                .offline,
                format: audioFile.processingFormat,
                maximumFrameCount: maxFrames
            )
            try audioEngine.start()
            playerNode.play()
        } catch {
            // TODO: Write Error Handling
        }
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: audioEngine.manualRenderingFormat,
            frameCapacity: audioEngine.manualRenderingMaximumFrameCount
        )!
        
        let newDirectoryUrl = documentsUrl.appendingPathComponent(nameOfDirectoryForExport, isDirectory: true)
        try? FileManager.default.createDirectory(at: newDirectoryUrl, withIntermediateDirectories: false)
        
        let outputUrl = newDirectoryUrl.appendingPathComponent("Exported.mp3")
        var settings: [String : Any] = [:]
        settings[AVFormatIDKey] = kAudioFormatAppleIMA4
        settings[AVAudioFileTypeKey] = kAudioFileCAFType
        settings[AVSampleRateKey] = buffer.format.sampleRate
        settings[AVNumberOfChannelsKey] = 2
        settings[AVLinearPCMIsFloatKey] = (buffer.format.commonFormat == .pcmFormatInt32)
                                           
        guard let outputFile = try? AVAudioFile(forWriting: outputUrl, settings: settings, commonFormat: buffer.format.commonFormat, interleaved: buffer.format.isInterleaved) else {
            // TODO: Write Error Handling
            return
        }
        
        while audioEngine.manualRenderingSampleTime < audioFile.length {
            do {
                let frameCount = audioFile.length - audioEngine.manualRenderingSampleTime
                let framesToRender = min(AVAudioFrameCount(frameCount), buffer.frameCapacity)
                
                let status = try audioEngine.renderOffline(framesToRender, to: buffer)
                
                switch status {
                case .success:
                    try outputFile.write(from: buffer)
                case .error:
                    // TODO: Write Error Handling
                    return
                default:
                    break
                }
            } catch {
                // TODO: Write Error Handling
                return
            }
        }
        
        playerNode.stop()
        audioEngine.stop()
        audioEngine.disableManualRenderingMode()
        
        runExportActivity(url: outputUrl)
        scheduleAudioFile(from: audioFileScheduleOffset)
    }
    
    func runExportActivity(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    // MARK: Player
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
        guard audioFile != nil else { return }
        do {
            try audioEngine.start()
            playerNode.play()
            scheduleTimer()
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
    
    // MARK: Timer
    func scheduleTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerUpdate),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func timerUpdate() {
        guard let audioFile = audioFile else { return }
        let audioSampleRate = audioFile.processingFormat.sampleRate
        let audioLengthInSeconds = Double(audioFile.length) / audioSampleRate
        
        let fullPlayingTime = self.getPlayerTime() + audioFileScheduleOffset
        if fullPlayingTime > audioLengthInSeconds {
            stopAudio()
            prepareAudioEngine()
        } else {
            self.timelinePanel.update(currentTimeInSeconds: self.getPlayerTime() + audioFileScheduleOffset)
        }
    }
    
    // MARK: User Interactivity
    @objc func exportTapped() {
        renderToFile()
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
            guard let self = self else { return }
            
            do {
                try audioEngine.start()
                playerNode.stop()
                scheduleAudioFile(from: timeInSeconds)
                audioFileScheduleOffset = timeInSeconds
                playerNode.play()
            } catch {
                
            }
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
        exportButton.addTarget(self, action: #selector(exportTapped), for: .touchUpInside)
        view.addSubview(exportButton)
        
        // Playback Controls Panel
        playbackControlsPanel.didPreviousButtonTapped = { [weak self] in
            guard let self = self else { return }
            if trackIndex - 1 >= 0 {
                stopAudio()
                trackIndex -= 1
                prepareTrackFile()
            }
        }
        
        playbackControlsPanel.didMainButtonTapped = { [weak self] in
            guard let self = self else { return }
            if playerNode.isPlaying {
                pauseAudio()
            } else {
                playAudio()
            }
        }
        
        playbackControlsPanel.didNextButtonTapped = { [weak self] in
            guard let self = self else { return }
            if trackIndex + 1 < trackList.count {
                stopAudio()
                trackIndex += 1
                prepareTrackFile()
            }
        }
        
        playbackControlsPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackControlsPanel)
        
        // Mixing Container
        mixingContainer.playbackSpeedValueDidChange = { [weak self] value in
            guard let self = self else { return }
            speedControl.rate = value
        }
        
        mixingContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mixingContainer)
    }
}
