//  Created by Devine Lu Linvega on 2015-08-28.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class SCNPortRedirect : SCNPort
{
	override func removeEvent()
	{
		let redirectedHost = console.port.origin.host as! PanelCargo
		redirectedHost.removeItem(event as! Item)
		disable()
	}
	
	override func disable()
	{
		isEnabled = false
		disconnect()
		trigger.disable()
	}
	
	override func whenRenderer()
	{
		super.whenRenderer()
		
		if event != nil { sprite_input.updateChildrenColors(clear) }
	}
	
	override func disconnect()
	{
		if self.connection == nil { return }
		
		let stored_connection = self.connection
		let stored_connection_host = self.connection.host
		
		self.connection.origin = nil
		self.connection = nil
		
		stored_connection.onDisconnect()
		stored_connection_host.onDisconnect()
		host.onDisconnect()
		
		wire.disable()
	}
}
