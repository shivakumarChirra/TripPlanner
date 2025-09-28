//
//  NearbyView.swift
//  IOS26
//
//  Created by Netaxis on 26/09/25.
//

import SwiftUI

struct NearbyView: View {
    @StateObject private var viewModel = NearbyPlacesViewModel()

    private var HorizontalList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(Keyword.allCases) { keyword in
                    Button(action: {
                        Task {
                            
                            await viewModel.changeKeyword(to: keyword)
                        }
                    }, label: {
                        Text(keyword.title)
                            .padding(10)
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(
                                viewModel.selectedKeyword == keyword ? Color.black : Color.gray
                            )
                            .glassEffect(.clear.tint(.clear).interactive())
                    })
                    .scaleEffect(viewModel.selectedKeyword == keyword ? 1 : 0.8)
                }
            }
            .frame(height: 60)
        }
        .background(
            Image("img2")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HorizontalList
                    List {
                        ForEach(viewModel.places) { place in
                            NavigationLink(destination: NearbyPlaceDetailsView(place: place)) {
                                HStack {
                                    AsyncImage(url: place.photoURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(place.name)
                                            .font(.system(size: 15, weight: .bold))
                                        Text(place.address)
                                            .font(.system(size: 13))
                                    }
                                    Spacer()
                                }
                                .overlay(alignment: .trailing) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                        Text(String(Int(place.rating)))
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .alert(viewModel.alertTitle, isPresented: $viewModel.presentAlert) {
                    Button("OK", action: {})
                } message: {
                    Text(viewModel.alertMessage)
                }

                if viewModel.isLoading {
                    Color.black.opacity(0.2)
                        .padding(.top, 130)
                        .ignoresSafeArea()
                    ProgressView()
                        .tint(Color.white)
                }
            }
        }
    }
}

#Preview {
    NearbyView()
}

