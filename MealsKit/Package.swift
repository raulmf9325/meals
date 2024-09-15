// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MealsKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "MealsList", targets: ["MealsList"]),
        .library(name: "MealDetails", targets: ["MealDetails"]),
        .library(name: "MealsApi", targets: ["MealsApi"]),
        .library(name: "MealsApiLive", targets: ["MealsApiLive"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MealsApi"),
        .target(name: "MealsApiLive", dependencies: ["MealsApi"]),
        .target(name: "MealsList", dependencies: ["MealsUI", "MealsApi", "MealsApiLive", "MealDetails", "SDWebImageSwiftUI"]),
        .target(name: "MealDetails", dependencies: ["MealsUI", "MealsApi", "SDWebImageSwiftUI"]),
        .target(name: "MealsUI"),
    ]
)
