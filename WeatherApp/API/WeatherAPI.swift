//
//  WeatherAPI.swift
//  SpeakBot
//
//  Created by Mert Çelik on 11.09.2021.
//

import Foundation

let APIKey = "69c4bb0544b88cf1e83dc4eae42d2a11"

let country: String = "Turkey"
let city: String = "Istanbul"

let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=imperial")
let url2 = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(APIKey)&units=imperial")


// Now DATA
struct WeatherDataNow: Decodable {
    var main: MainNow
    var weather: [WeatherNow]
    var dt: TimeInterval
    var name: String
    var sys: Sys
    var clouds: Clouds
}

struct MainNow: Decodable {
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let feels_like: Float
    let humidity: Double
}

struct WeatherNow: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Sys: Decodable {
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct Clouds: Decodable {
    let all: Int
}

// Forecast DATA
struct WeatherDataForecast: Decodable {
    let list: [ListForecast]
}

struct ListForecast : Decodable {
    let main: MainForecast
    let weather: [WeatherForecast]
    let dt_txt: String
}

struct MainForecast: Decodable {
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let feels_like: Float
    let humidity: Double
}

struct WeatherForecast: Decodable {
    let main: String
    let description: String
    let icon: String
}



// TIMEINTERVAL TO STRING DATE
func DateFormatter(timeinterval: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: NSDate(timeIntervalSince1970: timeinterval) as Date)
}

// SUNTIME CONVERTER
func sunTimeConverter(timeinterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeinterval)
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium

    return formatter.string(from: date)
}

// FAHRENHEIT TO CELSIUS
func convertToCelsius(fahrenheit: Int) -> Int {
    return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
}

// GET DAY NAME
func getDay(Date: NSDate) -> String{
    let date = Date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat  = "EEEE"
    return dateFormatter.string(from: date as Date)
}

// STRING TO NSDATE
func getNSDATE(Day: String) -> NSDate{
    let dateString = Day
    if dateString != "" {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return (dateFormatter.date(from: dateString))! as NSDate
    }
    else {
        return NSDate()
    }
 
}

