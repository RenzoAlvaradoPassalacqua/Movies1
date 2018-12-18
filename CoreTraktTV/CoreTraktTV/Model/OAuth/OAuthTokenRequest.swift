//
//  OAuthTokenRequest.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado 
//

import Foundation

internal struct OAuthTokenRequest: Codable
{
    ///
    internal var code: String
    ///
    internal let clientID: String
    ///
    internal let clientSecret: String
    ///
    internal let redirectURI: String
    ///
    internal let grantType: String

    /**

    */
    public init(code: String)
    {
        self.code = code

        self.clientID = TraktTVClient.shared.clientID
        self.clientSecret = TraktTVClient.shared.clientSecret
        self.redirectURI = TraktTVClient.shared.redirecURL.absoluteString
        self.grantType = GrantType.authorizationCode.rawValue
    } 

}
