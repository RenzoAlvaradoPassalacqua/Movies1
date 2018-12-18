//
//  FilterValue.swift
//  CoreTraktTV
//
//  Modified by Renzo Alvarado
//  
//


import Foundation

public protocol FilterValue
{
    ///
    var queryItem: URLQueryItem { get }
}
