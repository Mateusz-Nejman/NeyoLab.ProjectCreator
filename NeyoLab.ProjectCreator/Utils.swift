//
//  Utils.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import Foundation

let fileManager = FileManager.default
let rootDirectory = Bundle.main.bundleURL
let nerpPath = "/Users/mateusz/Projekty/nerp"

let directoriesToCopy = [
    "src/assets",
    "src/app/Entities",
    "src/app/Controllers",
    "src/app/Helpers",
    "src/app/Libraries",
    "src/app/Models",
    "src/app/Views",
    "src/app/Validators",
    "src/config"
]

func shell(command: String, launchPath: String?) -> [String] {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["bash", "-c", (launchPath != nil ? "cd "+(launchPath!)+"/src; " : "")+command]
    task.environment = ["$PATH":"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/users/mateusz/.npm-global/bin:/usr/local/share/dotnet:~/.dotnet/tools:/Library/Apple/usr/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    let pipeError = Pipe()
    task.standardError = pipeError
    
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let returnData = String(data: data, encoding: String.Encoding.utf8)
    
    let errorData = pipeError.fileHandleForReading.readDataToEndOfFile()
    let errorReturnData = String(data: errorData, encoding: String.Encoding.utf8)
    
    return [returnData ?? "", errorReturnData ?? ""]
}
