//
//  AppDelegate.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        
        let rootPath: URL = URL(fileURLWithPath: "/Users/mateusz/Projekty/",isDirectory: true)
        print(rootPath.path)
        var currentId = 0;
        
        do
        {
            let rootContent = try FileManager.default.contentsOfDirectory(at: rootPath, includingPropertiesForKeys: nil, options: []);
            
            for file in rootContent {
                let isValid = FileManager.default.fileExists(atPath: file.path+"/src/") && FileManager.default.fileExists(atPath: file.path+"/Dockerfile") && FileManager.default.fileExists(atPath: file.path+"/neyolab.project")
                
                if file.hasDirectoryPath && isValid {
                    let modulesString = try String(contentsOfFile: file.path+"/neyolab.project")
                    let modulesArrayString = modulesString.split(separator: ";")
                    var modulesArray : [Int] = []
                    
                    for moduleString in modulesArrayString {
                        let module = Int(moduleString)
                        
                        if module != nil {
                            modulesArray.append(module!)
                        }
                    }
                    
                    projects.append(ProjectModel(id: currentId, name: file.lastPathComponent, path: file, modules: modulesArray))
                    currentId = currentId + 1
                }
            }
        }
        catch
        {
            
        }
        
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

