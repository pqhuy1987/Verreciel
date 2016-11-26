
//  Created by Devine Lu Linvega on 2015-12-15.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class Widget : Panel
{
	var label:SCNLabel!
	var port:SCNPortSlot!
	var requirement:ItemTypes!
	var isPowered:() -> Bool = { return false }
	
	override init()
	{
		super.init()
		
		port = SCNPortSlot(host: self, align: .center, placeholder:"--")
		port.position = SCNVector3(0,-0.7,templates.radius)
		port.disable()
		port.label.updateScale(0.05)
		port.label.position = SCNVector3(0,-0.35,0)
		
		label = SCNLabel(text:"", scale:0.075, align:.center)
		label.position = SCNVector3(0,0.35,0)
		port.addChildNode(label)
		
		root.addChildNode(port)
		
		root.hide()
	}
	
	override func onConnect()
	{
		refresh()
	}
	
	override func onDisconnect()
	{
		refresh()
	}
	
	override func refresh()
	{
		if isPowered() == true {
			onPowered()
		}
		else{
			onUnpowered()
		}
	}
	
	override func onUploadComplete()
	{
		if port.hasEvent() == false { return }
		
		if (port.event as! Item).type != requirement { port.label.update(red) }
		else{ port.label.update(white) }
	}
	
	// MARK: Powered
	
	func onPowered()
	{
		label.update(white)
		port.enable()
	}
	
	func onUnpowered()
	{
		label.update(grey)
		port.disable()
	}
	
	// MARK: Installation -
	
	var installNode:Empty = Empty()
	var installProgressBar = SCNProgressBar(width: 1)
	var installLabel = SCNLabel(text:"install", scale:0.075, color:grey, align:.center)
	
	override func onInstallationBegin()
	{
		super.onInstallationBegin()
		
		helmet.addWarning("Installing", duration: 3, flag:"install")
		
		installNode = Empty()
		installNode.position = SCNVector3(0,-0.6,templates.radius)
		
		installProgressBar = SCNProgressBar(width: 1)
		installProgressBar.position = SCNVector3(-installProgressBar.width/2,0,0)
		installNode.addChildNode(installProgressBar)
		
		installLabel.position = SCNVector3(0,-0.35,0)
		installNode.addChildNode(installLabel)
		
		addChildNode(installNode)
	}
	
	override func installProgress()
	{
		super.installProgress()
		
		installLabel.update("Install \(Int(installPercentage))%")
		installProgressBar.update(installPercentage)
	}
	
	override func onInstallationComplete()
	{
		super.onInstallationComplete()
		
		installNode.removeFromParentNode()
		installNode.hide()
		
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(0.7)
		root.show()
		SCNTransaction.commit()
		
		port.enable()
		label.update(name!, color: white)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
	    fatalError("init(coder:) has not been implemented")
	}
}
