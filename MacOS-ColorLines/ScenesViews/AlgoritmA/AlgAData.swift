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
    var data: [AlgAData]
}

struct AlgAData{
    let id: Int
    var closed: [Vec]
    var opens: [Vec]
    var full: [Vec]
    var paths: [Point]
    var nextVec: Vec
}

extension AlgAData{
    mutating func addClosed(vec: Vec){
        self.closed.append(vec)
    }
}
