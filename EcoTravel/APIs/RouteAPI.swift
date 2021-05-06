/**
 * 
 * Author Minji Choi
 * since 2021-04-24
 */

import Foundation
import Apollo

/// Protocol for updating itinerary data
protocol ItineraryManagerDelegate {
    /**
     - parameter itineraryManager: ItineraryManager class
     - parameter data: array of itineraries
     */
    func didUpdateData(_ itineraryManager: ItineraryManager, data: [Itineraries])
}

/// class for fetching and parsing graphQL query results
class ItineraryManager {
    // GraphQL data endpoint
    private let endPoint = "https://api.digitransit.fi/routing/v1/routers/finland/index/graphql"
    
    lazy var apollo = ApolloClient(url: URL(string: endPoint)!)
    
    var itineraries = [Itineraries]()
    var delegate: ItineraryManagerDelegate?
    
    /**
     * function for fetching query result, serializing, and decoding it.
     * When the data is decoded and saved into itineraries array, call didUpdateData function from delegate.
     - parameter originLat: latitude of the origin
     - parameter originLon: longitude of the origin
     - parameter destLat: latitude of the destination
     - parameter destLon: longitude of the destination
     */
    func fetchItinerary(originLat:Double, originLon:Double, destLat:Double, destLon:Double){
        apollo.fetch(query: FindRoutesQuery(originLat: originLat, originLon: originLon, destLat: destLat, destLon: destLon)){
            result in
            switch result {
            case .success(let receivedResult):
                if let data = receivedResult.data?.plan?.jsonObject {
                    let serialized = try! JSONSerialization.data(withJSONObject: data, options: [])
                    do{
                        let itineraries = try JSONDecoder().decode(Plan.self, from: serialized).itineraries
                        self.itineraries = itineraries
                        self.delegate?.didUpdateData(self, data: self.itineraries)
                    }catch let error{
                        print("error: ",error)
                    }
                }
            case.failure(let error):
                print ("error:",error)
            }
        }
    }
}
