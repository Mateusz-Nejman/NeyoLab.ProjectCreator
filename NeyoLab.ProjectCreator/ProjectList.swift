//
//  ProjectList.swift
//  NeyoLab.ERP.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import SwiftUI

struct ProjectList: View {
    var body: some View {
        NavigationView {
            List(projects, id: \.id) { project in
                NavigationLink(destination: ProjectDetail(project: project)) {
                    ProjectListRow(projectModel: project)
                }
            }
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
    }
}
