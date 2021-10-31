//
//  DisplayView.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-09-22.
//  Student ID: 991456394

import SwiftUI

struct DisplayView: View {
    var orderList:[Order] = []
    @EnvironmentObject var coreDBHelper : CoreDBHelper
    @State private var selectedIndex : Int = -1
    @State private var selection : Int? = nil
    
    var body: some View {
        NavigationLink(destination: UpdateView(selectedIndex:selectedIndex) , tag: 2, selection: $selection) {}
        List {
            HStack{
                Text("Coffee Type")
                Spacer()
                Text("Size")
                Spacer()
                Text("Quantity")
            }
            ForEach(self.coreDBHelper.orderList.enumerated().map({$0}), id: \.element.self) { indx,order in
                HStack{
                    Text(order.type)
                    Spacer()
                    Text(order.size)
                    Spacer()
                    Text(String(order.quantity))
                }
                .onTapGesture {
                    self.selectedIndex = indx
                    self.selection = 2
                    print(#function, "\(self.coreDBHelper.orderList[selectedIndex].id) selected")
                }
                
            }
            .onDelete(perform: { indexSet in
                for index in indexSet{
                    print(#function, "Order to delete : \(String(describing: self.coreDBHelper.orderList[index].id))")
                    self.coreDBHelper.deleteOrder(orderID:  self.coreDBHelper.orderList[index].id!)
                    self.coreDBHelper.orderList.remove(at: index)
                }
            })
        }.onAppear(){
            self.coreDBHelper.getAllOrders()
        }
    }
}


struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}
