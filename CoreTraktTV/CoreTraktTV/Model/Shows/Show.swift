//
//  Show.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado   
//  
//

import Foundation

public struct Show: Codable
{
    public private(set) var title: String
    public private(set) var year: Int
    public private(set) var identifiers: Identifiers

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case title
        case year
        case identifiers = "ids"
    }
}
