//
//  NearbyPlacesViewMOdel.swift
//  IOS26
//
//  Created by Netaxis on 26/09/25.
//

import Foundation
import CoreLocation
internal import Combine

@MainActor
class NearbyPlacesViewModel: NSObject ,ObservableObject, CLLocationManagerDelegate {
    @Published var places: [NearbyPlaceRowModel] = []
    @Published var selectedKeyword : Keyword = .cafe
    @Published var isLoading: Bool = false
    @Published var presentAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    private let apiClient = APIClient()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func changeKeyword(to keyword: Keyword) async {
        guard let currentLocation = currentLocation else { return }
        
        if selectedKeyword == keyword {
            return
        }else{
            selectedKeyword = keyword
            print("Selected keyword changed to: \(keyword.title)")
        }
        
        isLoading = true
        let result = await apiClient.getPlaces(forkeyword: keyword.apiName, location: currentLocation)
        isLoading = false
        parseAPI(result: result)
    }

    
    
    
    func fetchPlaces(location: CLLocation) async{
        isLoading = true
        let result =  await apiClient.getPlaces(forkeyword: "food",location: location )
        isLoading = false
        parseAPI(result: result)
    }
    
    
   private func parseAPI(result: APIClient.nearbyPlacesResult) {
        switch result {
            
        case .success(let NearbyPlacesResponceModel):
            let places = NearbyPlacesResponceModel.results
            self.places = places.compactMap ({ NearbyPlaceRowModel(place: $0)   })
             
        case .failure(let NearbyPlacesError):
            switch NearbyPlacesError {
            case .invalidURL,.invalidResponse,.badRequestError:
                alertTitle = "something is gone wrong"
                alertMessage = "we are apologize we are looking on it. Please Try again Later"
                presentAlert = true
            case .serverError:
                alertTitle = "Something as gone Wrong"
                alertMessage = "📡 Please check your internet connection or try again later "
                presentAlert = true
            }
            presentAlert = true
        }
    }
}

extension NearbyPlacesViewModel {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location is enabled")
            locationManager.requestLocation()
        case .denied,.restricted :
            alertTitle = "No Loaction Access"
            alertMessage = "Please grant location on settings or  may be Try Another Location "
            presentAlert = true
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            alertTitle = "No Loaction Access"
            alertMessage = "Please grant location on settings or  may be Try Another Location "
            presentAlert = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation =  location
        Task {
            await fetchPlaces(location: location)
        }
    }
}
