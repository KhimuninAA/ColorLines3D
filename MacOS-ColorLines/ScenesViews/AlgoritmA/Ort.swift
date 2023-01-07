//
//  Ort.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation

enum Ort{
    case up
    case down
    case left
    case right
}

extension Ort{
    var reverce: Ort{
        switch self{
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
    
    var point: Point{
        switch self{
        case .up:
            return Point(x: 0, y: 1)
        case .down:
            return Point(x: 0, y: -1)
        case .left:
            return Point(x: -1, y: 0)
        case .right:
            return Point(x: 1, y: 0)
        }
    }
    
    static func fullOrts(_ main: [Ort]) -> [Ort]{
        var full: [Ort] = [.up, .down, .left, .right]
        for mainItem in main{
            if let index = full.firstIndex(where: {$0 == mainItem}){
                full.remove(at: index)
            }
        }
        for index in stride(from: main.count, to: 0, by: -1) {
            full.append(main[index - 1])
        }
        return full
    }
    
    var asString: String{
        switch self{
        case .up:
            return "Up"
        case .down:
            return "Down"
        case .left:
            return "Left"
        case .right:
            return "Right"
        }
    }
}
