//
//  OTOptionControl.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 21.06.2023.
//

import UIKit

final class OTOptionControl: UIControl {
    // MARK: Constants
    let handleRadius = CGFloat(10)
    let lineWidth = CGFloat(4)
    
    // MARK: Properties
    private var value = CGFloat(0)
    private var beginTrackingPoint: CGPoint?
    
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
        var endPosition = (rect.width - lineWidth) * value
        if endPosition < lineWidth / 2 { endPosition = lineWidth / 2 }
        if endPosition > rect.width - lineWidth / 2 { endPosition = rect.width - lineWidth / 2 }
        
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
        
        print("Handle center x: \(xPosition)")
        
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
        guard
            let handlePath = handleLayer.path,
            handlePath.contains(pointInView)
        else { return false }
        
        beginTrackingPoint = pointInView
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let beginTrackingPoint = beginTrackingPoint else {
            return false
        }
        
        let pointInView = touch.location(in: self)
        let pathLength = bounds.width - lineWidth
        
        let diff = pointInView.x
        let fraction = diff / pathLength
        value = fraction
        
        setNeedsDisplay()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        beginTrackingPoint = nil
    }
    
    override func cancelTracking(with event: UIEvent?) {
        beginTrackingPoint = nil
    }
}

private extension OTOptionControl {
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
