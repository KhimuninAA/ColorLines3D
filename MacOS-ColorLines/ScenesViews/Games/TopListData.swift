//
//  TopListData.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 10.01.2023.
//

import Foundation

struct TopListData{
    let scores: [Int]
}

extension TopListData{
    func save(){
        TopList.saveData(self)
    }
}

class TopList{
    static func loadData() -> TopListData{
        let loadedScores = UserDefaults.standard.array(forKey: "scoresArray") as? [Int] ?? [0, 0, 0, 0, 0]
        return TopListData(scores: loadedScores)
    }
    
    static func saveData(_ data: TopListData){
        UserDefaults.standard.set(data.scores, forKey: "scoresArray")
    }
}
