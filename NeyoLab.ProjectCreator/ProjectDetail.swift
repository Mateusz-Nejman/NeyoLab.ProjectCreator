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
    @State private var progressTick = 1.0 / 7.0;
    
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
                    repoStatusText = ""
                    
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
                            var atPath = "\(nerpPath)/\(item)"
                            var toPath = "\(project.path.path)/\(item)"
                            
                            if isDirectory(path: atPath) {
                                atPath += "/"
                                toPath += "/"
                            }
                            
                            if(fileManager.fileExists(atPath: toPath))
                                        {
                                try fileManager.removeItem(atPath: toPath)
                                        }
                                        
                            try fileManager.copyItem(atPath: atPath, toPath: toPath)
                            
                            progress += step
                        }
                    }
                    catch
                    {
                        repoStatusText = "\(error)"
                    }
                    
                    progress = 1.0
                }) {
                    Text("Copy from base")
                }
                Button(action: {
                    progress = 0.0
                    var outputs = commitChanges(commitName: commitText, sshKeyName: "id_rsa_base", launchPath: nerpPath)
                    outputs += commitChanges(commitName: commitText, sshKeyName: project.key, launchPath: project.path.path)
                    
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
    
    func commitChanges(commitName: String, sshKeyName: String, launchPath: String) -> String {
        shell(command: "sh /Users/mateusz/.ssh/change_rsa_key.sh /Users/mateusz/.ssh/"+sshKeyName, launchPath: nil)
        
        let addOutput = shell(command: "git add .", launchPath: launchPath)
        progress += progressTick
        let commitOutput = shell(command: "git commit -m \""+commitName+"\"", launchPath: launchPath)
        progress += progressTick
        
        let pushOutput = shell(command: "git push origin master", launchPath: launchPath)
        progress += progressTick
        
        let ftpPushOutput = shell(command: "git ftp push", launchPath: launchPath)
        progress += progressTick
        
        var outputs = ""
        outputs = outputs + "Add\n" + addOutput[addOutput[1] != "" ? 1 : 0]
        outputs = outputs + "Commit\n" + commitOutput[commitOutput[1] != "" ? 1 : 0]
        outputs = outputs + "Push\n" + pushOutput[pushOutput[1] != "" ? 1 : 0]
        outputs = outputs + "Ftp push\n" + ftpPushOutput[ftpPushOutput[1] != "" ? 1 : 0]
        
        outputs = outputs + "\n\n\n\n"
        
        return outputs
    }
}

struct ProjectDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetail(project: projects[0])
    }
}
