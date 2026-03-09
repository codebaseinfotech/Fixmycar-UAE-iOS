//
//  ReviewResponseModel.swift
//  Fixmycar UAE
//
//  Created by Kenil on 09/03/26.
//

import Foundation

struct ReviewResponseModel: Codable {
    let status: Bool?
    let message: String?
    let summary: ReviewSummary?
    let data: [ReviewListData]?
}

// MARK: - Summary
struct ReviewSummary: Codable {
    let averageRating: Int?
    let totalReviews: Int?
    let ratingCounts: RatingCounts?
    let ratingPercentages: RatingPercentages?

    enum CodingKeys: String, CodingKey {
        case averageRating = "average_rating"
        case totalReviews = "total_reviews"
        case ratingCounts = "rating_counts"
        case ratingPercentages = "rating_percentages"
    }
}

// MARK: - Rating Counts
struct RatingCounts: Codable {
    let five: Int?
    let four: Int?
    let three: Int?
    let two: Int?
    let one: Int?

    enum CodingKeys: String, CodingKey {
        case five = "5"
        case four = "4"
        case three = "3"
        case two = "2"
        case one = "1"
    }
}

// MARK: - Rating Percentages
struct RatingPercentages: Codable {
    let five: Int?
    let four: Int?
    let three: Int?
    let two: Int?
    let one: Int?

    enum CodingKeys: String, CodingKey {
        case five = "5"
        case four = "4"
        case three = "3"
        case two = "2"
        case one = "1"
    }
}

// MARK: - Review Data
struct ReviewListData: Codable {
    let id: Int?
    let bookingId: Int?
    let customerId: Int?
    let driverId: Int?
    let rating: Int?
    let review: String?
    let createdAt: String?
    let updatedAt: String?
    let customer: Customer?
    let driver: ReviewListDriver?
    let booking: Booking?

    enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case customerId = "customer_id"
        case driverId = "driver_id"
        case rating
        case review
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case customer
        case driver
        case booking
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int?
    let lastName: String?
    let firstName: String?
    let phone: String?
    let email: String?
    let avatar: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case firstName = "first_name"
        case phone
        case email
        case avatar
        case name
    }
}

// MARK: - Driver
struct ReviewListDriver: Codable {
    let id: Int?
    let fullName: String?
    let mobile: String?
    let email: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case mobile
        case email
        case profilePhoto = "profile_photo"
    }
}

// MARK: - Booking
struct Booking: Codable {
    let id: Int?
    let status: String?
}
