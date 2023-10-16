//
//  OTOptionControl.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 21.06.2023.
//

import UIKit

final class OTOptionControl: UIControl {
    // MARK: Callbacks
    var valueDidChange: ((Float) -> Void)?
    
    // MARK: Constants
    let handleRadius: CGFloat = 8
    let lineWidth: CGFloat = 4
    
    // MARK: Constraints
    private var valueLabelLeadingOffset: NSLayoutConstraint!
    
    // MARK: Properties
    private var minValue: Float = 0
    private var maxValue: Float = 1
    private var value: Float = 1 {
        didSet {
            updateValueLabelPosition()
            valueLabel.text = String(format: "%.1f", value) + "x"
            valueDidChange?(value)
        }
    }
    private var valueDifference: Float = 0
    
    // MARK: Sublayers
    let handleLayer = CAShapeLayer()
    
    // MARK: Subviews
    let valueLabel = UILabel()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateValueLabelPosition()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawBackgroundLine(rect)
        drawValueLine(rect)
    }
    
    // MARK: Configuration
    func configure(initialValue: Float, minValue: Float, maxValue: Float) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.value = initialValue
        setNeedsDisplay()
    }
}

extension OTOptionControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pointInView = touch.location(in: self)
        let pathLength = bounds.width - lineWidth
        let xPosTouch = pointInView.x
        let valuesRange = maxValue - minValue
        let fraction = Float(xPosTouch / pathLength) * valuesRange
        
        valueDifference = fraction - value + minValue
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pointInView = touch.location(in: self)
        let pathLength = bounds.width - lineWidth
        let xPosTouch = pointInView.x
        let valuesRange = maxValue - minValue
        let fraction = Float(xPosTouch / pathLength) * valuesRange + minValue
        
        value = max(minValue, min(maxValue, fraction - valueDifference))
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
    // MARK: Helpers
    func updateValueLabelPosition() {
        guard !maxValue.isZero else { return }
        let valuesRange = maxValue - minValue
        let valueFraction = CGFloat(value / valuesRange - minValue)
        valueLabelLeadingOffset.constant = bounds.width * valueFraction
    }
    
    // MARK: Setup
    func setup() {
        // View
        backgroundColor = .clear
        
        // Value Label
        valueLabel.textColor = UIColor("#3A3A3C")?.withAlphaComponent(0.5)
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 1
        valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(valueLabel)
        valueLabelLeadingOffset = valueLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            valueLabelLeadingOffset,
            valueLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -9)
        ])
        
        // Handle Layer
        handleLayer.shadowColor = UIColor.black.cgColor
        handleLayer.shadowOffset = .init(width: 0, height: 0.5)
        handleLayer.shadowRadius = 4
        handleLayer.shadowOpacity = 0.12
        layer.addSublayer(handleLayer)
    }
    
    // MARK: Helpers
    private func drawBackgroundLine(_ rect: CGRect) {
        let color = UIColor("#BF6437")?.withAlphaComponent(0.15) ?? .gray
        
        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX + lineWidth / 2, y: rect.midY))
        path.addLine(to: .init(x: rect.maxX - lineWidth / 2, y: rect.midY))
        
        path.lineCapStyle = .round
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
    
    private func drawValueLine(_ rect: CGRect) {
        let color = UIColor("#BF6437") ?? .systemBlue
        let valuesRange = maxValue - minValue
        let endPosition = (rect.width - lineWidth) * CGFloat((value - minValue) / valuesRange)
        
        let path = UIBezierPath()
        path.move(to: .init(x: rect.minX + lineWidth / 2, y: rect.midY))
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
