//
//  TrackTimelinePanel.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.07.2023.
//

import UIKit

final class TrackTimelinePanel: UIView {
    // MARK: Constatns
    let maxWavesCount = 3
    let startWaveDiametr: CGFloat = 10
    let endWaveDiametr: CGFloat = 300
    let maxTapsTimeIntervalsCount = 20
    
    // MARK: Callbacks
    var currentTimeDidChange: ((TimeInterval) -> Void)?
    
    // MARK: Properties
    private var lengthInSeconds: TimeInterval = 0
    private var currentTimeInSeconds: TimeInterval = 0
    private var lastTapDate: Date?
    private var tapsTimeIntervals: [TimeInterval] = []
    private var timer: Timer?
    
    // MARK: Subviews
    private let tapHintLabel = UILabel()
    private let bpmHintLabel = UILabel()
    private let bpmLabel = UILabel()
    private let timeline = TrackTimelineControl()
    private let leftTimeLabel = UILabel()
    private let remainTimeLabel = UILabel()
    
    // MARK: Sublayers
    private var preservedAnimationSublayersInfo: [(layer: CAShapeLayer, startTime: TimeInterval)] = []
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
        preserveAnimationSublayers()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: Interface
    func configure(lengthInSeconds: TimeInterval) {
        self.lengthInSeconds = lengthInSeconds
        self.currentTimeInSeconds = 0
        refreshTimeLabels(timeLeft: 0, timeRemains: lengthInSeconds)
        timeline.configure(value: 0)
    }
    
    func update(currentTimeInSeconds: TimeInterval) {
        self.currentTimeInSeconds = currentTimeInSeconds
        let timeRemains = lengthInSeconds - currentTimeInSeconds
        refreshTimeLabels(timeLeft: currentTimeInSeconds, timeRemains: timeRemains)
        timeline.configure(value: Float(currentTimeInSeconds/lengthInSeconds))
    }
}

private extension TrackTimelinePanel {
    // MARK: User Interactivity
    @objc private func didTap(_ sender: UITapGestureRecognizer? = nil) {
        guard 
            let point = sender?.location(in: self),
            !timeline.checkPointOnHandle(self.convert(point, to: timeline))
        else { return }
        launchTouchAnimation(point)
        calculateBpm()
        startTimer()
    }
    
    // MARK: Helpers
    func refreshTimeLabels(timeLeft: TimeInterval, timeRemains: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        leftTimeLabel.text = formatter.string(from: timeLeft.rounded(.up))
        remainTimeLabel.text = "-" + (formatter.string(from: timeRemains.rounded(.up)) ?? "")
    }
    
    func launchTouchAnimation(_ point: CGPoint) {
        // Find free layer or take first
        let minTime = preservedAnimationSublayersInfo.map { $0.startTime }.min() ?? 0
        let layerInfoIndex = preservedAnimationSublayersInfo.firstIndex(
            where: { $0.layer.animation(forKey: "WaveAnimationKey") == nil }
        ) ?? preservedAnimationSublayersInfo.firstIndex(
            where: { $0.startTime == minTime }
        )
        
        guard let layerInfoIndex = layerInfoIndex else { return }
        
        // Create Animation
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.isRemovedOnCompletion = true
        
        let circleWaveAnimation = CABasicAnimation(keyPath: "path")
        let startRect = rectForCircleWave(point: point, diameter: startWaveDiametr)
        let endRect = rectForCircleWave(point: point, diameter: endWaveDiametr)
        circleWaveAnimation.fromValue = UIBezierPath(ovalIn: startRect).cgPath
        circleWaveAnimation.toValue = UIBezierPath(ovalIn: endRect).cgPath
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0
        
        animationGroup.animations = [circleWaveAnimation, opacityAnimation]
        preservedAnimationSublayersInfo[layerInfoIndex].layer.add(animationGroup, forKey: "WaveAnimationKey")
        preservedAnimationSublayersInfo[layerInfoIndex].startTime = Date().timeIntervalSinceReferenceDate
    }
    
    func rectForCircleWave(point: CGPoint, diameter: CGFloat) -> CGRect {
        return CGRect(
            x: point.x - diameter / 2,
            y: point.y - diameter / 2,
            width: diameter,
            height: diameter
        )
    }
    
    func calculateBpm() {
        guard let lastTapDate = self.lastTapDate else {
            lastTapDate = Date()
            return
        }
        
        let currentTapDate = Date()
        let timeInterval = currentTapDate.timeIntervalSince(lastTapDate)  // Seconds for 1 beat
        if tapsTimeIntervals.count >= maxTapsTimeIntervalsCount { tapsTimeIntervals.removeFirst() }
        tapsTimeIntervals.append(timeInterval)
        let averageTimeInterval = tapsTimeIntervals.reduce(0, +) / Double(tapsTimeIntervals.count)
        
        let oneMinuteBeats = averageTimeInterval.isZero ? .zero : (60 / averageTimeInterval)
        self.bpmLabel.text = "\(Int(oneMinuteBeats))"
        
        self.lastTapDate = currentTapDate
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            self.lastTapDate = nil
            self.tapsTimeIntervals.removeAll()
            self.bpmLabel.text = "0"
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            tapHintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tapHintLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tapHintLabel.widthAnchor.constraint(equalToConstant: 150),
            tapHintLabel.heightAnchor.constraint(equalToConstant: 40),
            
            bpmHintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            bpmHintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bpmHintLabel.widthAnchor.constraint(equalToConstant: 50),
            
            bpmLabel.topAnchor.constraint(equalTo: bpmHintLabel.bottomAnchor, constant: 8),
            bpmLabel.centerXAnchor.constraint(equalTo: bpmHintLabel.centerXAnchor),
            bpmLabel.widthAnchor.constraint(equalToConstant: 66),
            
            timeline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            timeline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            timeline.heightAnchor.constraint(equalTo: timeline.widthAnchor),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
            
            leftTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            remainTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            remainTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Tap Hint Label
        tapHintLabel.text = "TAP INSIDE CIRCLE"
        tapHintLabel.font = .systemFont(ofSize: 12, weight: .medium)
        tapHintLabel.textColor = UIColor("#3A3A3C")?.withAlphaComponent(0.5)
        tapHintLabel.textAlignment = .center
        tapHintLabel.numberOfLines = 1
        
        tapHintLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tapHintLabel)
        
        // Bpm Hint Label
        bpmHintLabel.text = "BPM"
        bpmHintLabel.font = .systemFont(ofSize: 16, weight: .regular)
        bpmHintLabel.textColor = UIColor("#BF6437")
        bpmHintLabel.textAlignment = .center
        bpmHintLabel.numberOfLines = 1
        
        bpmHintLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bpmHintLabel)
        
        // Bpm Label
        bpmLabel.text = "0"
        bpmLabel.font = .systemFont(ofSize: 22, weight: .medium)
        bpmLabel.textColor = UIColor("#3A3A3C")
        bpmLabel.textAlignment = .center
        bpmLabel.numberOfLines = 1
        
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bpmLabel)
        
        // Timeline
        timeline.valueDidChange = { [weak self] value in
            guard let self = self else { return }
            
            currentTimeInSeconds = lengthInSeconds * Double(value)
            currentTimeDidChange?(currentTimeInSeconds)
            let timeRemains = lengthInSeconds - currentTimeInSeconds
            refreshTimeLabels(timeLeft: currentTimeInSeconds, timeRemains: timeRemains)
        }
        timeline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeline)
        
        // Left Time Label
        leftTimeLabel.text = "00:00:00"
        leftTimeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        leftTimeLabel.textColor = UIColor("#BF6437")
        leftTimeLabel.textAlignment = .left
        leftTimeLabel.numberOfLines = 1
        leftTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftTimeLabel)
        
        // Remain Time Label
        remainTimeLabel.text = "-00:00:00"
        remainTimeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        remainTimeLabel.textColor = UIColor("#BF6437")
        remainTimeLabel.textAlignment = .right
        remainTimeLabel.numberOfLines = 1
        remainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(remainTimeLabel)
        
        // Self
        backgroundColor = UIColor("#F2E4CE")
        layer.cornerRadius = 16
        layer.masksToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func preserveAnimationSublayers() {
        for _ in 0..<maxWavesCount {
            let sublayer = CAShapeLayer()
            
            sublayer.lineWidth = 1
            sublayer.strokeColor = UIColor("#BF6437")?.cgColor
            sublayer.fillColor = .none
            
            layer.addSublayer(sublayer)
            preservedAnimationSublayersInfo.append((layer: sublayer, startTime: 0))
        }
    }
}
