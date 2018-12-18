//
//  TraktTVClient
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//

import Foundation

public typealias TraktPaginatedCompletionHandler<T> = (_ results: [T]?, _ pagination: Pagination?, _ error: TraktError?) -> (Void)

public typealias TraktCompletionHandler<T> = (_ result: [T]?, _ error: TraktError?) -> (Void)

public typealias TraktPostCompletionHandler = (_ validOperation: Bool, _ error: TraktError?) -> (Void)

///
/// All API request will be *returned* here
///

internal typealias HttpRequestCompletionHandler = (_ result: HttpResult) -> (Void)


public class TraktTVClient
{
    ///
    public static let shared = TraktTVClient()

    internal let clientID: String
    internal let clientSecret: String
    internal let redirecURL: URL

    internal var accessToken: String?
    internal var refreshToken: String?

    internal let encoder: JSONEncoder
    internal let decoder: JSONDecoder
    
    /// HTTP session ...
    private var httpSession: URLSession!
    /// ...and his configuración
    private var httpConfiguration: URLSessionConfiguration!

    /**

    */
    private init()
    {
        self.clientID = "e4041040767b33ba196853acab5f4c02dbeb8c1680b793b93b1d140ac9c60535"
        self.clientSecret = "b6db84039ba269c9ab2e3ee2e76d9983bfba53a6451172f309f53e3d8e520d68"
        self.redirecURL = URL(string: "moviesapp://oauth")!

        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = .prettyPrinted
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.httpConfiguration = URLSessionConfiguration.default
        self.httpConfiguration.httpMaximumConnectionsPerHost = 10
        
        let http_queue: OperationQueue = OperationQueue()
        http_queue.maxConcurrentOperationCount = 10
        
        self.httpSession = URLSession(configuration:self.httpConfiguration,
                                      delegate:nil,
                                      delegateQueue:http_queue)
    }

    //
    // MARK: - HTTP Methods
    //

    /**

    */
    internal func makeURLRequest(string uri: String, withFilters filters: [FilterValue]? = nil, paginationOptions pagination: [FilterValue]? = nil, authenticationRequired: Bool = false) -> URLRequest?
    {
        guard let url = URL(string: uri) else
        {
            return nil
        }

        var request: URLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(self.clientID, forHTTPHeaderField: "trakt-api-key")

        if let accessToken = self.accessToken, authenticationRequired
        {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
         

        return request
    }
    
    /**
 
    */
    private func recoverPaginationData(fromResponse response: HTTPURLResponse) -> Pagination?
    {
        guard let currentPageHeader = response.allHeaderFields["x-pagination-page"] as? String,
              let itemsPerPageHeader = response.allHeaderFields["x-pagination-limit"] as? String,
              let totalPagesHeader = response.allHeaderFields["x-pagination-page-count"] as? String,
              let totalItemsHeader = response.allHeaderFields["x-pagination-item-count"] as? String
        else
        {
            return nil
        }
        
        guard let currentPage = Int(currentPageHeader),
              let itemsPerPage = Int(itemsPerPageHeader),
              let totalPages = Int(totalPagesHeader),
              let totalItems = Int(totalItemsHeader)
        else
        {
            return nil
        }
        
        return Pagination(currentPage: currentPage, itemsPageCount: itemsPerPage, pageCount: totalPages, itemsCount: totalItems)
    }

    /**
        URL request operation
        - Parameters:
            - request: `URLRequest` requested
            - completionHandler: HTTP operation result
    */
    internal func processRequest(_ request: URLRequest, httpHandler: @escaping HttpRequestCompletionHandler) -> Void
    {
        let data_task: URLSessionDataTask = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error
            {
                #if targetEnvironment(simulator)
                    print(error.localizedDescription)
                #endif
                
                httpHandler(HttpResult.connectionError)
                return
            }

            guard let data = data, let http_response = response as? HTTPURLResponse else
            {
                httpHandler(HttpResult.connectionError)
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    let pagination = self.recoverPaginationData(fromResponse: http_response)
                    httpHandler(HttpResult.success(data: data, pagination: pagination))
                
                case 201...204:
                    httpHandler(HttpResult.success(data: data, pagination: nil))
                
                default:
                    let code: Int = http_response.statusCode
                    let message: String = HTTPURLResponse.localizedString(forStatusCode: code)

                    httpHandler(HttpResult.requestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}
