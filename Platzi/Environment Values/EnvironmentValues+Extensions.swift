//
//  EnvironmentValues+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 6/8/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var showToast = ShowToastAction(action: { _ in })
}
