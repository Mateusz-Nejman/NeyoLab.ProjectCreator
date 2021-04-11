//
//  ProjectModel.swift
//  NeyoLab.ERP.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import Foundation

struct ProjectModel: Hashable, Codable {
    var id: Int
    var name: String
    var path: URL
    var modules: [Int]
    var key: String
}
