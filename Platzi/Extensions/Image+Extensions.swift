//
//  Image+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/6/25.
//

import Foundation
import SwiftUI

extension Image {
    
    func placeholder(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .frame(width: width, height: height)
    }
    
}
