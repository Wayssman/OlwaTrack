//
//  OTNavigationController.swift
//  OlwaTrack
//
//  Created by Alexandr Zhelanov on 23.09.2023.
//

import UIKit

class OTNavigationController: UINavigationController {
    // MARK: Constants
    private let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16, weight: .medium),//poppins(.medium, size: 16),
        .foregroundColor: UIColor("#3A3A3C") ?? UIColor.black
    ]
    private let largeTitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 26, weight: .medium),//.poppins(.semibold, size: 34),
        .foregroundColor: UIColor("#3A3A3C") ?? UIColor.black
    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Setup
    private func setupView() {
        // Large Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        
        appearance.titleTextAttributes = titleAttributes
        appearance.largeTitleTextAttributes = largeTitleAttributes
        
        navigationBar.scrollEdgeAppearance = appearance
        
        // Compact appearance
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.configureWithDefaultBackground()
        compactAppearance.backgroundColor = UIColor("#F5F2E9")
        
        compactAppearance.titleTextAttributes = titleAttributes
        compactAppearance.largeTitleTextAttributes = largeTitleAttributes
        
        navigationBar.standardAppearance = compactAppearance
        navigationBar.compactAppearance = compactAppearance
        
        // Self
        view.backgroundColor = .clear
    }
}

