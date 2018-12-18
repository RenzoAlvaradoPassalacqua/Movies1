//
//  OAuthTokenMessage.swift
//  CoreTraktTV
//
// 
//  //
//

import Foundation

internal protocol OAuthTokenMessage
{
    var clientSecret: String { get }
    var clientID: String { get }
    var redirectURI: String { get } 
    var grantType: GrantType { get }
}
