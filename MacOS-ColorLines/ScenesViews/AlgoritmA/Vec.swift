//
//  Vec.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 06.01.2023.
//

import Foundation

struct Vec{
    let point: Point
    let ort: Ort
}

extension Vec{
    var calcPoint: Point?{
        let new: Point = self.point + self.ort.point
        if new.x < 0 || new.y < 0 || new.x > 8 || new.y > 8{
            return nil
        }
        return new
    }
    
    static func ==(lhs: Vec, rhs: Vec) -> Bool {
        return lhs.point == rhs.point && lhs.ort == rhs.ort
    }
}

extension Vec{
    static func full(point: Point) -> [Vec]{
        var res = [Vec]()
        for ort in Ort.full(){
            res.append(Vec(point: point, ort: ort))
        }
        return res
    }
}

extension Array where Element == Vec {
    func remove(vec: Vec) -> [Vec]{
        if let index = self.firstIndex(where: {$0 == vec}){
            var temp = self
            temp.remove(at: index)
            return temp
        }
        return self
    }
    
    func removeReverce(vec: Vec) -> [Vec]{
        let reverce = vec.ort.reverce
        if let index = self.firstIndex(where: {$0.ort == reverce}){
            var temp = self
            temp.remove(at: index)
            return temp
        }
        return self
    }
}
