//
//  OTOptionControl.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 21.06.2023.
//

import UIKit

final class OTOptionControl: UIControl {
    // MARK: Constants
    let handleRadius: CGFloat = 10
    let lineWidth: CGFloat = 4
    
    // MARK: Properties
    private var value: CGFloat = 0
    private var valueDifference: CGFloat = 0
    
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
        
        drawBackgroundLine(rect)
        drawValueLine(rect)
    }
    
    // MARK: Others
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    private func drawBackgroundLine(_ rect: CGRect) {
        let color = UIColor("#3C3C43")?.withAlphaComponent(0.18) ?? .gray
        
        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX + lineWidth/2, y: rect.midY))
        path.addLine(to: .init(x: rect.maxX - lineWidth/2, y: rect.midY))
        
        path.lineCapStyle = .round
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
    
    private func drawValueLine(_ rect: CGRect) {
        let color = UIColor("#007AFF") ?? .systemBlue
        let endPosition = (rect.width - lineWidth) * value
        
        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX + lineWidth/2, y: rect.midY))
        path.addLine(to: .init(x: endPosition, y: rect.midY))
        
        path.lineCapStyle = .round
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
        
        drawHandle(endPosition: endPosition, rect: rect)
    }
    
    private func drawHandle(endPosition: CGFloat, rect: CGRect) {
        let xPosition = endPosition
        let yPosition = rect.midY
        
        handleLayer.path = UIBezierPath(
            ovalIn: .init(
                origin: .init(x: xPosition - handleRadius, y: yPosition - handleRadius),
                size: .init(width: handleRadius * 2, height: handleRadius * 2)
            )
        ).cgPath
        handleLayer.fillColor = UIColor.white.cgColor
    }
}

extension OTOptionControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pointInView = touch.location(in: self)
        let pathLength = bounds.width - lineWidth
        let xPosTouch = pointInView.x
        let fraction = xPosTouch / pathLength
        
        valueDifference = fraction - value
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pointInView = touch.location(in: self)
        let pathLength = bounds.width - lineWidth
        
        let xPosTouch = pointInView.x
        let fraction = xPosTouch / pathLength
        value = max(0, min(1, fraction - valueDifference))
        
        setNeedsDisplay()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        valueDifference = 0
    }
    
    override func cancelTracking(with event: UIEvent?) {
        valueDifference = 0
    }
}

private extension OTOptionControl {
    // MARK: Setup
    func setup() {
        // View
        backgroundColor = .clear
        
        // Handle Layer
        handleLayer.shadowColor = UIColor.black.cgColor
        handleLayer.shadowOffset = .init(width: 0, height: 0.5)
        handleLayer.shadowRadius = 4
        handleLayer.shadowOpacity = 0.12
        layer.addSublayer(handleLayer)
    }
}
