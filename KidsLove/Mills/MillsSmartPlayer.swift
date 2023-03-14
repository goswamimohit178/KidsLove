//
//  MillsSmartPlayer.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 05/03/23.
//


extension Array {
    var random: Element? {
        guard !isEmpty else {
            return nil
        }
        let randomIndex = Int.random(in: 0..<self.count)
        return self[randomIndex]
    }
}

extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
