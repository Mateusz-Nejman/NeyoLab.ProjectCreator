//
//  ProjectListRow.swift
//  NeyoLab.ERP.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import SwiftUI

struct ProjectListRow: View {
    var projectModel: ProjectModel
    var body: some View {
        HStack {
            Text(projectModel.name)
            Text(String(projectModel.modules.count))
        }
    }
}

struct ProjectListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProjectListRow(projectModel: projects[0])
            ProjectListRow(projectModel: projects[1])
        }
    }
}
