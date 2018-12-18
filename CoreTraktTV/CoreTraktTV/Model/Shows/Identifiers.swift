//
//  Identifiers.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado   
//  
//

import Foundation

public struct Identifiers: Codable
{
    public private(set) var trakt: Int
    public private(set) var slug: String
    public private(set) var tvdb: Int
    public private(set) var imdb: String
    public private(set) var tmdb: Int
    public private(set) var tvRage: Int?

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case trakt
        case slug
        case tvdb
        case imdb
        case tmdb
        case tvRage = "tvrage"
    }
}

