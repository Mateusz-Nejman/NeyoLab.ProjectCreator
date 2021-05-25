//
//  Utils.swift
//  NeyoLab.ProjectCreator
//
//  Created by Mateusz Nejman on 27/03/2021.
//

import Foundation

let fileManager = FileManager.default
let rootDirectory = Bundle.main.bundleURL
let nerpPath = "/Users/mateusz/Projekty/neyolab.erp"

let modules: [Module] = [
    Module(id:0),
    Module(id:1, name:"Dashboard", filesToCopy: [
        "src/assets/css/dashboard",
        "src/assets/js/dashboard",
        "src/app/Entities/Dashboard",
        "src/app/Helpers/dashboard",
        "src/app/Libraries/Dashboard",
        "src/app/Models/Dashboard",
        "src/app/Validators/Dashboard",
        "src/app/Views/dashboard",
        "src/app/Controllers/Basesystem.php",
        "src/app/Controllers/Dashboard.php",
        "src/app/Controllers/Maintentance.php",
        "src/app/Controllers/Notes.php",
        "src/app/Controllers/PanelController.php",
        "src/app/Controllers/Start.php",
        "src/app/Controllers/Tasks.php"
    ]),
    Module(id:2, name:"Invoices", filesToCopy: [
        "src/app/Controllers/Invoices.php",
        "src/app/Entities/Invoices",
        "src/app/Helpers/invoices",
        "src/app/Models/Invoices",
        "src/app/Libraries/Invoices",
        "src/app/Validators/Invoices",
        "src/app/Views/invoices",
        "src/assets/js/invoices",
        "src/cron/invoiceCron.php"
    ], requiredModules: [1]),
    Module(id:3, name:"Shop Panel", filesToCopy: [
        "src/app/Controllers/Clients.php",
        "src/app/Controllers/Couriers.php",
        "src/app/Controllers/Deliveries.php",
        "src/app/Controllers/Idt.php",
        "src/app/Controllers/Orders.php",
        "src/app/Controllers/Products.php",
        "src/app/Controllers/Qrcodes.php",
        "src/app/Controllers/Scanner.php",
        "src/app/Controllers/Shipments.php",
        "src/app/Controllers/Shipping.php",
        "src/app/Entities/ShopPanel",
        "src/app/Models/ShopPanel",
        "src/app/Validators/ShopPanel",
        "src/app/Libraries/ShopPanel",
        "src/app/Views/shopPanel",
        "src/assets/js/shopPanel"
    ], requiredModules: [1, 2]),
    Module(id:4, name:"Dev Console", filesToCopy: [
        "src/app/Controllers/Console.php",
        "src/assets/js/console.js",
        "src/app/Views/console"
    ])
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

func isDirectory(path: String) -> Bool {
    var isDir : ObjCBool = false
    var exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir);
    return isDir.boolValue
}
