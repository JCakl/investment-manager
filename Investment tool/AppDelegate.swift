//
//  AppDelegate.swift
//  Investment tool
//
//  Created by Jan Cakl on 29.01.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    enum BrokerName: String, CaseIterable  {
        case trading212 = "Trading212"
        case revolut = "Revolut"
        case degiro = "Degiro"
        case unknown = "Unknown"
    }
    
    struct Broker {
        var name = BrokerName.unknown.rawValue
    }
    
    class File{
        var broker = Broker()
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func checkHeader( header : String ) -> BrokerName.RawValue {
        
        // TODO: set currency via UI
        let currency = "CZK"
        
        let headerTrading212 = ["Action", "Time", "ISIN", "Ticker", "Name", "No. of shares", "Price / share" , "Currency (Price / share)", "Exchange rate", "Result (\(currency))", "Total (\(currency))", "Withholding tax", "Currency (Withholding tax)", "Charge amount (\(currency))", "Deposit fee (\(currency))", "Notes", "ID", "Currency conversion fee (\(currency))"]
        
        let columns = header.split(separator: ",", omittingEmptySubsequences: false)
        
        for broker in BrokerName.allCases {
            for column in columns {
                if !headerTrading212.contains(String(column)) {
                    break
                }
            }
            return broker.rawValue
        }
        
        return BrokerName.unknown.rawValue
    }
    
    func parseCSVfile( csvFile : String ) -> Bool {
        let lines = csvFile.split(separator: "\n")
        
        var broker = Broker()
        broker.name = checkHeader( header : String(lines[0]) )
        
        print("Broker name is <\(broker.name)>")
        
        for line in lines.dropFirst() {
            let columns = line.split(separator: ",", omittingEmptySubsequences: false)
            
            // TODO: process columnsß
            /*for column in columns {
                
            }*/
            
        }
        return true
    }
    
    func processCsvFile( panel: NSOpenPanel ) -> Bool {
        var csvData = ""
        for file in panel.urls{
            do{
                csvData = try String(contentsOf: file, encoding: .utf8)
                if( !parseCSVfile( csvFile: csvData ) ){
                    return false
                }
            }catch{
                return false
            }
        }
        return true
    }
    
    @IBAction func importCSV(_ sender: Any) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedFileTypes = ["csv"]
        
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            if( processCsvFile( panel : openPanel ) ){
                print("CSV file(s) are imported correctly")
            }else{
                print("CSV file(s) are not imported correctly")
            }
        }
        
        
    }
    

}

