//
//  Order.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-09-27.
//  Student ID: 991456394

import Foundation


class Order{
    var id = UUID()
    var type: String
    var size: String
    var quantity: String
    init(type: String,size:String,quantity:String) {
        self.type = type
        self.size = size
        self.quantity = quantity
    }
    
}
