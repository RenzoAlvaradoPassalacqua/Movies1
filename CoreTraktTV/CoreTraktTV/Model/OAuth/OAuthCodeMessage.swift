//
//  OAuthCodeMessage.swift
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//

import Foundation

protocol OAuthCodeMessage: OAuthTokenMessage
{
    var code: String { get }  
}
