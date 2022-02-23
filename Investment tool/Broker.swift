//
//  Broker.swift
//  Investment tool
//
//  Created by Jan Cakl on 05.02.2022.
//

import Foundation

enum BrokerName: String, CaseIterable  {
    case trading212 = "Trading 212"
    case revolut = "Revolut"
    case degiro = "Degiro"
    case unknown = "Unknown"
}

enum Currency: String, CaseIterable{
    case czk = "CZK"
    case unknown = "UNKNOWN"
}

let currency = Currency.czk.rawValue

class ColData {
    private var mData: String
    private var mColumn: Column
    private var mPosition: Int
    
    init(data: String, column: Column, positio: Int){
        mData = data
        mColumn = column
        mPosition = positio
    }
    
    func getData()-> String{
        return mData
    }
    func getPosition()-> Int{
        return mPosition
    }
    func getColumn()-> Column{
        return mColumn
    }
}

let colDataTrading212 = [ ColData(data: "Action", column: Column.action, positio: 0),
                          ColData(data: "Time", column: Column.time, positio: 1 ),
                          ColData(data: "ISIN", column: Column.isin, positio: 2 ),
                          ColData(data: "Ticker", column: Column.ticker, positio: 3 ),
                          ColData(data: "Name", column: Column.name, positio: 4 ),
                          ColData(data: "No. of shares", column: Column.cntOfShares, positio: 5 ),
                          ColData(data: "Price / share", column: Column.sharePrice, positio: 6 ),
                          ColData(data: "Currency (Price / share)", column: Column.currencyShare, positio: 7 ),
                          ColData(data: "Exchange rate", column: Column.exRate, positio: 8 ),
                          ColData(data: "Result (\(currency))", column: Column.result, positio: 9 ),
                          ColData(data: "Total (\(currency))", column: Column.total, positio: 10 ),
                          ColData(data: "Withholding tax", column: Column.witholdingTax, positio: 11 ),
                          ColData(data: "Currency (Withholding tax)", column: Column.currencyTax, positio: 12 ),
                          ColData(data: "Charge amount (\(currency))", column: Column.chargeAmount, positio: 13 ),
                          ColData(data: "Deposit fee (\(currency))", column: Column.depositFee, positio: 14 ),
                          ColData(data: "Notes", column: Column.note, positio: 15 ),
                          ColData(data: "ID", column: Column.id, positio: 16 ),
                          ColData(data: "Currency conversion fee (\(currency))", column: Column.currencyConvFee, positio: 17 )]
 
class Broker{
    private var name = BrokerName.unknown
    fileprivate var headersOfBrokers = [(code:BrokerName, list: [ColData])]()
    
    init() {
        headersOfBrokers.append((BrokerName.trading212, list:colDataTrading212))
    }
    
    public func isColInList(list: [ColData], cmpVal: String) -> Bool{
        for item in list{
            if( item.getData() == cmpVal ){
                return true;
            }
        }
        return false
    }
    
    public func identifyTypeOfBroker( header:String ){
        for broker in headersOfBrokers{
            name = broker.code
            var iter: Int = 0
            for headItem in header.split(separator: getItemSeparator(fileType: FileType.csv).rawValue){
                if(!isColInList(list: broker.list, cmpVal: String(headItem)))
                {
                    name = BrokerName.unknown
                    break;
                }
                iter += 1
            }
        }
    }
    
    public func getHeader() ->[ColData]{
        for head in headersOfBrokers{
            if( head.code == self.getBrokerType() ){
                return head.list
            }
        }
        return [ColData.init(data: "", column: Column.unk, positio: 0)]
    }
    
    public func getName() -> BrokerName{
        return name
    }
    
    public func getBrokerType() -> BrokerName{
        if( self is Trading212 ){
            return BrokerName.trading212
        }
        
        return BrokerName.unknown
    }
}

class Trading212:Broker{
    fileprivate var currency = Currency.unknown
    
    init( currency:Currency ){
        self.currency = currency
        super.init()
        headersOfBrokers.removeAll()
        headersOfBrokers.append((BrokerName.trading212, list:colDataTrading212))
    }
}
