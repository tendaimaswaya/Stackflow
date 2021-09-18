//
//  URLs.swift
//  Stackflow
//
//  Created by Tendai Maswaya on 9/18/21.
//

import Foundation


extension URL{
    static private  let apiKey = "REPLACE_WITH_YOUR_STACK_EXCHANGE_KEY"
    static private  let baseUrl = "https://api.stackexchange.com/2.3/"
    
    static func questions(for section: String, page: Int) -> URL{
        URL(string: "\(baseUrl)\(section)?key=\(apiKey)&site=stackoverflow&order=DESC&sort=activity&page=\(page)")!
    }   
}

