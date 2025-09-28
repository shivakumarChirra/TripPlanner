//
//  NearbyMapView.swift
//  Ios26
//
//  Created by Netaxis on 27/09/25.
//

import SwiftUI
import MapKit
import UIKit

struct NearbyMapView: UIViewRepresentable {
        let userLocation: CLLocationCoordinate2D
        let destination: CLLocationCoordinate2D
        let route: MKRoute?

        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.showsUserLocation = true
            return mapView
        }

        func updateUIView(_ mapView: MKMapView, context: Context) {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
            
            let userPin = MKPointAnnotation()
            userPin.coordinate = userLocation
            userPin.title = "You"
            mapView.addAnnotation(userPin)
            
            let destPin = MKPointAnnotation()
            destPin.coordinate = destination
            destPin.title = "Destination"
            mapView.addAnnotation(destPin)
            
            if let route = route {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30),
                    animated: true
                )
            } else {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
            
            mapView.delegate = context.coordinator
        }

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        class Coordinator: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if let polyline = overlay as? MKPolyline {
                    let renderer = MKPolylineRenderer(polyline: polyline)
                    renderer.strokeColor = .blue
                    renderer.lineWidth = 4
                    return renderer
                }
                return MKOverlayRenderer()
            }
        }
    }

