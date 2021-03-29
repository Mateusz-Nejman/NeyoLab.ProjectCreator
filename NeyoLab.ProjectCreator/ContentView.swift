//
//  ContentView.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ProjectList()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
