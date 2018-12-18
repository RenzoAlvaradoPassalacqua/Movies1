//
//  TimePeriod.swift
//  CoreTraktTV
//
//  Created by ARenzo Alvarado
//

import Foundation

internal enum TimePeriod: String, Codable
{
    /// Using to obtain access token
    case weekly
    /// Using for refresh
    case monthly 
    ///
    case yearly
    ///
    case all
}
