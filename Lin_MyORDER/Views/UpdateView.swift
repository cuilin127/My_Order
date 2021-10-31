//
//  UpdateView.swift
//  Lin_MyORDER
//
//  Created by Lin Cui on 2021-10-13.
//

import SwiftUI

struct UpdateView: View {
    let selectedIndex : Int
    @State private var quantity : String = "0"
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    @EnvironmentObject var coreDBHelper : CoreDBHelper
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("Modify this quantity:")
            TextField("Enter Quantity Here", text: $quantity)
                .foregroundColor(.red)
                .keyboardType(.decimalPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
            Button("Submit"){
                if(quantity==""||quantity=="0"){
                    alertMessage = "Invalid Input for Quantity!"
                    showingAlert = true
                }else{
                    alertMessage = "Order added"
                    updateRecord()
                    showingAlert = true
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
        .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width, minHeight: nil, idealHeight: nil, maxHeight: 300, alignment: .center)
        .onAppear(){quantity = String(coreDBHelper.orderList[selectedIndex].quantity)}
    }
    public func updateRecord(){
        self.coreDBHelper.orderList[selectedIndex].quantity = Int(quantity)!
        self.coreDBHelper.updateOrder(updatedOrder: self.coreDBHelper.orderList[selectedIndex])
        self.presentationMode.wrappedValue.dismiss()
    }
}

