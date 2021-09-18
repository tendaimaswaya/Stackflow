//
//  Owner.swift
//  Stackflow
//
//  Created by Tendai Maswaya on 9/18/21.
//

import Foundation

struct Owner : Codable{
    let display_name,
        link,
        profile_image,
        user_type: String?
    
    let account_id,
        reputation,
        accept_rate,
        user_id: Int?
}
