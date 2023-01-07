//
//  AlgoritmA.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation

class AlgoritmA{
    
    private static func getOrtX(_ x: Int) -> Ort?{
        if x == 0 {
            return nil
        }else{
            if x > 0 {
                return .right
            }else{
                return .left
            }
        }
    }
    
    private static func getOrtY(_ y: Int) -> Ort?{
        if y == 0 {
            return nil
        }else{
            if y > 0 {
                return .up
            }else{
                return .down
            }
        }
    }
    
    private static func getOrts(from: Point, to: Point) -> [Ort]{
        var orts: [Ort] = [Ort]()
        let x = to.x - from.x
        let y = to.y - from.y
        if abs(x) > abs(y){
            if let ort = getOrtX(x){
                orts.append(ort)
            }
            if let ort = getOrtY(y){
                orts.append(ort)
            }
        }else{
            if let ort = getOrtY(y){
                orts.append(ort)
            }
            if let ort = getOrtX(x){
                orts.append(ort)
            }
        }
        return Ort.fullOrts(orts)
    }
    
    private static func makeStartOpens(point: Point, end: Point) -> [Vec]{
        var vec = [Vec]()
        let orts = getOrts(from: point, to: end)
        for ort in orts{
            vec.append(Vec(point: point, ort: ort))
        }
        return vec
    }
    
    static func getPath(start: Point, end: Point, blocks: [Point]) -> [Point]?{
        var closed: [Vec] = [Vec]()
        var opens: [Vec] = makeStartOpens(point: start, end: end)
        var full: [Vec] = opens
        var paths: [Point] = [Point]()
        
        func addClose(_ vec: Vec){
            closed.append(vec)
            let filter = closed.filter { tmpVec in
                return tmpVec.point.x==vec.point.x && tmpVec.point.y==vec.point.y
            }
            if filter.count >= 3{
                if let index = paths.firstIndex(where: {$0.x == vec.point.x && $0.y == vec.point.y}) {
                    paths.remove(at: index)
                }
            }
        }
        
        func addOpens(_ op: [Vec]){
            for item in op{
                let index = closed.firstIndex(where: {$0.point == item.point && $0.ort == item.ort})
                if index == nil{
                    let find = full.firstIndex(where: {$0.point == item.point && $0.ort == item.ort})
                    if find == nil{
                        opens.append(item)
                        full.append(item)
                    }
                }
            }
        }
        
        while opens.count > 0 {
            let vec = opens.last!
            opens.remove(at: opens.count - 1)
            if let newPoint = vec.calcPoint{
                if let _ = blocks.firstIndex(where: {$0.x == newPoint.x && $0.y == newPoint.y}){
                    addClose(vec)
                }else{
                    paths.append(newPoint)
                    if newPoint == end{
                        return paths
                    }else{
                        let fullOpens = makeStartOpens(point: newPoint, end: end)
                        let realOpens = fullOpens.removeReverce(vec: vec)
                        addOpens(realOpens)
                    }
                }
            }else{
                addClose(vec)
            }
        }
        return nil
    }
}
