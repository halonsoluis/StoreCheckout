//
//  ContentView.swift
//  Store
//
//  Created by Hugo Alonso on 18/04/2021.
//

import SwiftUI

struct Product: Identifiable {
    let id: String
    let name: String
    let price: Float
}

struct ContentView: View {
    let data: [Product] = [
        .init(id: "VOUCHER", name: "Voucher", price: 5),
        .init(id: "TSHIRT", name: "T-Shirt", price: 20),
        .init(id: "MUG", name: "Coffee Mug", price: 7.5),
    ]

    @State private var showingCheckout = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).edgesIgnoringSafeArea(.all)

                VStack {
                    List {
                        ForEach(data, content: CollectionView.init)
                    }
                    .navigationBarTitle("Products")
                    .padding(.bottom, 10)

                    Spacer()

                    Button {
                        showingCheckout.toggle()
                    } label: {
                        Text("Checkout")
                            .bold()
                            .frame(width: 280, height: 50)
                            .background(Color.white)
                            .font(.system(.headline))
                            .cornerRadius(3.0)
                    }.sheet(isPresented: $showingCheckout) {
                        CheckoutView(
                            totalCost: 22.5,
                            totalCostAfterReductions: 18.5,
                            appliedDiscounts: [
                                "Two For One",
                                "Bulk Discount"
                            ].map(SimpleOfferName.init))
                    }

                    Spacer()
                }
            }
        }
    }
}

struct CollectionView: View {
    let data: Product
    @State private var numberOfItems = 0

    var body: some View {

        VStack {
            HStack {
                Image(systemName: "camera.metering.unknown")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                Text(data.name)
                    .font(.title)
                    .bold()
                Spacer()
                Text(data.price.asCurrency())
                    .bold()
            }
            Section {
                Picker("I want to buy:", selection: $numberOfItems) {
                    ForEach(0 ..< 100) {
                        Text("\($0) \(data.name)(s)")
                    }
                }.padding(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().preferredColorScheme(.light)
                .previewDevice("iPhone 12")
                .environment(\.colorScheme, .light)
        }
    }
}

struct SimpleOfferName {
    let id = UUID()
    let name: String
}

struct CheckoutView: View {
    @Environment(\.presentationMode) var presentationMode

    let totalCost: Float
    let totalCostAfterReductions: Float
    let appliedDiscounts: [SimpleOfferName]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)

            VStack {
                Text("Checkout")
                    .bold()
                    .font(.system(.title))
                    .padding(.top)
                    .foregroundColor(.white)

                Divider()

                Spacer()

                HStack {
                    Text("Total Cost")
                    Spacer()
                    Text(totalCost.asCurrency())
                }.padding(.all)

                HStack {
                    Text("Total Cost After Discounts")
                    Spacer()
                    Text(totalCostAfterReductions.asCurrency())
                }.padding(.all)

                VStack {
                    HStack {
                        Text("Applied Discounts")
                        Spacer()
                    }
                    Divider()

                    List {
                        ForEach(appliedDiscounts, id: \.id) { offer in
                            Text(offer.name)
                        }
                    }
                    .background(Color.clear)
                    .padding(.bottom, 10)
                }.padding(.all)


                Spacer()

                Divider()

                Button("Go back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.title)
                .padding()
                .frame(width: 280, height: 50)
                .background(Color.white)
                .font(.system(.headline))
                .cornerRadius(3.0)
            }
        }
    }
}

extension Float {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
