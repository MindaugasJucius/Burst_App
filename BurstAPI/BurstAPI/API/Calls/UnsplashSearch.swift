import Alamofire

public typealias SearchResultsCallback<U> = (_ results: SearchResults<U>) -> ()

public class UnsplashSearch: NSObject {
    
    public static func photos(forQuery query: String,
                              resultsPage page: Int,
                              success: @escaping SearchResultsCallback<Photo>,
                              failure: @escaping ErrorCallback) -> DataRequest {
        let params = [QueryParams.burstID.rawValue: QueryParams.appId, "page": String(page), "query": query] as [String : Any]
        let request = Alamofire.request(UnsplashSearchPhotosURL, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let searchResultJSON = value as? NSDictionary else { return }
                UnboxSerializer.parse(response: searchResultJSON,
                    success: { (searchResults: SearchResults) in
                        success(searchResults)
                    },
                    failure: { error in
                        failure(error)
                    }
                )
            case .failure(let error):
                failure(error)
            }
        }
        return request
    }
}
