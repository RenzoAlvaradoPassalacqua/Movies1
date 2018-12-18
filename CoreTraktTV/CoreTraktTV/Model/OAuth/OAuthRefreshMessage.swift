//
//  OAuthRefreshMessage.swift
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//

import Foundation

protocol OAuthRefreshMessage: OAuthTokenMessage
{
    var refreshToken: String { get } 
}
