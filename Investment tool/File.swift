//
//  File.swift
//  Investment tool
//
//  Created by Jan Cakl on 05.02.2022.
//

import Foundation
import Cocoa

enum FileType: String, CaseIterable  {
    case csv = "csv"
    case txt = "txt"
    case unknown = "unknown"
}

enum Separator: String.Element, CaseIterable {
    case comma = ","
    case eof = "\n"
    case space = " "
}

enum Action: String, CaseIterable{
    case unknown = "unknown"
}

enum Column: String,CaseIterable{
    case broker = "broker"
    case ticker = "ticker"
    case name = "name"
    case cntOfShares = "cnt_of_shares"
    case sharePrice = "share_price"
    case currencyShare = "currency_share"
    case total = "total"
    case witholdingTax = "witholding_tax"
    case currencyTax = "currency_tax"
    case chargeAmount = "charge_amount"
}

enum ColumnPositionTr212: Int, CaseIterable{
    case ticker = 3
    case name = 4
}

func getItemSeparator( fileType: FileType ) -> Separator{
    switch( fileType ){
        case FileType.csv:
            return Separator.comma
        default:
            return Separator.space
    }
}

class File{
    fileprivate var url = URL(string: "")
    fileprivate var rawData = ""
    
    init( url:URL, rawData:String ){
        self.rawData = rawData
        self.url = url
    }
    
    public func getRawData( ) -> String{
        return rawData
    }
}

struct Data {
    var header = ""
    var lines = [String]()
}

struct DataContain{
    //var action = [Action]()
    var brokerName = [BrokerName]()
    var ticker = [String]()
}

class Csv:File{
    private let separatorItemInLine:String.Element = ","
    private let lineSeparator:String.Element = "\n"
    fileprivate var fileData = Data()
    fileprivate var broker = Broker()
    
    override init(url: URL, rawData: String) {
        
        super.init(url: url, rawData: rawData)
        
        // set file data - header and lines
        for line in self.rawData.split(separator: lineSeparator) {
            if( fileData.header.isEmpty ){
                fileData.header = String(line)
            }else{
                fileData.lines.append(String(line))
            }
        }
        
        // set broker data
        broker.identifyTypeOfBroker( header: fileData.header )
        switch( broker.getName() ){
            case BrokerName.trading212: broker = Trading212(currency: Currency.czk)
            default: broker = Broker()
        }
    }
    
    public func getHeader() -> String{
        return fileData.header
    }
    
    public func getBrokerName() -> BrokerName.RawValue{
        return broker.getBrokerType(type: broker).rawValue
    }
    
    public func getNumberOfLines() -> Int{
        return fileData.lines.count
    }
    
    public func setPublicData( data: inout [[String: String]] ){
        var lineCounter = 0
        data.removeAll()
        for line in fileData.lines {
            var itemCounter = 0
            data.append([Column.broker.rawValue : getBrokerName(), Column.ticker.rawValue : "", Column.name.rawValue : ""] )
            for item in line.split(separator:  getItemSeparator(fileType: FileType.csv).rawValue, omittingEmptySubsequences: false){
                /*switch(itemCounter){
                    case  ColumnPositionTr212.ticker.rawValue:
                        data[lineCounter].updateValue(String(item), forKey: Column.ticker.rawValue)
                    case ColumnPositionTr212.name.rawValue:
                        data[lineCounter].updateValue(String(item), forKey: Column.name.rawValue)
                default:
                    continue
                }*/
                
                if( itemCounter == 3 ){
                    data[lineCounter].updateValue(String(item), forKey: Column.ticker.rawValue)
                }else if( itemCounter == 4 ){
                    data[lineCounter].updateValue(String(item).replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil), forKey: Column.name.rawValue)
                }
                
                
                itemCounter += 1
                //print(itemCounter)
            }
            lineCounter += 1
        }
    }
}
