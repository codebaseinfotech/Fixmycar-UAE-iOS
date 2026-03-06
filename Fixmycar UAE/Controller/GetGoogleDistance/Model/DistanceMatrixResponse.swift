//
//  DistanceMatrixResponse.swift
//  Fixmycar UAE
//
//  Created by Kenil on 02/03/26.
//

import Foundation

struct DirectionsResponse: Codable {
    let geocodedWaypoints: [GeocodedWaypoint]?
    let routes: [Route]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case geocodedWaypoints = "geocoded_waypoints"
        case routes
        case status
    }
}

struct GeocodedWaypoint: Codable {
    let geocoderStatus: String?
    let placeId: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeId = "place_id"
        case types
    }
}

struct Route: Codable {
    let bounds: Bounds?
    let copyrights: String?
    let legs: [Leg]?
}

struct Bounds: Codable {
    let northeast: Location?
    let southwest: Location?
}

struct Leg: Codable {
    let distance: Distance?
    let duration: DurationValue?
    let durationInTraffic: DurationValue?
    let endAddress: String?
    let endLocation: Location?
    let startAddress: String?
    let startLocation: Location?
    let steps: [Step]?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case durationInTraffic = "duration_in_traffic"
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
    }
}

struct Distance: Codable {
    let text: String?
    let value: Int?
}

struct DurationValue: Codable {
    let text: String?
    let value: Int?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

struct Step: Codable {
    let distance: Distance?
    let duration: DurationValue?
    let endLocation: Location?
    let htmlInstructions: String?
    let maneuver: String?
    let polyline: Polyline?
    let startLocation: Location?
    let travelMode: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case maneuver
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
    }
}

struct Polyline: Codable {
    let points: String?
}
