//
//  TrendyMovie.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado   
//  
//

import Foundation

public struct TrendyMovie: Codable
{
    //public private(set) var watchers: Int
    public private(set) var movie: Movie

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        //case watchers
        case movie
    }
}
