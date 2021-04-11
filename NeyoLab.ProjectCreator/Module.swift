//
//  Module.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 31/03/2021.
//

import Foundation

struct Module {
    var id: Int = 0
    var name: String = ""
    var filesToCopy: [String] = []
    var requiredModules: [Int] = []
}
