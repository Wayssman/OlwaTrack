//
//  OTElementProtocol.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

class OTBaseButton: UIButton {
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class OTBaseView: UIView {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
