
//  Created by Devine Lu Linvega on 2015-07-07.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class PanelHatch : MainPanel
{
	let outline = Empty()
	var count:Int = 0
	
	override init()
	{
		super.init()
		
		name = "hatch"
		details = "jetisons items"
		
		mainNode.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: 0.7, z: 0),  SCNVector3(x: 0.7, y: 0, z: 0)],color:grey))
		mainNode.addChildNode(SCNLine(vertices: [SCNVector3(x: 0.7, y: 0, z: 0), SCNVector3(x: 0, y: -0.7, z: 0)],color:grey))
		mainNode.addChildNode(SCNLine(vertices: [SCNVector3(x: -0.7, y: 0, z: 0), SCNVector3(x: 0, y: 0.7, z: 0)],color:grey))
		mainNode.addChildNode(SCNLine(vertices: [SCNVector3(x: -0.7, y: 0, z: 0), SCNVector3(x: 0, y: -0.7, z: 0)],color:grey))
		
		let outline1 = SCNLine(vertices: [SCNVector3(x: 0, y: 0.5, z: 0), SCNVector3(x: 0.5, y: 0, z: 0)],color:red)
		outline.addChildNode(outline1)
		let outline2 = SCNLine(vertices: [SCNVector3(x: 0.5, y: 0, z: 0), SCNVector3(x: 0, y: -0.5, z: 0)],color:red)
		outline.addChildNode(outline2)
		let outline3 = SCNLine(vertices: [SCNVector3(x: -0.5, y: 0, z: 0), SCNVector3(x: 0, y: 0.5, z: 0)],color:red)
		outline.addChildNode(outline3)
		let outline4 = SCNLine(vertices: [SCNVector3(x: -0.5, y: 0, z: 0), SCNVector3(x: 0, y: -0.5, z: 0)],color:red)
		outline.addChildNode(outline4)
		
		mainNode.addChildNode(outline)
		
		// Trigger
		
		mainNode.addChildNode(SCNTrigger(host: self, size: CGSize(width: 2, height: 2)))
		
		decals.empty()
		
		detailsLabel.update("empty", color: grey)
	}
	
	override func whenStart()
	{
		super.whenStart()
		
		update()
	}

	override func touch(id:Int = 0)
	{
		if port.isReceiving() == false { return }
		if port.origin.event.isQuest == true { return }
		
		if port.origin.host == pilot {
			game.erase()
			return
		}
		
		port.origin.removeEvent()
		count += 1
		update()
		missions.refresh()
		audio.playSound("click3")
	}
	
	override func update()
	{
		var load:Event!
		
		load = (port.origin == nil) ? nil : port.origin.event
		
		if load != nil {
			if load.isQuest == true || (load is Item) == false {
				detailsLabel.update("error", color: red)
				outline.updateChildrenColors(red)
			}
			else{
				detailsLabel.update("jetison", color: cyan)
				outline.updateChildrenColors(cyan)
			}
		}
		else{
			detailsLabel.update("empty", color: grey)
			outline.updateChildrenColors(grey)
		}
	}
	
	override func onConnect()
	{
		super.onConnect()
		
		if port.origin == nil && port.origin.host == nil && port.origin.host == pilot {
			detailsLabel.update("erase game ?", color: red)
			outline.updateChildrenColors(red)
		}
	}
	
	override func onDisconnect()
	{
		update()
	}
	
	override func onInstallationBegin()
	{
		super.onInstallationBegin()
		
		player.lookAt(deg: -315)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
