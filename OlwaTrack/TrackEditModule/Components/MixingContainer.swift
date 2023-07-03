//
//  MixingContainer.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 03.07.2023.
//

import UIKit

final class MixingContainer: UIView {
    // MARK: Subviews
    private let trackSpeedLabel = UILabel()
    private let trackSpeedBar = OTOptionControl()
    
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

private extension MixingContainer {
    func layout() {
        NSLayoutConstraint.activate([
            trackSpeedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            trackSpeedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            trackSpeedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            trackSpeedBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            trackSpeedBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackSpeedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trackSpeedBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setup() {
        // Self
        backgroundColor = .white
        layer.cornerRadius = 22
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        
        // Track Speed Label
        trackSpeedLabel.text = "Track Speed:"
        trackSpeedLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        trackSpeedLabel.textColor = .black
        trackSpeedLabel.textAlignment = .left
        trackSpeedLabel.numberOfLines = 1
        trackSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackSpeedLabel)
        
        // Track Speed Bar
        trackSpeedBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackSpeedBar)
    }
}
