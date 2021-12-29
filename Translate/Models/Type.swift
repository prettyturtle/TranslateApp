//
//  Type.swift
//  Translate
//
//  Created by yc on 2021/12/29.
//

import UIKit

enum `Type` {
    case source
    case target
    
    var color: UIColor {
        switch self {
        case .source: return .label
        case .target: return .mainTintColor
        }
    }
}
