//
//  TopListData.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 10.01.2023.
//

import Foundation

struct TopListData{
    var scores: [Int]
}

extension TopListData{
    func save(){
        TopList.saveData(self)
    }
}

class TopList{
    static func setNewScore(score: Int){
        var data = loadData()
        data.scores.append(score)
        data.scores = data.scores.sorted { $0 > $1 }
        let newScores = data.scores.prefix(5)
        data.scores = newScores.compactMap { $0 } //{ $0 as? Int }
        data.save()
    }
    
    static func loadData() -> TopListData{
        let loadedScores = UserDefaults.standard.array(forKey: "scoresArray") as? [Int] ?? [0, 0, 0, 0, 0]
        return TopListData(scores: loadedScores)
    }
    
    static func saveData(_ data: TopListData){
        UserDefaults.standard.set(data.scores, forKey: "scoresArray")
    }
}
