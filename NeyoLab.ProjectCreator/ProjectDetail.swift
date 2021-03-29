//
//  ProjectDetail.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import SwiftUI

struct ProjectDetail: View {
    @State private var outputText: String = ""
    @State private var errorText: String = ""
    @State private var repoStatusText: String = ""
    @State private var commitText: String = ""
    @State private var progress = 0.0
    
    var project: ProjectModel
    
    var body: some View {
        List {
            HStack {
                Button(action:{
                    let output = shell(command: "git status", launchPath: project.path.path)
                    
                    if(output[1] == "") {
                        repoStatusText = output[0]
                    } else {
                        repoStatusText = output[1]
                    }
                }) {
                    Text("Status")
                }
                
                Text("Repo Status")
            }
            
            let statusScrollView = ScrollView {
                Text(repoStatusText)
            }
            statusScrollView.frame(height: 350)
            
            Text("Repo Commit")
            TextField("Commit name",text: $commitText)
            
            HStack {
                Button(action: {
                    progress = 0.0
                    for moduleIndex in project.modules {
                        var itemsToCopy: [String] = [];
                        
                        if(moduleIndex == 0) {
                            itemsToCopy = directoriesToCopy
                        }
                        
                        let steps = Double(itemsToCopy.count);
                        let step = 1.0 / steps
                        
                        do
                        {
                            for item in itemsToCopy {
                                if(fileManager.fileExists(atPath: "\(project.path.path)/\(item)/"))
                                            {
                                    try fileManager.removeItem(atPath: "\(project.path.path)/\(item)/")
                                            }
                                            
                                try fileManager.copyItem(atPath: "\(nerpPath)/\(item)/", toPath: "\(project.path.path)/\(item)/")
                                progress += step
                            }
                        }
                        catch
                        {
                            
                        }
                    }
                }) {
                    Text("Copy from base")
                }
                Button(action: {
                    let addOutput = shell(command: "git add .", launchPath: project.path.path)
                    let commitOutput = shell(command: "git commit -m \""+commitText+"\"", launchPath: project.path.path)
                    
                    let pushOutput = shell(command: "git push origin master", launchPath: project.path.path)
                    
                    let ftpPushOutput = shell(command: "git ftp push", launchPath: project.path.path)
                    
                    var outputs = "Add\n" + addOutput[addOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Commit\n" + commitOutput[commitOutput[1] != "" ? 1 : 0]
                    
                    outputs = outputs + "Push\n" + pushOutput[pushOutput[1] != "" ? 1 : 0]
                    
                    outputs = outputs + "Ftp Push\n" + ftpPushOutput[ftpPushOutput[1] != "" ? 1 : 0]
                    
                    
                    commitText = ""
                    repoStatusText = outputs
                }) {
                    Text("Push")
                }
                
                ProgressView (value: progress)
                
                Button(action: {
                    let output = shell(command: "git ftp", launchPath: project.path.path)
                    
                    repoStatusText = output[output[1] == "" ? 0 : 1]
                }) {
                    Text("Test")
                }
            }
        }
    }
}

struct ProjectDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetail(project: projects[0])
    }
}
