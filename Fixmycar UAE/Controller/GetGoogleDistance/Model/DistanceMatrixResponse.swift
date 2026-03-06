//
//  DistanceMatrixResponse.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 02/03/26.
//

import Foundation

import Foundation
import CoreLocation

// MARK: - Main Response
struct DirectionResponse: Codable {
    let geocodedWaypoints: [GeocodedWaypoint]?
    let routes: [Route]?

    enum CodingKeys: String, CodingKey {
        case geocodedWaypoints = "geocoded_waypoints"
        case routes
    }
}

// MARK: - Waypoints
struct GeocodedWaypoint: Codable {
    let geocoderStatus: String?
    let placeID: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeID = "place_id"
        case types
    }
}

// MARK: - Route
struct Route: Codable {
    let bounds: Bounds?
    let legs: [Leg]?
    let copyrights: String?
    let overviewPolyline: OverviewPolyline?

    enum CodingKeys: String, CodingKey {
            case bounds
            case copyrights
            case legs
            case overviewPolyline = "overview_polyline"
        }
}

struct OverviewPolyline: Codable {
    let points: String?
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast: Location?
    let southwest: Location?
}

// MARK: - Leg
struct Leg: Codable {
    let distance: Distance?
    let duration: Distance?
    let durationInTraffic: Distance?
    let startAddress: String?
    let endAddress: String?
    let startLocation: Location?
    let endLocation: Location?
    let steps: [Step]?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case durationInTraffic = "duration_in_traffic"
        case startAddress = "start_address"
        case endAddress = "end_address"
        case startLocation = "start_location"
        case endLocation = "end_location"
        case steps
    }
}

// MARK: - Step
struct Step: Codable {
    let distance: Distance?
    let duration: Distance?
    let startLocation: Location?
    let endLocation: Location?
    let htmlInstructions: String?
    let maneuver: String?
    let polyline: Polyline?
    let travelMode: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case startLocation = "start_location"
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case maneuver
        case polyline
        case travelMode = "travel_mode"
    }
}

// MARK: - Polyline
struct Polyline: Codable {
    let points: String?
}

// MARK: - Distance / Duration
struct Distance: Codable {
    let text: String?
    let value: Int?
}

// MARK: - Location
struct Location: Codable {
    let lat: Double?
    let lng: Double?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lng ?? 0)
    }
}
