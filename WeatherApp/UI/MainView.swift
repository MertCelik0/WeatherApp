//
//  MainView.swift
//  SpeakBot
//
//  Created by Mert Çelik on 14.09.2021.
//

import SwiftUI

struct MainView: View {
    
//  Current day weather struct data variable
    @State private var weatherdata: WeatherDataNow?
    
//  Forecast days weather sturct data variable
    @State private var weatherdataforecast: WeatherDataForecast?
        
    var body: some View {
        
        
        ZStack {
            
//          Set Backgorund Color
            SetBackground()
            
//          Page add scrolling
            ScrollView (.vertical, showsIndicators: false) {
//            
//                VStack{
//           
//                    HStack {
//                    
//                        Spacer()
//                        
////                      Add right top settings image
//                        Image(systemName: "gearshape")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.white)
//
//                        
//                    }
//                    
//                }
//                .padding()
                
//              Set current data and bind image, text vb. objects.
                TodayNowDataView(City: weatherdata?.name ?? "", Country: weatherdata?.sys.country ?? "", Weather: "weather", Temp: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp ?? 0.0)))
                    .onAppear {
//                     This func first started get webservices json datas (forecast and current)
                        pullWeatherData(url: url, forecast: false)
                        pullWeatherData(url: url2, forecast: true)

                    }

                VStack(alignment: .leading) {
                    
//                  Set current day name
                    Text("Today")
                        .font(.system(size: 20, weight: .thin, design: .default))
                        .foregroundColor(.white)
                    
//                  Add custom line
                    divider()
                    
//                  Add horizontal scrolling
                    ScrollView (.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
//                          Foreach forecast list datas
                            ForEach(weatherdataforecast?.list.indices ?? WeatherDataForecast(list: [ListForecast(main: MainForecast(temp: 0.0, temp_max: 0.0, temp_min: 0.0, feels_like: 0.0, humidity: 0), weather: [WeatherForecast(main: "", description: "", icon: "")], dt_txt: "")]).list.indices , id: \.self) { index in
                               
//                              Check current day and webservices date equals
                                if String(weatherdataforecast?.list[index].dt_txt.prefix(10) ?? "").contains(String(DateFormatter(timeinterval: weatherdata?.dt ?? 1).prefix(10))) {
                                    
//                                  Get data with index
                                    let datas = weatherdataforecast?.list[index]
                         
//                                  Set today time data
                                    TodayAll(Time: datas?.dt_txt ?? "", Image: "cloud.sun.fill", Temp: (convertToCelsius(fahrenheit: Int(datas?.main.temp ?? 0))))
                                    
                                }
                            
                            }
                        }
                    }
                    
//                  Add custom line
                    divider()
                    
                } .padding()
              
//
//                VStack(alignment: .leading) {
//
//
//                    //Forecast Data
//                    ForEach(weatherdataforecast?.list.indices ?? WeatherDataForecast(list: [ListForecast(main: MainForecast(temp: 0.0, temp_max: 0.0, temp_min: 0.0, feels_like: 0.0, humidity: 0), weather: [WeatherForecast(main: "", description: "", icon: "")], dt_txt: "")]).list.indices , id: \.self) { index in
//
////                      Check current day and webservices date not equals
//                        if !String(weatherdataforecast?.list[index].dt_txt.prefix(10) ?? "").contains(String(DateFormatter(timeinterval: weatherdata?.dt ?? 1).prefix(10))) {
////                          Get data with index
//
//                            let datas = weatherdataforecast?.list[index]
//                            if String(datas?.dt_txt.prefix(10) ?? "").contains(String(datas?.dt_txt.prefix(10) ?? "")) {
//
//
//     //                               Set forecast day data
//                            ForecastAllDay(Day: String(datas?.dt_txt.prefix(10) ?? "") ,
//                                                  Image: "cloud.sun.fill",
//                                                minTemp: (convertToCelsius(fahrenheit: Int(datas?.main.temp_min ?? 0))),
//                                                  maxTemp: (convertToCelsius(fahrenheit: Int(datas?.main.temp_max ?? 0))))
//                            }
//
//
////
//                        }
//                    }
//
//                }
//                .padding()
                
//              Add current day informations. (Clouds, max-min temp, humidity, sunset - sunrise vb.)
                VStack(alignment:.leading) {
                    
                    Text("Day Informations")
                        .font(.system(size: 20, weight: .thin, design: .default))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    
//                  Add custom line
                    divider()
                    
                    HStack {
                        TodayExtraInfo(text: "Sunrise", Clouds: nil, Humidity: nil, Sunset: nil, Sunrise: sunTimeConverter(timeinterval: weatherdata?.sys.sunrise ?? 1), Low: nil, High: nil)
                        Spacer()
                        TodayExtraInfo(text: "Sunset", Clouds: nil, Humidity: nil, Sunset: sunTimeConverter(timeinterval: weatherdata?.sys.sunset ?? 1), Sunrise: nil, Low: nil, High: nil)
                        Spacer()
                    }
                   
                    HStack {
                        TodayExtraInfo(text: "Low", Clouds: nil, Humidity: nil, Sunset: nil, Sunrise: nil, Low: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp_min ?? 0.0)), High: nil)
                        Spacer()
                        TodayExtraInfo(text: "High", Clouds: nil, Humidity: nil, Sunset: nil, Sunrise: nil, Low: nil, High: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp_max ?? 0.0)))
                        Spacer()
                    }
                    HStack {
                        TodayExtraInfo(text: "Clouds", Clouds: weatherdata?.clouds.all ?? 0, Humidity: nil, Sunset: nil, Sunrise: nil, Low: nil, High: nil)
                        Spacer()
                        TodayExtraInfo(text: "Humidity", Clouds: weatherdata?.clouds.all ?? 0, Humidity: Int(weatherdata?.main.humidity ?? 0), Sunset: nil, Sunrise: nil, Low: nil, High: nil)
                        Spacer()
                    }
        
//                  Add custom line
                    divider()
                }
                .padding()

            }
        }
        
    }
    // Get JSON Data with URL
    func pullWeatherData(url: URL?, forecast: Bool) {
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    print("Error: HTTP Response Error")
                    return
                }
                
                guard let data = data else {
                    print("Error: No Response")
                    return
                }
                
                if !forecast {
                    let response = try! JSONDecoder().decode(WeatherDataNow.self, from: data)
                    
                    self.weatherdata = response
                    
                
                   
                }else {
                    let response = try! JSONDecoder().decode(WeatherDataForecast.self, from: data)
                    
                    self.weatherdataforecast = response
                }
            }
        }
        task.resume()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct SetBackground: View {
    var body: some View {
        Color("lightBlue")
            .edgesIgnoringSafeArea(.all)
    }
}

struct TodayNowDataView: View {
    
    let City: String
    let Country: String
    let Weather: String
    let Temp: Int
    
    var body: some View {
        VStack {
            Text("\(City), \(Country)")
                .font(.system(size: 30, weight: .medium, design: .default))
                .foregroundColor(.white)
            
         //   Text(Weather)
             //   .font(.system(size: 20, weight: .thin, design: .default))
              //  .foregroundColor(.white)
            
            
            Text("\(Temp)°")
                .font(.system(size: 120, weight: .thin, design: .default))
                .foregroundColor(.white)
            
            Spacer()
            
        }
        .padding(.top, 50)
    }
}

struct TodayAll: View {
    
    let Time: String
    let Image: String
    let Temp: Int
    
    var body: some View {
        VStack {
            
            Text(Time.suffix(8).prefix(2))
                .font(.system(size: 20, weight: .thin, design: .default))
                .foregroundColor(.white)
            
            SwiftUI.Image(systemName: Image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            
            Text("\(Temp)°")
                .font(.system(size: 20, weight: .regular, design: .default))
                .foregroundColor(.white)
        }
    }
}
struct ForecastAllDay: View {
    
    let Day: String
    let Image: String
    let minTemp: Int
    let maxTemp: Int

    var body: some View {
        HStack{
            Text(getDay(Date: getNSDATE(Day: Day)))
                .font(.system(size: 20, weight: .thin, design: .default))
                .foregroundColor(.white)
            
            Spacer()
            
            SwiftUI.Image(systemName: Image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            
            Spacer()
            
            Text("\(minTemp)°")
                .font(.system(size: 20, weight: .regular, design: .default))
                .foregroundColor(.white)
            Text("\(maxTemp)°")
                .font(.system(size: 20, weight: .regular, design: .default))
                .foregroundColor(.white)
        }
    }
}


struct divider: View {
    var body: some View {
        Divider()
            .frame(width: .none, height: 0.5)
            .background(Color.white)
    }
}

struct TodayExtraInfo: View {
    
    let text: String
    
    let Clouds: Int?
    let Humidity: Int?
    let Sunset: String?
    let Sunrise: String?
    let Low: Int?
    let High: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.system(size: 20, weight: .thin, design: .default))
                .foregroundColor(.white)
            if text == "Clouds" {
                Text("\(Clouds!)%")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            else if text == "Humidity" {
                Text("\(Humidity!)%")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            else if text == "Sunset" {
                Text("\(String(Sunset!.prefix(5))) AM")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            else if text == "Sunrise" {
                Text("\(String(Sunrise!.prefix(5))) PM")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            else if text == "Low" {
                Text("\(Low!)°")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            else if text == "High" {
                Text("\(High!)°")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }

            
        }.frame(width: 100, alignment: .leading)
    }
}
