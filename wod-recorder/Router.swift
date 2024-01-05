//
//  Router.swift
//  wod-recorder
//
//  Created by Nicky Advokaat on 05/01/2024.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    static let shared: Router = Router()
}
