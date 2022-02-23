//
//  AppDelegate.swift
//  Investment tool
//
//  Created by Jan Cakl on 29.01.2022.
//

import Cocoa
import AppKit


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
    
    func errorReadingResults(question: String, text: String) -> Bool {

    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
    alert.alertStyle = .warning
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    @IBAction func importCSV(_ sender: Any) {
       
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["csv"]
        
        var files: [File]
        
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            for url in openPanel.urls{
                do{
                    var csvFile: Csv = Csv( url: url, rawData : try String(contentsOf: url, encoding: .utf8))
                    
                    print("Broker Name <\(csvFile.getBrokerName())>")
                    if(csvFile.getBrokerName() == BrokerName.unknown.rawValue){
                        let x = errorReadingResults(question: "Error.", text: "Broker is not supported")
                        return
                    }
                    
                    csvFile.setPublicData( data:&publicData )
                                        
                    let nc = NotificationCenter.default
                    
                    nc.post(name: kNotification, object: nil)
                }catch{
                    print("File error, path <\(url.path)>")
                }
            }
        }
    }
}

