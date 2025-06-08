//
//  Array+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import Foundation

extension Array where Element == String {
    func joinedWithNewlines() -> String {
        self.joined(separator: "\n")
    }
}
