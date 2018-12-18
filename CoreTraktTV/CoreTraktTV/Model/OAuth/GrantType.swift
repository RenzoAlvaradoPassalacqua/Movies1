//
//  GrantType.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado
//

import Foundation

internal enum GrantType: String, Codable
{
    /// Using to obtain access token
    case authorizationCode = "authorization_code"
    /// Using for refresh
    case refreshToken = "refresh_token"
}
