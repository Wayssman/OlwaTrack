//
//  MixingContainer.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 03.07.2023.
//

import UIKit

final class MixingContainer: UIView {
    // MARK: Callbacks
    var playbackSpeedValueDidChange: ((Float) -> Void)?
    
    // MARK: Subviews
    private let trackSpeedBadge = UIImageView()
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
}

private extension MixingContainer {
    func layout() {
        NSLayoutConstraint.activate([
            trackSpeedBadge.topAnchor.constraint(equalTo: topAnchor),
            trackSpeedBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            trackSpeedBadge.widthAnchor.constraint(equalToConstant: 56),
            trackSpeedBadge.heightAnchor.constraint(equalTo: trackSpeedBadge.widthAnchor),
            
            trackSpeedLabel.topAnchor.constraint(equalTo: trackSpeedBadge.topAnchor),
            trackSpeedLabel.leadingAnchor.constraint(equalTo: trackSpeedBadge.trailingAnchor, constant: 20),
            trackSpeedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            trackSpeedBar.bottomAnchor.constraint(equalTo: trackSpeedBadge.bottomAnchor, constant: -3),
            trackSpeedBar.leadingAnchor.constraint(equalTo: trackSpeedBadge.trailingAnchor, constant: 20),
            trackSpeedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trackSpeedBar.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setup() {
        // Track Speed Bage
        let badgeImageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        let badgeImage = UIImage(
            systemName: "speedometer", 
            withConfiguration: badgeImageConfiguration
        )?.withRenderingMode(.alwaysTemplate)
        trackSpeedBadge.image = badgeImage
        trackSpeedBadge.contentMode = .center
        trackSpeedBadge.tintColor = .white
        trackSpeedBadge.layer.cornerRadius = 8
        trackSpeedBadge.backgroundColor = UIColor("#BF6437")
        
        trackSpeedBadge.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackSpeedBadge)
        
        // Track Speed Label
        trackSpeedLabel.text = "Track Speed:"
        trackSpeedLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        trackSpeedLabel.textColor = UIColor("#3A3A3C")
        trackSpeedLabel.textAlignment = .left
        trackSpeedLabel.numberOfLines = 1
        trackSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackSpeedLabel)
        
        // Track Speed Bar
        trackSpeedBar.configure(initialValue: 1, maxValue: 2)
        trackSpeedBar.valueDidChange = { [weak self] value in
            guard let self = self else { return }
            playbackSpeedValueDidChange?(value)
        }
        trackSpeedBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackSpeedBar)
    }
}
