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

let currency = "CZK"

private var headersOfBrokers:[BrokerName:[String]] = [
    BrokerName.trading212: ["Action",
                            "Time",
                            "ISIN",
                            "Ticker",
                            "Name",
                            "No. of shares",
                            "Price / share" ,
                            "Currency (Price / share)",
                            "Exchange rate",
                            "Result (\(currency))",
                            "Total (\(currency))",
                            "Withholding tax",
                            "Currency (Withholding tax)",
                            "Charge amount (\(currency))",
                            "Deposit fee (\(currency))",
                            "Notes",
                            "ID",
                            "Currency conversion fee (\(currency))"]
]


class Broker{
    private var name = BrokerName.unknown
    
    public func identifyTypeOfBroker( header:String ){
        for broker in headersOfBrokers{
            name = broker.key
            for headItem in header.split(separator: getItemSeparator(fileType: FileType.csv).rawValue){
                
                if( !broker.value.contains(String(headItem)) ){
                    name = BrokerName.unknown
                    break
                }
            }
        }
    }
    
    public func getName() -> BrokerName{
        return name
    }
    
    public func getBrokerType( type:Any ) -> BrokerName{
        
        if( type is Trading212 ){
            return BrokerName.trading212
        }
        
        return BrokerName.unknown
    }
}

class Trading212:Broker{
    fileprivate var currency = Currency.unknown
    
    
    init( currency:Currency ){
        self.currency = currency
    }
}
