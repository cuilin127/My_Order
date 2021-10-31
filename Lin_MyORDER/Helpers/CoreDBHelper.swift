//
//  CoreDBHelper.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-10-12.
//

import Foundation
import CoreData
import UIKit

class CoreDBHelper: ObservableObject{
    @Published var orderList = [OrderMO]()
    
    private static var shared : CoreDBHelper?
    static func getInstance() -> CoreDBHelper {
        if shared != nil{
            //instance of CoreDBHelper class already exists, so return the same
            return shared!
        }else{
            //there is no existing instance of CoreDBHelper class, so create new and return
            shared = CoreDBHelper(context: PersistenceController.preview.container.viewContext)
            
            return shared!
        }
    }
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "OrderMO"
    
    init(context: NSManagedObjectContext){
        self.moc = context
    }
    
    func insertTask(order: Order){
        do{
            
            let orderToBeInserted = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! OrderMO
            
            orderToBeInserted.type = order.type
            orderToBeInserted.size = order.size
            orderToBeInserted.quantity = Int(order.quantity) ?? 0
            orderToBeInserted.id = UUID()
            
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data is saved successfully")
            }
            
        }catch let error as NSError{
            print(#function, "Could not save the data \(error)")
        }
    }
    func getAllOrders(){
        let fetchRequest = NSFetchRequest<OrderMO>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "type", ascending: true)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Number of records fetched : \(result.count)")
            self.orderList.removeAll()
            self.orderList.insert(contentsOf: result, at: 0)
            
        }catch let error as NSError{
            print(#function, "Could not fetch data from Database \(error)")
        }
    }
    private func searchOrder(orderID : UUID) -> OrderMO?{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", orderID as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first as? OrderMO
            }
        }catch let error as NSError{
            print(#function, "Unable to search for data \(error)")
        }
        
        return nil
        
    }
    func deleteOrder(orderID : UUID){
        let searchResult = self.searchOrder(orderID: orderID)
        
        if (searchResult != nil){
            //matching object found
            do{
                self.moc.delete(searchResult!)
                
                
                try self.moc.save()
                objectWillChange.send()
                print(#function, "Data deleted successfully")
            }catch let error as NSError{
                print(#function, "Couldn't delete data \(error)")
            }
        }else{
            print(#function, "No matching record found")
        }
    }
    func updateOrder(updatedOrder: OrderMO){
        let searchResult = self.searchOrder(orderID: updatedOrder.id! as UUID)
        
        if (searchResult != nil){
            //matching object found
            do{
                let orderToUpdate = searchResult!
                
                orderToUpdate.type = updatedOrder.type
                orderToUpdate.size = updatedOrder.size
                orderToUpdate.quantity = updatedOrder.quantity
                
                
                try self.moc.save()
                objectWillChange.send()
                print(#function, "Data Updated Successfully")
                
            }catch let error as NSError{
                print(#function, "Unable to update data \(error)")
            }
        }else{
            print(#function, "No matching data found")
        }
    }
}
