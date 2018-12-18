//
//  OAuthTokenResponse.swift
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//

import Foundation

internal struct OAuthTokenResponse: Codable
{
    ///
    internal let accessToken: String
    ///
    internal let tokenType: String
    ///
    internal let refreshToken: String
    ///
    internal let expiresIn: Int
    ///
    internal let scope: String
    ///
    internal let createdAt: Int

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope = "scope"
        case createdAt = "created_at"
    }

}
