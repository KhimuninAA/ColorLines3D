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
    
    private static func makeStartOpens(point: Point, end: Point, isRnd: Bool) -> [Vec]{
        var vec = [Vec]()
        let orts: [Ort]
        if isRnd{
            orts = Ort.random()
        }else{
            orts = getOrts(from: point, to: end)
        }
        for ort in orts{
            vec.append(Vec(point: point, ort: ort))
        }
        return vec
    }
    
    static func getPath(start: Point, end: Point, blocks: [Point]) -> [Point]?{
        var arr = AlgAArray(start: start, end: end, blocks: blocks, data: [AlgAData]())
        let vecs = Vec.full(point: start)
        for vec in vecs{
            let data = AlgAData(id: 0, closed: [Vec](), opens: vecs, full: [Vec](), paths: [start], nextVec: vec)
            arr.data.append(data)
        }
        return nextArray(arr)
    }
    
    static func nextArray(_ array: AlgAArray) -> [Point]?{
        var tempArray = array
        for dataIndex in 0..<tempArray.data.count{
            let vec = tempArray.data[dataIndex].nextVec
            tempArray.data[dataIndex].opens = tempArray.data[dataIndex].opens.remove(vec: vec)
            if let newPoint = vec.calcPoint{
                if let _ = tempArray.blocks.firstIndex(where: {$0.x == newPoint.x && $0.y == newPoint.y}){
                    tempArray.data[dataIndex].addClosed(vec: vec)
                }else{
                    
                }
            }
            else{
                tempArray.data[dataIndex].addClosed(vec: vec)
            }
        }

        
        //print(array)
        return nil
    }
    
    static func getPath(start: Point, end: Point, blocks: [Point], isRnd: Bool = false) -> [Point]?{
        var closed: [Vec] = [Vec]()
        var opens: [Vec] = makeStartOpens(point: start, end: end, isRnd: isRnd)
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
                        let fullOpens = makeStartOpens(point: newPoint, end: end, isRnd: isRnd)
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
