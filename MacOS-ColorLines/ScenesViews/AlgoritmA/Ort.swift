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
    static func random() -> [Ort]{
        var rsrs: [Ort] = [.left, .right, .up, .down]
        var res: [Ort] = [Ort]()
        
        for i in stride(from: rsrs.count, to: 0, by: -1) {
            let index = Int.random(in: 0..<i)
            res.append(rsrs[index])
            rsrs.remove(at: index)
        }
        
        return res
    }
    
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
        var full: [Ort] = full()
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
    
    static func full() -> [Ort]{
        return [.up, .down, .left, .right]
    }
    
    static func fullNoReverceValue(ort: Ort) -> [Ort] {
        let reverceOrt = ort.reverce
        var res = [Ort]()
        for item in Ort.full(){
            if item != reverceOrt{
                res.append(item)
            }
        }
        return res
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
