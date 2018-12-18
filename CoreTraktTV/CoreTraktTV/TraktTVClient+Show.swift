//
//  TraktTVClient+Show.swift
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//

import Foundation

//
// Shows Operations
//

extension TraktTVClient
{
    /**

    */
    public func trendingShows(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<TrendyShow>) -> Void
    {
        let trendingURL = "https://private-anon-ff83fde95d-trakt.apiary-proxy.com/movies/popular"
        
        guard let request = self.makeURLRequest(string: trendingURL, withFilters: filters, paginationOptions: pagination) else
        {
            handler(nil, nil, .preconditionFailed)
            return
        }
        
        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
            case .success(let data, let pagination):
                if let shows = try? self.decoder.decode([TrendyShow].self, from: data)
                {
                    handler(shows, pagination, nil)
                }
            case .requestError(let code, let message):
                #if targetEnvironment(simulator)
                print("popular Movies", message)
                #endif
                
                let error = TraktError(httpCode: code)
                handler(nil, nil, error)
                
            case .connectionError:
                handler(nil, nil, TraktError.serverIsDown)
            }
        }
    }
    /**

    */
    
}
