//
//  Commands.swift
//  Basic
//
//  Created by Mark Beussink on 20181011.
//

import Foundation
import Utility

protocol Command {
    var command: String { get }
    var overview: String { get }
}

struct MessageCommand: Command {
    
    var command = "message"
    var overview = "Specify"
}
