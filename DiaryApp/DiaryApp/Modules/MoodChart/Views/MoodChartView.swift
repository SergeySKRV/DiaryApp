//
//  MoodChartView.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 28.07.2026.
//

import SwiftUI
import Charts

struct MoodChartView: View {
    
    let dataPoints: [MoodDataPoint]
    
    var body: some View {
        Chart {
            ForEach(dataPoints) { point in
            LineMark(
                x: .value(L10n.chartAxisDate, point.date),
                y: .value(L10n.chartAxisMood, point.score)
                )
            .foregroundStyle(Color.blue.gradient)
            .lineStyle(StrokeStyle(lineWidth: 3))
                
                PointMark(
                    x: .value(L10n.chartAxisDate, point.date),
                    y: .value(L10n.chartAxisMood, point.score)
                )
                .foregroundStyle(Color.blue)
            }
        }
        .chartYScale(domain: -0.5...4.5)
        .chartYAxis {
            AxisMarks(values: [0, 1, 2, 3, 4]) { value in
                AxisValueLabel {
                    if let score = value.as(Double.self) {
                        Text(emojiForScore(score))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func emojiForScore(_ score: Double) -> String {
        switch score {
        case 0: return "😡"
        case 1: return "😔"
        case 2: return "😑"
        case 3: return "😌"
        case 4: return "😄"
        default: return ""
        }
    }
}

