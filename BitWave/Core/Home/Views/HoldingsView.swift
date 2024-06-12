//
//  HoldingsView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 10/07/2024.
//

import SwiftUI

struct HoldingsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var clickedCoin: Coin? = nil
    @State private var amountText: String = ""
    @State private var displaySave: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(search: $vm.search)
                        .background(Color.palette.backgroundColor)
                    holdingsViewCryptos
                    
                    if clickedCoin != nil {
                        holdingsInput
                    }
                    
                }
            }
            .navigationTitle("Update Holdings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    saveNavButton
                }
            }
            .overlay(savedOverlayView, alignment: .center)
            .background(Color.palette.backgroundColor.ignoresSafeArea())
            .onChange(of: vm.search) { oldValue, newValue in
                if newValue == "" {
                    discardSelectedCoin()
                }
            }
        }
    }
}

#Preview {
    HoldingsView()
        .environmentObject(SwiftUIPreview.instance.homeVM)
}

extension HoldingsView {
    private var holdingsViewCryptos: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.search.isEmpty ? vm.coinBalance : vm.coinList) { crypto in
                    HoldingsImageView(crypto: crypto)
                        .frame(width: 70)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCurrency(coin: crypto)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 11).stroke(clickedCoin?.id == crypto.id ? Color.secondary : Color.clear, lineWidth: 2))
                }
            }
            .frame(height: 115)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCurrency(coin: Coin) {
        clickedCoin = coin
       if let holdingsCurrency = vm.coinBalance.first(where: { $0.id == coin.id }),
          let amount = holdingsCurrency.activeHoldings {
           amountText = "\(amount)"
           
       } else {
           amountText = ""
       }
    }
    
    private func fetchCurrentValue() -> Double {
        if let amount = Double(amountText) {
            return amount * (clickedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    private var holdingsInput: some View {
        VStack(spacing: 17) {
            HStack {
                Text("Current Price of \(clickedCoin?.symbol.uppercased() ?? "N/A"):")
                Spacer()
                Text(clickedCoin?.currentPrice.decimalCurrency() ?? "Unavailable")
            }
            Divider()
            HStack {
                Text("Holdings Amount: ")
                Spacer()
                TextField("Ex: 1.0", text: $amountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(fetchCurrentValue().decimalCurrency())
            }
        }
        .animation(.none, value: fetchCurrentValue())
        .padding()
        .font(.headline)
    }
    private var saveNavButton: some View {
        HStack(spacing: 10) {
            Button(action: {
                saveButtonTouched()
            }, label: {
                Text("Save")
            })
            .opacity((clickedCoin != nil && clickedCoin?.activeHoldings != Double(amountText)) ? 1.0 : 0.0)
        }
        .font(.title2)
    }
    private func saveButtonTouched() {
        guard let crypto = clickedCoin, let amount = Double(amountText) else {
            return
        }
        vm.updateHoldings(coin: crypto, amount: amount)
        withAnimation(.easeIn) {
            displaySave = true
            discardSelectedCoin()
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut) {
                displaySave = false
            }
        }
    }
    private func discardSelectedCoin() {
        clickedCoin = nil
        vm.search = ""
    }
    private var savedOverlayView: some View {
        Group {
            if displaySave {
                Text("Saved")
                    .font(.largeTitle)
                    .padding()
                    .transition(.opacity)
            }
        }
    }
}

