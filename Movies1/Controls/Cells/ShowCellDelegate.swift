//
//  ShowCellDelegate.swift
//  AppleCoding OAuth
//
//  Modified by Renzo Alvarado
//  
//


import UIKit
import Foundation

internal protocol ShowCellDelegate: AnyObject
{
    /**
        Informa de la selección una serie por parte
        del usuario

        - Parameters:
            - cell: Procendencia de la acción
            - trakID: Idenitificador de la serie
    */
    func showCell(_ cell: ShowCell, didSelectShow trackID: Int) -> Void
}
