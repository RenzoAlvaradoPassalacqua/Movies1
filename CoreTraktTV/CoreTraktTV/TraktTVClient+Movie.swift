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
    public func paginationURL(currentpage :Int, goToNext :Bool) -> String?
    {
        var components = URLComponents(string: "https://private-anon-a087b86f4e-trakt.apiary-mock.com/movies/popular")
        // ?page={page}&limit={limit}
        
        var page = currentpage
        if (goToNext){
            page = page + 1
            print ("page", page)
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(10)")
        ]
        
        components?.queryItems = queryItems
        
        return components?.url?.absoluteString
    }
    
    public func popularMovies(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, nextPage :Int? = nil ,handler: @escaping TraktPaginatedCompletionHandler<Movie>) -> Void
    {
       
        
        var  trendingURL = "https://private-anon-a087b86f4e-trakt.apiary-mock.com/movies/popular"
        if (nextPage != nil && nextPage!>0){
            trendingURL = self.paginationURL(currentpage: nextPage!, goToNext: true)!
            print ("trendingURL pagination", trendingURL)
        }
         
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
