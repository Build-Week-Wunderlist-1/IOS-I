//
//  Bearer.swift
//  LambdaList
//
//  Created by Cameron Collins on 4/29/20.
//  Copyright © 2020 iOS BW. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    var token: String
    var userId: Int
}
