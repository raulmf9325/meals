//
//  MealsListView.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import MealsApi
import MealsApiLive
import MealDetails
import SDWebImageSwiftUI
import SwiftUI

public struct MealsListView: View {
    public init(model: MealsListModel) {
        self.model = model
    }

    @ObservedObject var model: MealsListModel

    public var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    MealsListLoadingView()
                } else if let error = model.error {
                    MealsListErrorView(errorMessage: error, 
                                       onRetryButtonTapped: model.onRetryButtonTapped)
                } else {
                    List {
                        ForEach(model.desserts) { meal in
                            NavigationLink(value: meal) {
                                HStack {
                                    Text(meal.name)
                                    Spacer()
                                    WebImage(url: meal.imageURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    } placeholder: {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 60))
                                    }
                                    .frame(width: 100, height: 100)
                                }
                                .padding()
                            }
                        }
                    }
                    .navigationDestination(for: Meal.self) { meal in
                        MealDetailsView(model: MealDetailsModel(meal: meal,
                                                                apiClient: .live))
                    }
                }
            }
            .navigationTitle("Desserts")
        }
    }
}

#Preview {
    MealsListView(model: MealsListModel(apiClient: .test))
}
