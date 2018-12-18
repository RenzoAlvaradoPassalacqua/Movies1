//
//  TimePeriod.swift
//  CoreTraktTV
//
//  Created by ARenzo Alvarado
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
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
