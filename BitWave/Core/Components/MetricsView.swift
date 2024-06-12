//
//  MetricsView.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 06/07/2024.
//

import SwiftUI

struct MetricsView: View {
    let metric: Metrics
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(metric.title)
                .font(.caption)
                .foregroundStyle(Color.palette.secondaryTextColor)
            Text(metric.value)
                .font(.footnote)
                .bold()
                .foregroundStyle(Color.palette.accentColor)
            HStack(spacing: 3) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:(metric.percentage ?? 0) >= 0 ? 0 : 180))
                Text(metric.percentage?.percentToString() ?? "")
                    .font(.footnote)
                    .bold()
            }
            .foregroundStyle((metric.percentage ?? 0) >= 0 ? Color.palette.green : Color.palette.red)
            .opacity(metric.percentage == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    Group {
        MetricsView(metric: SwiftUIPreview.instance.firstMetric)
        MetricsView(metric: SwiftUIPreview.instance.secondMetric)
        MetricsView(metric: SwiftUIPreview.instance.thirdMetric)
    }
  
}
