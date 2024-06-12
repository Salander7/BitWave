//
//  SettingsView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 21/08/2024.
//

import SwiftUI

struct SettingsView: View {
    
    let githubURL: URL? = URL(string: "https://github.com/Salander7")
    let coinGeckoURL: URL? = URL(string: "https://www.coingecko.com")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.palette.backgroundColor
                    .ignoresSafeArea()
                
                List {
                    bitWaveSection
                        .listRowBackground(Color.palette.backgroundColor.opacity(0.5))
                    coinGeckoSection
                        .listRowBackground(Color.palette.backgroundColor.opacity(0.5))
                    developerSection
                        .listRowBackground(Color.palette.backgroundColor.opacity(0.5))
                    applicationSection
                        .listRowBackground(Color.palette.backgroundColor.opacity(0.5))
                }
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(PlainListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    private var bitWaveSection: some View {
        Section(header: Text("BitWave")) {
            VStack(alignment: .leading) {
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Spacer()
                Text("BitWave is a comprehensive app designed to track, analyze, and manage your cryptocurrency investments with real-time updates and intuitive insights.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.palette.accentColor)
            }
            .padding(.vertical)
        }
    }
    
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Spacer()
                Spacer()
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("The cryptocurrency data for this app is sourced from CoinGecko's free API.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.palette.accentColor)
            }
            Link("Check out CoinGecko 🦎", destination: coinGeckoURL ?? URL(string: "https://www.coingecko.com")!)
                .foregroundStyle(.blue)
                .font(.callout)
                .fontWeight(.medium)
        }
    }
    
    private var developerSection: some View {
        Section(header: Text("About")) {
            VStack(alignment: .leading) {
                Image("deniz")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("This app, created by Deniz Dilbilir, is crafted entirely in Swift using SwiftUI. The project takes advantage of multi-threading, publisher-subscriber patterns, and robust data persistence. It adheres to the MVVM architecture and integrates Combine along with CoreData. Special thanks to Nick Sarno from Swiftful Thinking for his invaluable guidance and insights that greatly contributed to the development of this project.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.palette.accentColor)
            }
            .padding(.vertical)
            Link("Check Out My Github 🐉", destination: githubURL ?? URL(string: "https://github.com/Salander7")!)
                .foregroundStyle(.blue)
                .font(.callout)
                .fontWeight(.medium)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("More Info")) {
            if let url = coinGeckoURL {
                Link("Terms of Service", destination: url)
                Link("Privacy Policy", destination: url)
                Link("Company Website", destination: url)
                Link("Learn More", destination: url)
            }
        }
    }
}

