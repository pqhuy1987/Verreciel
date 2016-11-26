//  Created by Devine Lu Linvega on 2015-10-07.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class Structure : Empty
{
	let rot = Empty()
	let pos = Empty()
	
	let root = Empty()
	var host:Location!
	
	override init()
	{
		super.init()
		
		addChildNode(rot)
		rot.addChildNode(pos)
		pos.addChildNode(root)
	}
	
	func addHost(host:Location)
	{
		self.host = host
//		update()
	}
	
	override func whenRenderer()
	{
		super.whenRenderer()
		
		let distance = (host is LocationConstellation) ? host.distance/settings.approach * 100 : pow(host.distance/settings.approach, 5) * 1000.0
		
		pos.position = SCNVector3(0,distance,0)
		
		if capsule.isDockedAtLocation(host){
			rot.eulerAngles.z = (degToRad(0))
		}
		else if capsule.lastLocation == host {
			rot.eulerAngles.z = (degToRad(0))
			pos.position = SCNVector3(0,distance * -1,0)
		}
		else{
			rot.eulerAngles.z = (degToRad(host.align))
		}
		
		rot.eulerAngles.y = (degToRad(capsule.direction))
		
		if host.distance > settings.approach {
			onLeave()
		}
	}

	var morphTime:Int = 0
	var morphTimer:NSTimer!
	
	func onDock()
	{
		morph()
	}
	
	func onSight()
	{
		show()
	}
	
	func onUndock()
	{
		
	}
	
	func onComplete()
	{
		update()
	}
	
	func onLeave()
	{
		self.removeFromParentNode()
	}
	
	func dockUpdate()
	{
	
	}
	
	func sightUpdate()
	{
	
	}
	
	override func update()
	{
		super.update()
		
		if host.isComplete == nil { root.updateChildrenColors(grey) }
		else if host.isComplete == true { root.updateChildrenColors(cyan) }
		else{ root.updateChildrenColors(red) }
	}
	
	func morph()
	{
		morphTime += 1
		if capsule.isDocked == true {
			delay(2, block: { self.morph() })
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
