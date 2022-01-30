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
        var headerPositions: [[Int32: String]] = [[:]]
        var cellStructure: [[String]] = []
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
    
    func checkHeader( header : String, file : inout File){
        
        // TODO: set currency via UI
        let currency = "CZK"
        
        let headerTrading212 = ["Action", "Time", "ISIN", "Ticker", "Name", "No. of shares", "Price / share" , "Currency (Price / share)", "Exchange rate", "Result (\(currency))", "Total (\(currency))", "Withholding tax", "Currency (Withholding tax)", "Charge amount (\(currency))", "Deposit fee (\(currency))", "Notes", "ID", "Currency conversion fee (\(currency))"]
        
        let columns = header.split(separator: ",", omittingEmptySubsequences: false)
        
        for broker in BrokerName.allCases {
            var colIter: Int32 = 0
            for column in columns {
                if !headerTrading212.contains(String(column)) {
                    break
                }else{
                    file.headerPositions.append([colIter:String(column)])
                }
            }
            file.broker.name = broker.rawValue
            return
        }
        file.broker.name = BrokerName.unknown.rawValue
    }
    
    func parseCSVfile( csvFile : String, file : inout File ) -> Bool {
        let lines = csvFile.split(separator: "\n")
    
        //var file = File()
        print("Line cnt <\(lines.count)>")

        checkHeader( header : String(lines[0]), file : &file )
        
        print("Broker name is <\(file.broker.name)>")
        
        var lineIter: Int = 0
        for line in lines.dropFirst() {
            let columns = line.split(separator: ",", omittingEmptySubsequences: false)
            file.cellStructure.append([])

            for column in columns {
                file.cellStructure[lineIter].append(String(column))
            }
            lineIter += 1
        }
        return true
    }
    
    func processCsvFile( panel: NSOpenPanel, file : inout File ) -> Bool {
        var csvData = ""
        for url in panel.urls{
            do{
                csvData = try String(contentsOf: url, encoding: .utf8)
                if( !parseCSVfile( csvFile: csvData, file : &file ) ){
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
        
        var file: File = File()
        
        if (openPanel.runModal() == NSApplication.ModalResponse.OK) {
            if( processCsvFile( panel : openPanel, file : &file ) ){
                print("CNT \(file.cellStructure.count)")
                for structure in file.cellStructure{
                    
                    print("Structure \(structure)")
                    
                    for str in structure{
                        print("Data \(str)")
                    }
                }
                print("CSV file(s) are imported correctly")
            }else{
                print("CSV file(s) are not imported correctly")
            }
        }
        
        
    }
    

}

