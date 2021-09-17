//
//  ContentView.swift
//  SpeakBot
//
//  Created by Mert Çelik on 7.09.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight = false
    @State private var weatherdata: WeatherDataNow?
    @State private var weatherdataforecast: WeatherDataForecast?

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                
                TitleTextView(cityName: weatherdata?.name ?? "", countryName: weatherdata?.sys.country ?? "", day: "")
                    .onAppear {
                       pullWeatherData(url: url, forecast: false)
                        pullWeatherData(url: url2, forecast: true)

                    }
                               
                
                WeatherStatusView(ImageName: "sun.max.fill",
                                  Temprature: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp ?? 0.0)),
                                  Humidity: Int(weatherdata?.main.humidity ?? 0),
                                  Sunrise: sunTimeConverter(timeinterval: weatherdata?.sys.sunrise ?? 1),
                                  LowTemp: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp_min ?? 0.0)),
                                  Clouds: weatherdata?.clouds.all ?? 0,
                                  Sunset: sunTimeConverter(timeinterval: weatherdata?.sys.sunset ?? 1),
                                  HighTemp: convertToCelsius(fahrenheit: Int(weatherdata?.main.temp_max ?? 0.0))
            
                )
                

                HStack {
                    VStack(alignment: .leading) {
                        Text("Current Weather Data")
                            .font(.title)
                    }
                    .padding()
                  
                    Spacer()
                }
                ScrollView (.horizontal, showsIndicators: false) {

                     HStack {
                        ForEach(weatherdataforecast?.list.indices ?? WeatherDataForecast(list: [ListForecast(main: MainForecast(temp: 0.0, temp_max: 0.0, temp_min: 0.0, feels_like: 0.0, humidity: 0), weather: [WeatherForecast(main: "", description: "", icon: "")], dt_txt: "")]).list.indices , id: \.self) { index in
                           
                            if String(weatherdataforecast?.list[index].dt_txt.prefix(10) ?? "").contains(String(DateFormatter(timeinterval: weatherdata?.dt ?? 1).prefix(10))) {
                                
                                let datas = weatherdataforecast?.list[index]
                     
                                
                                WeatherDayViewNow(DayOfWeak: datas?.dt_txt ?? "",
                                               ImageName: "cloud.sun.fill",
                                               Temprature: (convertToCelsius(fahrenheit: Int(datas?.main.temp ?? 0))))
                            }
                        
                        }
                     }
                }.frame(height: 100)

                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Forecast Weather Data")
                            .font(.title2)

                    }
                    .padding()
                  
                    Spacer()
                }

                List {
                   ForEach(weatherdataforecast?.list.indices ?? WeatherDataForecast(list: [ListForecast(main: MainForecast(temp: 0.0, temp_max: 0.0, temp_min: 0.0, feels_like: 0.0, humidity: 0), weather: [WeatherForecast(main: "", description: "", icon: "")], dt_txt: "")]).list.indices , id: \.self) { index in
                       
                       if !String(weatherdataforecast?.list[index].dt_txt.prefix(10) ?? "").contains(String(DateFormatter(timeinterval: weatherdata?.dt ?? 1).prefix(10))) {
                           
                           let datas = weatherdataforecast?.list[index]
                           
                           WeatherDayView(DayOfWeak: datas?.dt_txt ?? "",
                                          ImageName: "cloud.sun.fill",
                                          Temprature: (convertToCelsius(fahrenheit: Int(datas?.main.temp ?? 0))))
                       }
                       
                   }
                }
                
                
                Spacer()
                
        
        
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
                    
                    for i in response.list {
                        print(i.main.temp)
                    }
                }
            }
        }
        task.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

struct WeatherDayView: View {
    
    var DayOfWeak: String
    var ImageName: String
    var Temprature: Int
    
    var body: some View {
        HStack {
            Image(systemName: ImageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 10)
                .frame(width: 40, height: 40)
            
            Text(DayOfWeak)
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.black)
            Spacer()
            Text("\(Temprature)°")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .padding(.trailing, 10)
           

        }


    }
}

struct WeatherDayViewNow: View {
    
    var DayOfWeak: String
    var ImageName: String
    var Temprature: Int
    
    var body: some View {
        VStack {
            Image(systemName: ImageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 10)
                .frame(width: 40, height: 40)
            
            Text(DayOfWeak)
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.black)

            Text("\(Temprature)°")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .padding(.trailing, 10)
           

        }.padding()


    }
}


struct BackgroundView: View {
        
    var body: some View {
        Color(.white)
            .edgesIgnoringSafeArea(.all)
    }
}

struct TitleTextView: View {
    
    var cityName: String
    var countryName: String
    var day: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cityName + ", " + countryName)
                    .font(.system(size: 50, weight: .medium, design: .default))
                    .foregroundColor(.black)
                    .bold()
                Text(day)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(.gray)
             
            }
            .padding()
          
            Spacer()
        }
       
    }
}

struct WeatherStatusView: View {
    
    var ImageName: String
    var Temprature: Int
    var Humidity: Int
    var Sunrise: String
    var LowTemp: Int
    var Clouds: Int
    var Sunset: String
    var HighTemp: Int
    
    
    var body: some View {
       
        HStack{
            InfoBar(topText: "Humidity", topTextValue: String(Humidity)+"%", middleImageName: "sunrise.fill", middleTextValue: Sunrise, bottomText: "Low", bottomTextValue: String(LowTemp)+"°")
                
            VStack {
          
                Image(systemName: ImageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                
                Text("\(Temprature)°")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.black)
            }
            
            InfoBar(topText: "Clouds", topTextValue: String(Clouds)+"%", middleImageName: "sunset.fill", middleTextValue: Sunset, bottomText: "High", bottomTextValue: String(HighTemp)+"°")
            
        }
        .padding(.top, 40)
        .padding(.bottom, 80)
        
    }
}

struct InfoBar: View {
    
    var topText: String
    var topTextValue: String
    var middleImageName: String
    var middleTextValue: String
    var bottomText: String
    var bottomTextValue: String
    
    var body: some View {
        
        VStack{
            Text(topText)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .bold()
            Text(topTextValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
            
            Divider()
                .frame(width: 100, height: 2)
            
            Image(systemName: middleImageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: 40, height: 40)
            Text(middleTextValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .bold()
            
            Divider()
                .frame(width: 100, height: 2)
            
            Text(bottomText)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .bold()
            Text(bottomTextValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
        }

    }
}
