//
//  AppDelegate.swift
//  Investment tool
//
//  Created by Jan Cakl on 29.01.2022.
//

import Cocoa


@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var publicData: [[String: String]] = [[:]]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    
    @IBAction func importCSV(_ sender: Any) {
       
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedFileTypes = ["csv"]
        
        var files: [File]
        
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            for url in openPanel.urls{
                do{
                    var csvFile: Csv = Csv( url: url, rawData : try String(contentsOf: url, encoding: .utf8))
                    
                    
                    print("Broker Name <\(csvFile.getBrokerName())>")
                    
                    csvFile.setPublicData( data:&publicData )
                    
                    print(publicData)
                    
                    let nc = NotificationCenter.default
                    
                    nc.post(name: kNotification, object: nil)
                    
                    
                }catch{
                    print("File error, path <\(url.path)>")
                }
            }
        }
    }
}

