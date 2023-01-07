//
//  Point.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation

struct Point{
    let x: Int
    let y: Int
    
    static func +(lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
