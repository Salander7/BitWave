//
//  ChartView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 19/08/2024.
//

import SwiftUI

struct ChartView: View {
    
    @State private var percent: CGFloat = 0
    
   private let data: [Double]
   private let maxY: Double
   private let minY: Double
   private let chartColor: Color
   private let startDate: Date
   private let endDate: Date
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceDifference = (data.last ?? 0) - (data.first ?? 0)
        chartColor = priceDifference > 0 ? Color.palette.green : Color.palette.red
        
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(backgroundView)
                .overlay(chartYAxis.padding(.horizontal, 5), alignment: .leading)
            chartLabel
                .padding(.horizontal, 5)
        }
        .font(.caption)
        .foregroundStyle(Color.palette.secondaryTextColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 1.0)) {
                    percent = 1.0
                }
            }
        }
    }
}

#Preview {
    ChartView(coin: SwiftUIPreview.instance.coin)
}

private extension ChartView {
    
    var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let x = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let y = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .trim(from: 0, to: percent)
            .stroke(chartColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            .clipped()
            .shadow(color: chartColor, radius: 9, x: 0.0, y: 10)
            .shadow(color: chartColor.opacity(0.4), radius: 9, x: 0.0, y: 20)
            .shadow(color: chartColor.opacity(0.1), radius: 9, x: 0.0, y: 30)
        }
    }
    
    var backgroundView: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    var chartLabel: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
}
