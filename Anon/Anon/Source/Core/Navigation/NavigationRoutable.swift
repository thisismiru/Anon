//
//  NavigationRoutable.swift
//  Anon
//
//  Created by jeongminji on 8/23/25.
//

import Foundation

protocol NavigationRoutable {
    var destination: [NavigationDestination] { get set }
    func push(to view: NavigationDestination)
    func pop()
    func popToRooteView()
}

@Observable
class NavigationRouter: NavigationRoutable {
    var destination: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) {
        destination.append(view)
    }
    
    func pop() {
        _ = destination.popLast()
    }
    
    func popToRooteView() {
        destination = []
    }
}
