//
//  TrackTimelineControl.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 09.06.2023.
//

import UIKit

final class TrackTimelineControl: UIControl {
    // MARK: Constants
    let handleRadius = CGFloat(10)
    let timelinePadding = CGFloat(4)
    let timelineWidth = CGFloat(4)
    let startAngle: CGFloat = -.pi / 2
    
    // MARK: Properties
    var progress: CGFloat = 0
    
    // MARK: Sublayers
    let handleLayer = CAShapeLayer()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Smaller Rect
        let smallerRect = CGRect(
            x: rect.minX + timelinePadding,
            y: rect.minY + timelinePadding,
            width: rect.width - timelinePadding * 2,
            height: rect.height - timelinePadding * 2
        )
        
        drawBackgroundLine(smallerRect)
        drawProgressLine(smallerRect)
    }
    
    private func drawBackgroundLine(_ rect: CGRect) {
        let color = UIColor("#3C3C43")?.withAlphaComponent(0.18) ?? .gray
        
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = timelineWidth
        color.setStroke()
        path.stroke()
    }
    
    private func drawProgressLine(_ rect: CGRect) {
        let color = UIColor("#007AFF") ?? .systemBlue
        let endAngle: CGFloat = startAngle + 2 * .pi * progress
        
        let path = UIBezierPath(
            arcCenter: .init(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: -.pi / 2,
            endAngle: endAngle,
            clockwise: true
        )
        path.lineCapStyle = .round
        path.lineWidth = timelineWidth
        color.setStroke()
        path.stroke()
        
        drawHandle(progressLineRadius: rect.width / 2, angle: endAngle)
    }
    
    private func drawHandle(progressLineRadius: CGFloat, angle: CGFloat) {
        let xPosition = progressLineRadius * cos(angle)
        let yPosition = progressLineRadius * sin(angle)
        let coordsPadding = progressLineRadius + timelinePadding - handleRadius
        
        handleLayer.path = UIBezierPath(
            ovalIn: .init(
                origin: .init(x: xPosition + coordsPadding, y: yPosition + coordsPadding),
                size: .init(width: handleRadius * 2, height: handleRadius * 2)
            )
        ).cgPath
        handleLayer.fillColor = UIColor.white.cgColor
        
    }
}

extension TrackTimelineControl {
    func configure(progress: CGFloat) {
        self.progress = progress
        setNeedsDisplay()
    }
}

private extension TrackTimelineControl {
    func setup() {
        // View
        backgroundColor = .clear
        
        handleLayer.shadowColor = UIColor.black.cgColor
        handleLayer.shadowOffset = .init(width: 0, height: 0.5)
        handleLayer.shadowRadius = 4
        handleLayer.shadowOpacity = 0.12
        layer.addSublayer(handleLayer)
    }
}
