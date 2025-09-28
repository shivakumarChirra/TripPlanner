//
//  NearbyModelView.swift
//  IOS26
//
//  Created by Netaxis on 26/09/25.
//

import Foundation

import CoreLocation
class APIClient {
    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let googlePlacesKey = "AIzaSyAAvvdnlutulkiI7HMe6nh1WHtf753Z86s"
    typealias nearbyPlacesResult = Result<NearbyPlacesResponceModel,NearbyPlacesError>
    
    private func responseType(statusCode: Int)  -> NearbyResponseType {
        switch statusCode {
        case 100..<200 :
            print("informational")
            return .informational
        case 200..<300 :
            print("successfull request ")
            return .success
        case 400..<500 :
           print("bad request")
            return .clientError
        case 500..<600 :
            print( "server issue")
            return .serverError
        default :
            return .undefined
      
        }
    }
    
    func getPlaces (forkeyword keyword: String,location: CLLocation )async -> nearbyPlacesResult{
        guard let url = createUR(location:  location, keyword: keyword) else{
            return .failure(.invalidURL)
        }
        do{
         let (data, response) =    try await URLSession.shared.data(from: url )
            guard let response = response as?  HTTPURLResponse else {
                 return .failure(.invalidResponse)
            }
            
            print(String(data: data, encoding: .utf8) ?? "No response string")

            let responseType =  responseType(statusCode: response.statusCode)
            switch responseType{
            case .serverError, .informational, .redirection,.undefined  :
                print("DEBUG: erver error in request")
                return .failure(.serverError)
            case .clientError :
                
                print("DEBUG:  BAd server request errr ")
                return .failure(.badRequestError)
               
            case .success :
                let decodedJSON = try  JSONDecoder().decode(NearbyPlacesResponceModel.self,from: data)
                return .success(decodedJSON)
               
            }
   
        }
        catch{
            print(error.localizedDescription)
            return .failure(.badRequestError)
        }
    }
    
    
    
    private func createUR(location:CLLocation, keyword: String) -> URL? {
        var urlComponents = URLComponents (string: baseURL)
        let  queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: String(location.coordinate.latitude) + "," + String (location.coordinate.longitude)),
            URLQueryItem(name:"rankby", value: "distance"),
            URLQueryItem(name:"keyword", value: keyword),
            URLQueryItem(name: "key", value: googlePlacesKey)
    ]
        urlComponents?.queryItems = queryItems
            return urlComponents?.url
    }
}
