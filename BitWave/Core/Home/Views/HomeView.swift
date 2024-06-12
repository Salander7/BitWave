//
//  HomeView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 13/06/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var displayHoldings: Bool = false
    @State private var displayHoldingsView: Bool = false
    @State private var displaySettingsView: Bool = false

    var body: some View {
        ZStack {
            Color.palette.backgroundColor.ignoresSafeArea()
                .sheet(isPresented: $displayHoldingsView) {
                    HoldingsView()
                        .environmentObject(vm)
                }
            VStack {
                homeHeader
                HomeMetricsView(displayHoldings: $displayHoldings)
                SearchBarView(search: $vm.search)
                columnTitles
                if !displayHoldings {
                    coinsList
                        .transition(.move(edge: .leading))
                        .refreshable {
                            vm.refreshCoins()
                        }
                } else {
                    ZStack(alignment: .top) {
                        if vm.coinBalance.isEmpty && vm.search.isEmpty {
                            holdingsEmptyMessage
                        } else {
                                balanceList
                        }
                    }
                   
                        .transition(.move(edge: .trailing))
                        .refreshable {
                            vm.refreshCoins()
                        }
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $displaySettingsView, content: {
                SettingsView()
            })
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden, for: .navigationBar)
    }
    .environmentObject(SwiftUIPreview.instance.homeVM)
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            RoundButtonView(iconName: displayHoldings ? "plus" : "text.alignleft")
                .onTapGesture {
                    if displayHoldings {
                        displayHoldingsView.toggle()
                    } else {
                        displaySettingsView.toggle()
                    }
                }
                .background(RoundButtonAnimationView(animate: $displayHoldings))
            Spacer()
            Text(displayHoldings ? "Holdings" : "Real-Time Prices")
                .font(.headline)
                .foregroundStyle(Color.palette.accentColor)
            Spacer()
            RoundButtonView(iconName: "chevron.right.2")
                .rotationEffect(Angle(degrees: displayHoldings ? 180 : 0))
                .onTapGesture {
                    withAnimation(.snappy()) {
                        displayHoldings.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var coinsList: some View {
        List {
            ForEach(vm.coinList) { coin in
                NavigationLink(
                    destination: ClickedCoinView(coin: coin)
                        .onAppear {
                            print("Coin \(coin.name) was clicked.")
                        }
                ) {
                    BitWaveRowView(coin: coin, displayBalanceColumn: false)
                }
                .listRowBackground(Color.palette.backgroundColor)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }

    private var balanceList: some View {
        List {
            ForEach(vm.coinBalance) { coin in
                NavigationLink(
                    destination: ClickedCoinView(coin: coin)
                        .onAppear {
                            print("Coin \(coin.name) was clicked.")
                        }
                ) {
                    BitWaveRowView(coin: coin, displayBalanceColumn: true)
                }
                .listRowBackground(Color.palette.backgroundColor)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    private var holdingsEmptyMessage: some View {
        Text("Your portfolio is currently empty. Tap the "+" button to add your first coin and start building it! 🤠")
            .font(.callout)
            .foregroundStyle(Color.palette.accentColor)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(100)
    }

    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "arrow.down")
                    .opacity((vm.sortedCoins == .order || vm.sortedCoins == .reversedOrder) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortedCoins == .order ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortedCoins = vm.sortedCoins == .order ? .reversedOrder : .order
                }
            }
            Spacer()
            if displayHoldings {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "arrow.down")
                        .opacity((vm.sortedCoins == .holdings || vm.sortedCoins == .reversedHoldings) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortedCoins == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortedCoins = vm.sortedCoins == .holdings ? .reversedHoldings : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Value")
                Image(systemName: "arrow.down")
                    .opacity((vm.sortedCoins == .price || vm.sortedCoins == .reversedPrice) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortedCoins == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortedCoins = vm.sortedCoins == .price ? .reversedPrice : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.palette.secondaryTextColor)
        .padding(.horizontal)
    }
}
