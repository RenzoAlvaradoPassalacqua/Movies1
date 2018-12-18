//
//  GrantType.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado  .
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal enum GrantType: String, Codable
{
    /// Using to obtain access token
    case authorizationCode = "authorization_code"
    /// Using for refresh
    case refreshToken = "refresh_token"
}
