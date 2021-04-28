// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum Mode: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// AIRPLANE
  case airplane
  /// BICYCLE
  case bicycle
  /// BUS
  case bus
  /// CABLE_CAR
  case cableCar
  /// CAR
  case car
  /// FERRY
  case ferry
  /// FUNICULAR
  case funicular
  /// GONDOLA
  case gondola
  /// Only used internally. No use for API users.
  case legSwitch
  /// RAIL
  case rail
  /// SUBWAY
  case subway
  /// TRAM
  case tram
  /// A special transport mode, which includes all public transport.
  case transit
  /// WALK
  case walk
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AIRPLANE": self = .airplane
      case "BICYCLE": self = .bicycle
      case "BUS": self = .bus
      case "CABLE_CAR": self = .cableCar
      case "CAR": self = .car
      case "FERRY": self = .ferry
      case "FUNICULAR": self = .funicular
      case "GONDOLA": self = .gondola
      case "LEG_SWITCH": self = .legSwitch
      case "RAIL": self = .rail
      case "SUBWAY": self = .subway
      case "TRAM": self = .tram
      case "TRANSIT": self = .transit
      case "WALK": self = .walk
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .airplane: return "AIRPLANE"
      case .bicycle: return "BICYCLE"
      case .bus: return "BUS"
      case .cableCar: return "CABLE_CAR"
      case .car: return "CAR"
      case .ferry: return "FERRY"
      case .funicular: return "FUNICULAR"
      case .gondola: return "GONDOLA"
      case .legSwitch: return "LEG_SWITCH"
      case .rail: return "RAIL"
      case .subway: return "SUBWAY"
      case .tram: return "TRAM"
      case .transit: return "TRANSIT"
      case .walk: return "WALK"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Mode, rhs: Mode) -> Bool {
    switch (lhs, rhs) {
      case (.airplane, .airplane): return true
      case (.bicycle, .bicycle): return true
      case (.bus, .bus): return true
      case (.cableCar, .cableCar): return true
      case (.car, .car): return true
      case (.ferry, .ferry): return true
      case (.funicular, .funicular): return true
      case (.gondola, .gondola): return true
      case (.legSwitch, .legSwitch): return true
      case (.rail, .rail): return true
      case (.subway, .subway): return true
      case (.tram, .tram): return true
      case (.transit, .transit): return true
      case (.walk, .walk): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Mode] {
    return [
      .airplane,
      .bicycle,
      .bus,
      .cableCar,
      .car,
      .ferry,
      .funicular,
      .gondola,
      .legSwitch,
      .rail,
      .subway,
      .tram,
      .transit,
      .walk,
    ]
  }
}

public final class FindRoutesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query findRoutes($originLat: Float!, $originLon: Float!, $destLat: Float!, $destLon: Float!) {
      plan(
        from: {lat: $originLat, lon: $originLon}
        to: {lat: $destLat, lon: $destLon}
        numItineraries: 10
        transportModes: [{mode: TRANSIT}, {mode: WALK}, {mode: BICYCLE}]
      ) {
        __typename
        itineraries {
          __typename
          walkDistance
          duration
          legs {
            __typename
            distance
            mode
            startTime
            endTime
            from {
              __typename
              lat
              lon
              name
              stop {
                __typename
                code
                name
              }
            }
            to {
              __typename
              lat
              lon
              name
              stop {
                __typename
                code
                name
              }
            }
            trip {
              __typename
              tripHeadsign
              routeShortName
            }
            legGeometry {
              __typename
              length
              points
            }
          }
        }
      }
    }
    """

  public let operationName: String = "findRoutes"

  public var originLat: Double
  public var originLon: Double
  public var destLat: Double
  public var destLon: Double

  public init(originLat: Double, originLon: Double, destLat: Double, destLon: Double) {
    self.originLat = originLat
    self.originLon = originLon
    self.destLat = destLat
    self.destLon = destLon
  }

  public var variables: GraphQLMap? {
    return ["originLat": originLat, "originLon": originLon, "destLat": destLat, "destLon": destLon]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("plan", arguments: ["from": ["lat": GraphQLVariable("originLat"), "lon": GraphQLVariable("originLon")], "to": ["lat": GraphQLVariable("destLat"), "lon": GraphQLVariable("destLon")], "numItineraries": 10, "transportModes": [["mode": "TRANSIT"], ["mode": "WALK"], ["mode": "BICYCLE"]]], type: .object(Plan.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(plan: Plan? = nil) {
      self.init(unsafeResultMap: ["__typename": "QueryType", "plan": plan.flatMap { (value: Plan) -> ResultMap in value.resultMap }])
    }

    /// Plans an itinerary from point A to point B based on the given arguments
    public var plan: Plan? {
      get {
        return (resultMap["plan"] as? ResultMap).flatMap { Plan(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "plan")
      }
    }

    public struct Plan: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Plan"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("itineraries", type: .nonNull(.list(.object(Itinerary.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(itineraries: [Itinerary?]) {
        self.init(unsafeResultMap: ["__typename": "Plan", "itineraries": itineraries.map { (value: Itinerary?) -> ResultMap? in value.flatMap { (value: Itinerary) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of possible itineraries
      public var itineraries: [Itinerary?] {
        get {
          return (resultMap["itineraries"] as! [ResultMap?]).map { (value: ResultMap?) -> Itinerary? in value.flatMap { (value: ResultMap) -> Itinerary in Itinerary(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Itinerary?) -> ResultMap? in value.flatMap { (value: Itinerary) -> ResultMap in value.resultMap } }, forKey: "itineraries")
        }
      }

      public struct Itinerary: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Itinerary"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("walkDistance", type: .scalar(Double.self)),
            GraphQLField("duration", type: .scalar(String.self)),
            GraphQLField("legs", type: .nonNull(.list(.object(Leg.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(walkDistance: Double? = nil, duration: String? = nil, legs: [Leg?]) {
          self.init(unsafeResultMap: ["__typename": "Itinerary", "walkDistance": walkDistance, "duration": duration, "legs": legs.map { (value: Leg?) -> ResultMap? in value.flatMap { (value: Leg) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// How far the user has to walk, in meters.
        public var walkDistance: Double? {
          get {
            return resultMap["walkDistance"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "walkDistance")
          }
        }

        /// Duration of the trip on this itinerary, in seconds.
        public var duration: String? {
          get {
            return resultMap["duration"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "duration")
          }
        }

        /// A list of Legs. Each Leg is either a walking (cycling, car) portion of the itinerary, or a transit leg on a particular vehicle. So a itinerary where the user walks to the Q train, transfers to the 6, then walks to their destination, has four legs.
        public var legs: [Leg?] {
          get {
            return (resultMap["legs"] as! [ResultMap?]).map { (value: ResultMap?) -> Leg? in value.flatMap { (value: ResultMap) -> Leg in Leg(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Leg?) -> ResultMap? in value.flatMap { (value: Leg) -> ResultMap in value.resultMap } }, forKey: "legs")
          }
        }

        public struct Leg: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Leg"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("distance", type: .scalar(Double.self)),
              GraphQLField("mode", type: .scalar(Mode.self)),
              GraphQLField("startTime", type: .scalar(String.self)),
              GraphQLField("endTime", type: .scalar(String.self)),
              GraphQLField("from", type: .nonNull(.object(From.selections))),
              GraphQLField("to", type: .nonNull(.object(To.selections))),
              GraphQLField("trip", type: .object(Trip.selections)),
              GraphQLField("legGeometry", type: .object(LegGeometry.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(distance: Double? = nil, mode: Mode? = nil, startTime: String? = nil, endTime: String? = nil, from: From, to: To, trip: Trip? = nil, legGeometry: LegGeometry? = nil) {
            self.init(unsafeResultMap: ["__typename": "Leg", "distance": distance, "mode": mode, "startTime": startTime, "endTime": endTime, "from": from.resultMap, "to": to.resultMap, "trip": trip.flatMap { (value: Trip) -> ResultMap in value.resultMap }, "legGeometry": legGeometry.flatMap { (value: LegGeometry) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The distance traveled while traversing the leg in meters.
          public var distance: Double? {
            get {
              return resultMap["distance"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "distance")
            }
          }

          /// The mode (e.g. `WALK`) used when traversing this leg.
          public var mode: Mode? {
            get {
              return resultMap["mode"] as? Mode
            }
            set {
              resultMap.updateValue(newValue, forKey: "mode")
            }
          }

          /// The date and time when this leg begins. Format: Unix timestamp in milliseconds.
          public var startTime: String? {
            get {
              return resultMap["startTime"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startTime")
            }
          }

          /// The date and time when this leg ends. Format: Unix timestamp in milliseconds.
          public var endTime: String? {
            get {
              return resultMap["endTime"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endTime")
            }
          }

          /// The Place where the leg originates.
          public var from: From {
            get {
              return From(unsafeResultMap: resultMap["from"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "from")
            }
          }

          /// The Place where the leg ends.
          public var to: To {
            get {
              return To(unsafeResultMap: resultMap["to"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "to")
            }
          }

          /// For transit legs, the trip that is used for traversing the leg. For non-transit legs, `null`.
          public var trip: Trip? {
            get {
              return (resultMap["trip"] as? ResultMap).flatMap { Trip(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "trip")
            }
          }

          /// The leg's geometry.
          public var legGeometry: LegGeometry? {
            get {
              return (resultMap["legGeometry"] as? ResultMap).flatMap { LegGeometry(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "legGeometry")
            }
          }

          public struct From: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Place"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("lat", type: .nonNull(.scalar(Double.self))),
                GraphQLField("lon", type: .nonNull(.scalar(Double.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("stop", type: .object(Stop.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(lat: Double, lon: Double, name: String? = nil, stop: Stop? = nil) {
              self.init(unsafeResultMap: ["__typename": "Place", "lat": lat, "lon": lon, "name": name, "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Latitude of the place (WGS 84)
            public var lat: Double {
              get {
                return resultMap["lat"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lat")
              }
            }

            /// Longitude of the place (WGS 84)
            public var lon: Double {
              get {
                return resultMap["lon"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lon")
              }
            }

            /// For transit stops, the name of the stop. For points of interest, the name of the POI.
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The stop related to the place.
            public var stop: Stop? {
              get {
                return (resultMap["stop"] as? ResultMap).flatMap { Stop(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "stop")
              }
            }

            public struct Stop: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Stop"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("code", type: .scalar(String.self)),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(code: String? = nil, name: String) {
                self.init(unsafeResultMap: ["__typename": "Stop", "code": code, "name": name])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Stop code which is visible at the stop
              public var code: String? {
                get {
                  return resultMap["code"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "code")
                }
              }

              /// Name of the stop, e.g. Pasilan asema
              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }
            }
          }

          public struct To: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Place"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("lat", type: .nonNull(.scalar(Double.self))),
                GraphQLField("lon", type: .nonNull(.scalar(Double.self))),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("stop", type: .object(Stop.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(lat: Double, lon: Double, name: String? = nil, stop: Stop? = nil) {
              self.init(unsafeResultMap: ["__typename": "Place", "lat": lat, "lon": lon, "name": name, "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Latitude of the place (WGS 84)
            public var lat: Double {
              get {
                return resultMap["lat"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lat")
              }
            }

            /// Longitude of the place (WGS 84)
            public var lon: Double {
              get {
                return resultMap["lon"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lon")
              }
            }

            /// For transit stops, the name of the stop. For points of interest, the name of the POI.
            public var name: String? {
              get {
                return resultMap["name"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The stop related to the place.
            public var stop: Stop? {
              get {
                return (resultMap["stop"] as? ResultMap).flatMap { Stop(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "stop")
              }
            }

            public struct Stop: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Stop"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("code", type: .scalar(String.self)),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(code: String? = nil, name: String) {
                self.init(unsafeResultMap: ["__typename": "Stop", "code": code, "name": name])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Stop code which is visible at the stop
              public var code: String? {
                get {
                  return resultMap["code"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "code")
                }
              }

              /// Name of the stop, e.g. Pasilan asema
              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }
            }
          }

          public struct Trip: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Trip"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("tripHeadsign", type: .scalar(String.self)),
                GraphQLField("routeShortName", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(tripHeadsign: String? = nil, routeShortName: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Trip", "tripHeadsign": tripHeadsign, "routeShortName": routeShortName])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Headsign of the vehicle when running on this trip
            public var tripHeadsign: String? {
              get {
                return resultMap["tripHeadsign"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "tripHeadsign")
              }
            }

            /// Short name of the route this trip is running. See field `shortName` of Route.
            public var routeShortName: String? {
              get {
                return resultMap["routeShortName"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "routeShortName")
              }
            }
          }

          public struct LegGeometry: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Geometry"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("length", type: .scalar(Int.self)),
                GraphQLField("points", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(length: Int? = nil, points: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Geometry", "length": length, "points": points])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The number of points in the string
            public var length: Int? {
              get {
                return resultMap["length"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "length")
              }
            }

            /// List of coordinates of in a Google encoded polyline format (see https://developers.google.com/maps/documentation/utilities/polylinealgorithm)
            public var points: String? {
              get {
                return resultMap["points"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "points")
              }
            }
          }
        }
      }
    }
  }
}
