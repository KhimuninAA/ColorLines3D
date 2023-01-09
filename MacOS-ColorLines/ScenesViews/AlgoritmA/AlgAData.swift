//
//  AlgAData.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 08.01.2023.
//

import Foundation

struct AlgAArray{
    let start: Point
    let end: Point
    let blocks: [Point]
    var full: [Vec]
    var data: [AlgAData]
    var nextID: Int
}

extension AlgAArray{
    mutating func addFull(vec: Vec){
        self.full.append(vec)
    }
    
    mutating func addData(data: AlgAData){
        if let _ = full.firstIndex(where: {$0 == data.nextVec}){
        }else{
            self.data.append(data)
            addFull(vec: data.nextVec)
        }
    }
    
    mutating func getNextID() -> Int{
        self.nextID += 1
        return self.nextID
    }
    
    func isFinish(point: Point) -> Bool{
        return point == end
    }
}

struct AlgAData{
    let id: Int
    var paths: [Point]
    var nextVec: Vec
}
