//
//  BallColorType.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation
import Cocoa

enum BallColorType{
    case blue
    case red
    case green
    case yellow
    case lilac
    case orange
    case brown
    
    var color: NSColor{
        switch self{
        case .blue:
            return NSColor(named: "Color1") ?? .blue //.blue
        case .red:
            return NSColor(named: "Color2") ?? .red
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .lilac:
            return NSColor(named: "Color3") ?? .magenta
        case .orange:
            return .orange
        case .brown:
            return .brown
        }
    }
    
    static func random() -> BallColorType{
        let col = Int.random(in: 0...6)
        switch col{
        case 0:
            return .blue
        case 1:
            return .red
        case 2:
            return .green
        case 3:
            return .yellow
        case 4:
            return .lilac
        case 5:
            return .orange
        case 6:
            return .brown
            
        default:
            return .blue
        }
    }
}
