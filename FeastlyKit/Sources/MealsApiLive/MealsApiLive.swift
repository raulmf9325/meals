//
//  MealsApiLive.swift
//
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import MealsApi

public extension MealsApi {
    static let live = Self(getCategories: getAllMealCategories,
                           getMeals: getMeals(category:),
                           getDetails: getMealDetails,
                           searchMeal:  searchMealWithText)
}

private func getAllMealCategories() async throws -> [MealCategory] {
    let urlRequest = try makeURLRequest(appending: "categories.php")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200, !data.isEmpty else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(MealCategoryResponse.self, from: data).categories
}

private func getMeals(category: String) async throws -> [Meal] {
    let urlRequest = try makeURLRequest(appending: "filter.php?c=\(category)")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200, !data.isEmpty else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(MealsResponse.self, from: data).meals.updatingCategory(category)
}

private func getMealDetails(mealId: String) async throws -> MealDetails {
    let urlRequest = try makeURLRequest(appending: "lookup.php?i=\(mealId)")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200, !data.isEmpty else {
        throw URLError(.badServerResponse)
    }
    
    guard let mealDetails = try JSONDecoder().decode(MealDetailsResponse.self, from: data).meals.first else {
        throw URLError(.badServerResponse)
    }

    return mealDetails
}

private func searchMealWithText(_ text: String) async throws -> [MealDetails] {
    let urlRequest = try makeURLRequest(appending: "search.php?s=\(text)")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200, !data.isEmpty else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(MealDetailsResponse.self, from: data).meals
}

private func makeURLRequest(appending query: String) throws -> URLRequest {
    let stringURL = baseURL.appending(query)
    
    guard let url = URL(string: stringURL) else {
        throw URLError(.badURL)
    }

    let urlRequest = URLRequest(url: url)
    return urlRequest
}

private let baseURL = "https://themealdb.com/api/json/v1/1/"

private extension Array where Element == Meal {
    func updatingCategory(_ categoryName: String) -> [Meal] {
        self.map { Meal(id: $0.id,
                        name: $0.name,
                        categoryName: categoryName,
                        thumbnailImageURL: $0.thumbnailImageURL) }
    }
}
