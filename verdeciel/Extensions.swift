
//  Created by Devine Lu Linvega on 2016-02-10.
//  Copyright © 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

extension UIColor
{
	func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)?
	{
		var fRed : CGFloat = 0
		var fGreen : CGFloat = 0
		var fBlue : CGFloat = 0
		var fAlpha: CGFloat = 0
		if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
			return (red:fRed, green:fGreen, blue:fBlue, alpha:fAlpha)
		} else {
			return nil
		}
	}
}

extension Float
{
	func abs () -> Float {
		return fabsf(self)
	}
	
	func clamp (min: Float, _ max: Float) -> Float
	{
		return Swift.max(min, Swift.min(max, self))
	}
	
	func random(min: Float = 0, max: Float) -> Float
	{
		let diff = max - min;
		let rand = Float(arc4random() % (UInt32(RAND_MAX) + 1))
		return ((rand / Float(RAND_MAX)) * diff) + min;
	}
}

