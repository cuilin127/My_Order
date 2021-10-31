//
//  OrderMO+CoreDataProperties.swift
//
//
//  Created by Lin Cui on 2021-10-13.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
@objc(OrderMO)
final class OrderMO: NSManagedObject{
    @NSManaged var id: UUID?
    @NSManaged var type: String
    @NSManaged var size: String
    @NSManaged var quantity: Int
}
extension OrderMO{
    func convertToOrder() -> Order{
        Order(type: type, size: size, quantity: String(quantity))
    }
}
