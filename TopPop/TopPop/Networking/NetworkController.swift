//
//  NetworkController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import Foundation

struct NetworkController {
    
    static func getTop(number: Int, completionBlock: @escaping (String?, ChartTracksResponse?) -> Void) {
        
        let limit:String = URLPath.limit.rawValue + String(number)
        let url = URLPath.base.rawValue + URLPath.topTracksPath.rawValue + limit
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let message = "There was a problem with your network request: \(error)"
                completionBlock(message, nil)
                return
            }
            
            if let data = data {
                do {
                    let chartTracksResponse = try JSONDecoder().decode(ChartTracksResponse.self, from: data)
                    completionBlock(nil, chartTracksResponse)
                }
                catch _ {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completionBlock(errorResponse.error.message, nil)
                    }
                    catch let error2 {
                        let message = "Failed to parse a network response. Check your input and network connection. \(error2)"
                        completionBlock(message, nil)
                    }
                }
            }
        }.resume()
    }
}

enum URLPath: String {
    case base = "https://api.deezer.com"
    case topTracksPath = "/chart/0/tracks"
    case limit = "?limit="
    
}
