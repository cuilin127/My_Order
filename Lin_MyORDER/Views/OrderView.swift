//
//  OrderView.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-09-22.
//  Student ID: 991456394

import SwiftUI
import UIKit
var orderList:[Order] = []

struct OrderView: View {
    private var types = ["dark roast","original blend","vanilla"]
    private var sizes = ["Small","Medium","Large"]
    @State private var coffeeType : String = "dark roast"
    @State private var coffeeSize : String = "Small"
    @State private var quantity : String = "0"
    @State private var selection: Int? = nil
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    @EnvironmentObject var coreDBHelper : CoreDBHelper
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: DisplayView(orderList:orderList), tag: 1, selection: $selection) {}
                List{
                    HStack {
                        Picker("Coffee Type", selection: $coffeeType, content: {
                            ForEach(types, id: \.self, content: { type in
                                Text(type)
                            })
                        })
                    }
                    HStack {
                        Picker("Coffee size",selection: $coffeeSize, content: {
                            ForEach(sizes, id: \.self, content: { size in
                                Text(size)
                            })
                        })
                    }
                    HStack(){
                        Text("Quantity:")
                        Spacer()
                        
                        TextField("Enter Quantity Here", text: $quantity)
                            .foregroundColor(.red)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        
                    }
                    
                    Button("Submit"){
                        if(quantity==""||quantity=="0"){
                            alertMessage = "Invalid Input for Quantity!"
                            showingAlert = true
                        }else{
                            alertMessage = "Order added"
                            showingAlert = true
                            addToList()
                            addNewOrder()
                            self.coreDBHelper.getAllOrders()
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: 300, alignment: .center)
                    .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                            }
                }
            }
            .navigationBarTitle("Make a Order", displayMode: .inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("View Orders") {
                        self.selection = 1
                        
                    }
                }
            }
        }
    }
    private func addToList(){
        orderList.append(Order(type: coffeeType, size: coffeeSize, quantity: quantity))
    }
    private func addNewOrder(){
        self.coreDBHelper.insertTask(order: Order(type: self.coffeeType, size: self.coffeeSize, quantity: self.quantity))
    }
}
struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderView()
        }
    }
}
