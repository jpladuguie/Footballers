//
//  DrawCharts.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 22/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import Charts

func configurePieChart(pieChart: PieChartView, chartValue: Double) -> PieChartView {
    
    let data: [ChartDataEntry] = [ChartDataEntry(x: 0.0, y: chartValue), ChartDataEntry(x: 1.0, y: (100.0 - chartValue))]
    
    let pieChartDataSet = PieChartDataSet(values: data, label: "")
    let pieChartData = PieChartData(dataSet: pieChartDataSet)
    pieChartData.setDrawValues(false)
    
    let colors: [UIColor] = [UIColor.white, UIColor.clear]
    pieChartDataSet.colors = colors
    pieChart.drawEntryLabelsEnabled = false
    pieChart.backgroundColor = UIColor.clear
    pieChart.holeColor = UIColor.clear
    pieChart.legend.enabled = false
    pieChart.chartDescription?.text = ""
    pieChart.isUserInteractionEnabled = false
    
    pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
    
    pieChart.data = pieChartData
    
    return pieChart
    
}

func configureHorizontalBarChart(barChart: HorizontalBarChartView, values: [String]) -> HorizontalBarChartView {
    
    var dataEntries: [BarChartDataEntry] = []
    
    for i in 0..<values.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
        dataEntries.append(dataEntry)
    }
    
    barChart.leftAxis.axisMinimum = 0
    
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    let chartData = BarChartData(dataSet: chartDataSet)
    
    let colors: [UIColor] = [UIColor.white, UIColor.white, UIColor.white]
    chartDataSet.colors = colors
    chartDataSet.valueColors = colors
    barChart.backgroundColor = UIColor.clear
    barChart.legend.enabled = false
    barChart.drawGridBackgroundEnabled = false
    barChart.chartDescription?.text = ""
    barChart.xAxis.drawAxisLineEnabled = false
    barChart.xAxis.drawGridLinesEnabled = false
    barChart.xAxis.drawLabelsEnabled = false
    barChart.leftAxis.drawGridLinesEnabled = false
    barChart.rightAxis.drawGridLinesEnabled = false
    barChart.leftAxis.drawAxisLineEnabled = false
    barChart.rightAxis.drawAxisLineEnabled = false
    barChart.leftAxis.drawLabelsEnabled = false
    barChart.rightAxis.drawLabelsEnabled = false
    barChart.drawValueAboveBarEnabled = false
    barChart.isUserInteractionEnabled = false
    
    barChart.data = chartData
    
    barChart.animate(yAxisDuration: 1)
    
    return barChart
    
}
