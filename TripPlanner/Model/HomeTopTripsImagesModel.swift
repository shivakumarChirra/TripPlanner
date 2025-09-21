//
//  HomeTopTripsImagesModel.swift
//  TripPlanner
//
//  Created by shivakumar chirra on 30/06/1947 Saka.
//

import Foundation

struct HomeTopTripsImagesModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let tripCost: Double
}
