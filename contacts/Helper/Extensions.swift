//
//  Extensions.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }

    func isNumbers() -> Bool {
        if let _ = Int(self) {
            return true
        } else {
            return false
        }
    }
    
}

extension Contact {
    var fullName: String {
        get {
            return "\(self.firstName ?? "") \(self.lastName ?? "")"
        }
    }
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}
