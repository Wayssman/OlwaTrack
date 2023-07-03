//
//  TrackTimelinePanel.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.07.2023.
//

import UIKit

final class TrackTimelinePanel: UIView {
    // MARK: Subviews
    private let timeline = TrackTimelineControl()
    private let leftTimeLabel = UILabel()
    private let remainTimeLabel = UILabel()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Others
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

private extension TrackTimelinePanel {
    // MARK: Layout
    func layout() {
        NSLayoutConstraint.activate([
            timeline.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            timeline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            timeline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            leftTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
            
            remainTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            remainTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
    }
    
    // MARK: Setup
    func setup() {
        // Self
        backgroundColor = .white
        layer.cornerRadius = 22
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        
        // Timeline
        timeline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeline)
        
        // Left Time Label
        leftTimeLabel.text = "0:07:02"
        leftTimeLabel.font = .systemFont(ofSize: 11, weight: .regular)
        leftTimeLabel.textColor = UIColor("#3C3C43")?.withAlphaComponent(0.6)
        leftTimeLabel.textAlignment = .left
        leftTimeLabel.numberOfLines = 1
        leftTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftTimeLabel)
        
        // Remain Time Label
        remainTimeLabel.text = "-0:24:02"
        remainTimeLabel.font = .systemFont(ofSize: 11, weight: .regular)
        remainTimeLabel.textColor = UIColor("#3C3C43")?.withAlphaComponent(0.6)
        remainTimeLabel.textAlignment = .right
        remainTimeLabel.numberOfLines = 1
        remainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(remainTimeLabel)
    }
}
