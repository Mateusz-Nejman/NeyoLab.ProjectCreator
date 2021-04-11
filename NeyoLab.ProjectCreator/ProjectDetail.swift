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
                    var itemsToCopy: [String] = [];
                    for moduleIndex in project.modules {
                        
                        for itemToCopy in modules[moduleIndex].filesToCopy {
                            if(!itemsToCopy.contains(itemToCopy)) {
                                itemsToCopy.append(itemToCopy)
                            }
                        }
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
                    
                    progress = 1.0
                }) {
                    Text("Copy from base")
                }
                Button(action: {
                    let tick = 1.0/7.0
                    progress = 0.0
                    shell(command: "sh /Users/mateusz/.ssh/change_rsa_key.sh /Users/mateusz/.ssh/id_rsa_base", launchPath: nil)
                    let addBaseOutput = shell(command: "git add .", launchPath: nerpPath)
                    progress = tick
                    let commitBaseOutput = shell(command: "git commit -m \""+commitText+"\"", launchPath: nerpPath)
                    progress = tick * 2
                    let pushBaseOutput = shell(command: "git push origin master", launchPath: nerpPath)
                    progress = tick * 3
                    shell(command: "sh /Users/mateusz/.ssh/change_rsa_key.sh /Users/mateusz/.ssh/"+project.key, launchPath: nil)
                    let addOutput = shell(command: "git add .", launchPath: project.path.path)
                    progress = tick * 4
                    let commitOutput = shell(command: "git commit -m \""+commitText+"\"", launchPath: project.path.path)
                    progress = tick * 5
                    
                    let pushOutput = shell(command: "git push origin master", launchPath: project.path.path)
                    progress = tick * 6
                    
                    let ftpPushOutput = shell(command: "git ftp push", launchPath: project.path.path)
                    progress = tick * 7
                    
                    var outputs = ""
                    outputs = outputs + "Add\n" + addBaseOutput[addBaseOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Commit\n" + commitBaseOutput[commitBaseOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Push\n" + pushBaseOutput[pushBaseOutput[1] != "" ? 1 : 0]
                    
                    outputs = outputs + "\n\n\n\n"
                    
                    outputs = outputs + "Add\n" + addOutput[addOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Commit\n" + commitOutput[commitOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Push\n" + pushOutput[pushOutput[1] != "" ? 1 : 0]
                    outputs = outputs + "Ftp Push\n" + ftpPushOutput[ftpPushOutput[1] != "" ? 1 : 0]
                    
                    progress = 1.0
                    commitText = ""
                    repoStatusText = outputs
                }) {
                    Text("Push")
                }
                
                ProgressView (value: progress)
            }
        }
    }
}

struct ProjectDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetail(project: projects[0])
    }
}
