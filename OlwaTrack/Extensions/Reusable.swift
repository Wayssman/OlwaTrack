//
//  Reusable.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 03.07.2023.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String { return "\(self)" }
}
