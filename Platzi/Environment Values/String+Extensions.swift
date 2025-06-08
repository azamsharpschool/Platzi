//
//  String+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
