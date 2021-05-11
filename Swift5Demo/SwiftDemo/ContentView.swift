//
//  ContentView.swift
//  SwiftDemo
//
//  Created by WEI YANG on 2021/5/10.
//

import SwiftUI

let sampleUrl = URL(string: "https://postman-echo.com/get?foo1=bar1&foo2=bar2")!

struct ContentView: View {
    @State private var showDetails = false
    @State private var rawResult = "No result"
    @State private var jsonParsedResult = "No result"

    var body: some View {
        VStack(alignment: .leading) {
            Button("Post URL") {

                // create post request
                let url = sampleUrl
                var request = URLRequest(url: url)
                request.httpMethod = "GET"

                //Just in case you need to add params in POST
//                // prepare json data
//                let json: [String: Any] = ["sample_para": "12345"]
//
//                let jsonData = try? JSONSerialization.data(withJSONObject: json)
//                // insert json data to the request
//                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                    showDetails =  true

                    guard let data = data, error == nil else {
                        
                        print(error?.localizedDescription ?? "No data")
                        rawResult = error?.localizedDescription ?? "No data"
                        return
                    }
                    
                    rawResult = data.description
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        jsonParsedResult = responseJSON.description
                    }else{
                        jsonParsedResult = "Failed to parse json"
                    }
                }

                task.resume()

            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))

            if showDetails {
                Text(rawResult)
                    .font(.footnote)
            }
            
            if showDetails {
                Text(jsonParsedResult)
                    .font(.footnote)
            }
            
            Button("Open Gumpay App") {
                guard let gumpayScheme = URL(string: "gumpay://") else {
                  return //be safe
                }
                UIApplication.shared.open(gumpayScheme, options: [:], completionHandler: nil)
                
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))

        }
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
