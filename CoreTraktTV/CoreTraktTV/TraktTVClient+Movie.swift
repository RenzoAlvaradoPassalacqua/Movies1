//
//  TraktTVClient+Movie.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

//
// Shows Operations
//

extension TraktTVClient
{
    /**

    */
    public func trendingMovies(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<TrendyMovie>) -> Void
    {
        let trendingURL = "https://private-anon-a087b86f4e-trakt.apiary-mock.com/movies/trending"
       
        guard let request = self.makeURLRequest(string: trendingURL, withFilters: filters, paginationOptions: pagination) else
        {
            handler(nil, nil, .preconditionFailed)
            return 
        }

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
                case .success(let data, let pagination):
                    if let movies = try? self.decoder.decode([TrendyMovie].self, from: data)
                    {
                        handler(movies, pagination, nil)
                    }
                case .requestError(let code, let message):
                    #if targetEnvironment(simulator)
                        print("popular Movies error", message)
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
    public func popularMovies(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<Movie>) -> Void
    {
        //let trendingURL = "https://api.trakt.tv/shows/popular"
        let trendingURL = "https://private-anon-a087b86f4e-trakt.apiary-mock.com/movies/popular"
        
        guard let request = self.makeURLRequest(string: trendingURL, withFilters: filters, paginationOptions: pagination) else
        {
            handler(nil, nil, .preconditionFailed)
            return 
        }

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
            case .success(let data, let pagination):
                if let movies = try? self.decoder.decode([Movie].self, from: data)
                {
                    handler(movies, pagination, nil)
                }
            case .requestError(let code, let message):
                #if targetEnvironment(simulator)
                    print(message)
                #endif
                
                let error = TraktError(httpCode: code)
                handler(nil, nil, error)

            case .connectionError:
                handler(nil, nil, TraktError.serverIsDown)
            }
        }
    }
}
