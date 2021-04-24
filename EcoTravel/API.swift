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
    query findRoutes {
      plan(
        from: {lat: 60.168992, lon: 24.932366}
        to: {lat: 60.175294, lon: 24.684855}
        numItineraries: 3
      ) {
        __typename
        itineraries {
          __typename
          legs {
            __typename
            startTime
            endTime
            mode
            duration
            realTime
            distance
            transitLeg
          }
        }
      }
    }
    """

  public let operationName: String = "findRoutes"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("plan", arguments: ["from": ["lat": 60.168992, "lon": 24.932366], "to": ["lat": 60.175294, "lon": 24.684855], "numItineraries": 3], type: .object(Plan.selections)),
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
            GraphQLField("legs", type: .nonNull(.list(.object(Leg.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(legs: [Leg?]) {
          self.init(unsafeResultMap: ["__typename": "Itinerary", "legs": legs.map { (value: Leg?) -> ResultMap? in value.flatMap { (value: Leg) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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
              GraphQLField("startTime", type: .scalar(String.self)),
              GraphQLField("endTime", type: .scalar(String.self)),
              GraphQLField("mode", type: .scalar(Mode.self)),
              GraphQLField("duration", type: .scalar(Double.self)),
              GraphQLField("realTime", type: .scalar(Bool.self)),
              GraphQLField("distance", type: .scalar(Double.self)),
              GraphQLField("transitLeg", type: .scalar(Bool.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(startTime: String? = nil, endTime: String? = nil, mode: Mode? = nil, duration: Double? = nil, realTime: Bool? = nil, distance: Double? = nil, transitLeg: Bool? = nil) {
            self.init(unsafeResultMap: ["__typename": "Leg", "startTime": startTime, "endTime": endTime, "mode": mode, "duration": duration, "realTime": realTime, "distance": distance, "transitLeg": transitLeg])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
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

          /// The mode (e.g. `WALK`) used when traversing this leg.
          public var mode: Mode? {
            get {
              return resultMap["mode"] as? Mode
            }
            set {
              resultMap.updateValue(newValue, forKey: "mode")
            }
          }

          /// The leg's duration in seconds
          public var duration: Double? {
            get {
              return resultMap["duration"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "duration")
            }
          }

          /// Whether there is real-time data about this Leg
          public var realTime: Bool? {
            get {
              return resultMap["realTime"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "realTime")
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

          /// Whether this leg is a transit leg or not.
          public var transitLeg: Bool? {
            get {
              return resultMap["transitLeg"] as? Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "transitLeg")
            }
          }
        }
      }
    }
  }
}
