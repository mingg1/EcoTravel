import Foundation
import Apollo

protocol ItineraryManagerDelegate {
    func didUpdateData(_ itineraryManager: ItineraryManager, data: [Itineraries])
}

class ItineraryManager {
    private let endPoint = "https://api.digitransit.fi/routing/v1/routers/finland/index/graphql"
    
    lazy var apollo = ApolloClient(url: URL(string: endPoint)!)
    
    var itineraries = [Itineraries]()
    var delegate: ItineraryManagerDelegate?
    
    func fetchItinerary(originLat:Double, originLon:Double, destLat:Double, destLon:Double){
        apollo.fetch(query: FindRoutesQuery(originLat: originLat, originLon: originLon, destLat: destLat, destLon: destLon)){
            result in
            switch result {
            case .success(let receivedResult):
                print("%%%%%------------")

                if let data = receivedResult.data?.plan?.jsonObject {
                    let serialized = try! JSONSerialization.data(withJSONObject: data, options: [])
                    do{
                        let itineraries = try JSONDecoder().decode(Plan.self, from: serialized).itineraries
                        self.itineraries = itineraries
                        self.delegate?.didUpdateData(self, data: self.itineraries)
                    }catch let error{
                        print(error)
                    }
                }
                
            case.failure(let error):
                print ("error:",error)
            }
        }
    }
}
