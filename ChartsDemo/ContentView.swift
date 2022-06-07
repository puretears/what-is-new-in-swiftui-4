//
//  ContentView.swift
//  ChartsDemo
//
//  Created by Mars on 2022/6/7.
//

import SwiftUI
import Charts // MARK: New in SwiftUI 4

struct ContentView: View {
  var body: some View {
    GeometryReader { proxy in
      ScrollView(.vertical, showsIndicators: false) {
        Text("Temperatures in a year")
          .font(.title)
          .fontWeight(.bold)
        
        makeBarChart(proxy)
          .padding(.bottom, 30)
        
        makeLineChart(proxy)
          .padding(.bottom, 30)
        
        makeRectangleChart(proxy)
          .padding(.bottom, 30)
        
        makeAreaChart(proxy)
          .padding(.bottom, 30)
      }
      .padding(.horizontal, 10)
    }
  }
  
  func makeBarChart(_ proxy: GeometryProxy) -> some View {
    Chart(temperatures) { temperature in
      BarMark(
        x: .value("Mon", temperature.mon),
        y: .value("Temperature", temperature.celsius)
      )
      .foregroundStyle(temperature.color)
      .annotation(position: .top) {
        Text("\(String(format: "%.0f", temperature.celsius))")
          .font(.caption)
          .foregroundColor(Color.secondary)
          .fontWeight(.medium)
      }
    }
    .chartForegroundStyleScale(
      domain: Array<String>(scales.keys),
      range: scales.keys.map { scales[$0]! }
    )
    .frame(width: proxy.size.width - 20, height: 300)
  }
  
  func makeLineChart(_ proxy: GeometryProxy) -> some View {
    Chart(temperatures) { temperature in
      LineMark(
        x: .value("Mon", temperature.mon),
        y: .value("Temperature", temperature.celsius)
      )
      .symbol(by: .value("Mon", temperature.mon))
      .interpolationMethod(.cardinal)
      .foregroundStyle(Color.blue)
      .lineStyle(StrokeStyle(lineWidth: 4))
      
    }
    .frame(width: proxy.size.width - 20, height: 300)
  }
  
  func makeRectangleChart(_ proxy: GeometryProxy) -> some View {
    Chart(temperatures) { temperature in
      RectangleMark(
        x: .value("Mon", temperature.mon),
        y: .value("Temperature", temperature.celsius)
      )
      .foregroundStyle(temperature.color)
    }
    .chartForegroundStyleScale(
      domain: Array<String>(scales.keys),
      range: scales.keys.map { scales[$0]! }
    )
    .frame(width: proxy.size.width - 20, height: 300)
  }
  
  func makeAreaChart(_ proxy: GeometryProxy) -> some View {
    Chart(temperatures) { temperature in
      AreaMark(
        x: .value("Mon", temperature.mon),
        y: .value("Temperature", temperature.celsius)
      )
      .interpolationMethod(.cardinal)
      .foregroundStyle(temperature.color)
      
      RuleMark(
        y: .value("Avg.", temperatures.reduce(0) {$0 + $1.celsius} / 12)
      )
      .foregroundStyle(Color.orange)
    }
    .frame(width: proxy.size.width - 20, height: 300)
  }
}

struct Temperature: Identifiable {
  let id = UUID().uuidString
  let mon: String
  let celsius: Double
  var color: Color {
    if celsius <= 0 {
      return Color.blue
    }
    else if celsius > 0 && celsius <= 10 {
      return Color.teal
    }
    else if celsius > 10 && celsius <= 15 {
      return Color.green
    }
    else if celsius > 15 && celsius <= 20 {
      return Color.orange
    }
    
    return Color.red
  }
}

let temperatures: [Temperature] = [
  Temperature(mon: "JAN", celsius: -8),
  Temperature(mon: "FEB", celsius: -5),
  Temperature(mon: "MAR", celsius: 2),
  Temperature(mon: "APR", celsius: 9),
  Temperature(mon: "MAY", celsius: 15),
  Temperature(mon: "JUN", celsius: 20),
  Temperature(mon: "JUL", celsius: 23),
  Temperature(mon: "AUG", celsius: 21),
  Temperature(mon: "SEP", celsius: 15),
  Temperature(mon: "OCT", celsius: 8),
  Temperature(mon: "NOV", celsius: -4),
  Temperature(mon: "DEC", celsius: -6),
]

let scales: Dictionary<String, Color> = [
  "<= 0": Color.blue,
  "<= 10": Color.teal,
  "<= 15": Color.green,
  "<= 20": Color.orange,
  "> 20": Color.red
]

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
