//
//  TrendyShow.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado   
//  
//

import Foundation

public struct TrendyShow: Codable
{
    public private(set) var watchers: Int
    public private(set) var show: Show

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case watchers
        case show
    }
}
