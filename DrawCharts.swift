//
//  DrawCharts.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 22/10/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

// Functions for drawing charts.
// configurePieChart - creates a pie chart for showing a percentage value.
// configureHorizontalBarChart - creates a horizontal bar chart given a set of values.

import Foundation
import Charts

// Set up a pie chart given the PieChartView and the chartValue.
// The chartValue is the percentage to be coloured, i.e. for pass success or shots on target.
func configurePieChart(pieChart: PieChartView, chartValue: Double) -> PieChartView {
    
    // Create the data for the chart.
    let data: [ChartDataEntry] = [ChartDataEntry(x: 0.0, y: chartValue), ChartDataEntry(x: 1.0, y: (100.0 - chartValue))]
    
    // Create the data set and disable labels.
    let pieChartDataSet = PieChartDataSet(values: data, label: "")
    let pieChartData = PieChartData(dataSet: pieChartDataSet)
    pieChartData.setDrawValues(false)
    
    // Set the colour of the chart to white.
    let colors: [UIColor] = [UIColor.white, UIColor.clear]
    pieChartDataSet.colors = colors
    // Set the background and hole colours to clear.
    pieChart.backgroundColor = UIColor.clear
    pieChart.holeColor = UIColor.clear
    // Disable legend, axes and description.
    pieChart.drawEntryLabelsEnabled = false
    pieChart.legend.enabled = false
    pieChart.chartDescription?.text = ""
    //Disable user interaction, so that the chart cannot be selected.
    pieChart.isUserInteractionEnabled = false
    
    // Animate the chart when it comes into view.
    pieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
    
    // Set the chart's data and return it.
    pieChart.data = pieChartData
    return pieChart
    
}

// Set up a horizontal bar chart given a HorizontalBarChartView and a set of values.
// The values should be string such as ["10", "12", "15"].
// There are no labels on the chart, so an additional tableview must be set up on top.
func configureHorizontalBarChart(barChart: HorizontalBarChartView, values: [String]) -> HorizontalBarChartView {
    
    // Create the data for the chart, and an array for colours which is the same length
    // So that each bar is coloured.
    var dataEntries: [BarChartDataEntry] = []
    var colours = [UIColor]()
    for i in 0..<values.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
        dataEntries.append(dataEntry)
        colours.append(UIColor.white)
    }
    
    // Set the minimum y value so that the chart shows all the data.
    barChart.leftAxis.axisMinimum = 0
    
    // Create the data set for the chart.
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    let chartData = BarChartData(dataSet: chartDataSet)
    
    // Set the colours for the chart to white, and the value colours so that they can't be seen.
    chartDataSet.colors = colours
    chartDataSet.valueColors = colours
    // Set the background clear and disable legend.
    barChart.backgroundColor = UIColor.clear
    barChart.legend.enabled = false
    // Disable all grid lines and axes.
    barChart.drawGridBackgroundEnabled = false
    barChart.xAxis.drawAxisLineEnabled = false
    barChart.xAxis.drawGridLinesEnabled = false
    barChart.xAxis.drawLabelsEnabled = false
    barChart.leftAxis.drawGridLinesEnabled = false
    barChart.rightAxis.drawGridLinesEnabled = false
    barChart.leftAxis.drawAxisLineEnabled = false
    barChart.rightAxis.drawAxisLineEnabled = false
    barChart.leftAxis.drawLabelsEnabled = false
    barChart.rightAxis.drawLabelsEnabled = false
    // Disable labels and chart description.
    barChart.drawValueAboveBarEnabled = false
    barChart.chartDescription?.text = ""
    // Disable user interaction so that the graph cannot be selected.
    barChart.isUserInteractionEnabled = false
    
    // Animate the chart when it comes into view.
    barChart.animate(yAxisDuration: 1)
    
    // Set the chart's data and return it.
    barChart.data = chartData
    return barChart
    
}
