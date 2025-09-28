//
//  NearbyPlaceRowModel.swift
//  IOS26
//
//  Created by Netaxis on 26/09/25.
//

import Foundation
import CoreLocation

struct NearbyPlaceRowModel: Identifiable {
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var id: String
    let name: String
    let photoURL: URL
    let rating: Double
    let address: String
    
    init(place: NearbyPlacesDetailsResponseModel) {
        self.id = place.placeId
        self.name = place.name
        self.address = place.vicinity ?? "Address not available"
        self.rating = place.rating ?? 0.0
        self.latitude = place.geometry.location.lat
        self.longitude = place.geometry.location.lng
        
        // Try to build a photo URL if available, otherwise fallback image
        if let photos = place.photos,
           let firstPhoto = photos.first,
           let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(firstPhoto.photoReference)&key=AIzaSyAAvvdnlutulkiI7HMe6nh1WHtf753Z86s") {
            self.photoURL = url
        } else {
            // fallback placeholder image
            self.photoURL = URL(string: "https://via.placeholder.com/100")!
        }
    }
}
