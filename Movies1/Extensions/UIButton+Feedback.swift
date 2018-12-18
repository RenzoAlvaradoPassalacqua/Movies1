//
//  UIButton+Feedback.swift
//  desappstre framework
//
//  Created by Renzo Alvarado
 
//

import UIKit
import Foundation
import AudioToolbox

public extension UIButton
{
    /**
 
    */
	public func tapFeedback() -> Void
	{
		AudioServicesPlaySystemSound(1104)
	}
}
