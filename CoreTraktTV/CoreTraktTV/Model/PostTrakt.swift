//
//  PostTrakt.swift
//  CoreTraktTV
//
//  Created by Renzo Alvarado   
//  
//

import Foundation

public struct PostTrakt: Codable
{
    /// Shows que vamos a actualizar
    public private(set) var movies: [Movie]?

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case movies
    }
}
