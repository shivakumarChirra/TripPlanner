//
//  NearbyPlaceDetailsView.swift
//  Ios26
//
//  Created by Netaxis on 27/09/25.
//

import SwiftUI
import SwiftUI
import MapKit
import CoreLocation

struct NearbyPlaceDetailsView: View {


    
        let place: NearbyPlaceRowModel
        
        @State private var transportType: MKDirectionsTransportType = .automobile
        @State private var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        @State private var route: MKRoute?
        @State private var destination: CLLocationCoordinate2D?
        @State private var newLocationText: String = ""
        
        var body: some View {
            VStack(spacing: 12) {
                NearbyMapView(userLocation: userLocation, destination: place.coordinate, route: route)
                    .frame(width: 300, height: 500)
                    .cornerRadius(12)
                    .onAppear {
                        getRoute()
                    }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(place.name)
                        .font(.title3).bold()
                    Text(place.address)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                
                HStack {
                    Button("Bus") { transportType = .transit; getRoute() }
                    Button("Train") { transportType = .transit; getRoute() }
                    Button("Flights") { transportType = .any; getRoute() } // Flights are symbolic, MKDirections doesn't support flights
                    Button("Car") { transportType = .automobile; getRoute() }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                HStack {
                    TextField("Change your location", text: $newLocationText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Update") {
                        convertAddressToCoordinates(address: newLocationText) { newCoord in
                            if let coord = newCoord {
                                userLocation = coord
                                getRoute()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Details")
        }
        
        private func getRoute() {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            request.transportType = transportType
            
            MKDirections(request: request).calculate { response, error in
                if let route = response?.routes.first {
                    self.route = route
                }
            }
        }
        
        private func convertAddressToCoordinates(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
            CLGeocoder().geocodeAddressString(address) { placemarks, error in
                if let location = placemarks?.first?.location {
                    completion(location.coordinate)
                } else {
                    completion(nil)
                }
            }
        }
    }

