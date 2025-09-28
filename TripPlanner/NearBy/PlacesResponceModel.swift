//
//  PlacesResponceModel.swift
//  IOS26
//
//  Created by Netaxis on 26/09/25.
//

import Foundation

struct NearbyPlacesResponceModel: Decodable {
    
    let results : [NearbyPlacesDetailsResponseModel]
}
struct NearbyPlacesDetailsResponseModel: Decodable {
    let placeId: String
    let name: String
    let rating: Double?
    let vicinity: String
    let photos: [NearbyPhotoInfo]?
    let geometry: Geometry

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case rating
        case vicinity
        case photos
        case geometry
    }
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

struct NearbyPhotoInfo: Decodable {
    let photoReference : String
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
