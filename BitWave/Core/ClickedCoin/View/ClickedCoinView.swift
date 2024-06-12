//
//  ClickedCoinView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 14/08/2024.
//

import SwiftUI

struct ClickedCoinView: View {
    @StateObject private var vm: ClickedCoinVM
    @State private var displayFullDescription: Bool = false
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: ClickedCoinVM(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .padding(.vertical, 0)

                VStack(spacing: 20) {
                    headerView
                    titleView
                 
                    descriptionView
                    linksView
                    cryptoProfileView
                    moreInfoView
                    
                }
                .padding(.top, 0)
            }
            .padding(.horizontal)
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navBarTrailing
            }
        }
        .onAppear {}
    }
}

private extension ClickedCoinView {
    
    var navBarTrailing: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.title3)
                .bold()
                .foregroundStyle(Color.palette.secondaryTextColor)
            CryptoImageView(coin: vm.coin)
                .frame(width: 41, height: 41)
        }
    }
    
    var headerView: some View {
       
        Text("")
            .frame(height: 0)
    }
    
    var titleView: some View {
        Text("Crypto Profile")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.palette.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var cryptoProfileView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Divider()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 30) {
                ForEach(vm.cryptoProfileMetrics) { metric in
                    MetricsView(metric: metric)
                }
            }
        }
    }
    
    var descriptionView: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(displayFullDescription ? nil : 5)
                        .font(.callout)
                    
                    Button(action: {
                        withAnimation(.default) {
                            displayFullDescription.toggle()
                        }
                    }, label: {
                        Text(displayFullDescription ? "less" : "more")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 3)
                    })
                    .foregroundStyle(.secondary)                            }
            }
        }
    }

    var moreInfoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("More Info")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.palette.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 30) {
                ForEach(vm.moreInfoMetrics) { metric in
                    MetricsView(metric: metric)
                }
            }
        }
    }
    var linksView: some View {
        VStack(alignment: .leading, spacing: 9) {
            if let websiteLink = vm.websiteLink,
               let url = URL(string: websiteLink) {
                Link("Webpage", destination: url)
            }
            
            if let redditLink = vm.redditLink,
               let url = URL(string: redditLink) {
                Link("Reddit", destination: url)
            }
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.caption)
        .bold()
    }
}

#Preview {
    NavigationStack {
        ClickedCoinView(coin: SwiftUIPreview.instance.coin)
    }
}
