
//  Created by Devine Lu Linvega on 2015-12-14.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class SCNPortSlot : SCNPort
{
	var hasDetails:Bool = false
	var label:SCNLabel!
	var detailsLabel:SCNLabel!
	var placeholder:String!
	
	init(host:Empty = Empty(), align:alignment! = .left, hasDetails:Bool = false, placeholder:String = "Empty")
	{
		super.init(host:host)
		
		self.placeholder = placeholder
		self.hasDetails = hasDetails
		
		self.geometry = SCNPlane(width: 0.3, height: 0.3)
		self.geometry?.firstMaterial?.diffuse.contents = clear
		
		trigger = SCNTrigger(host: self, size: CGSize(width: 1, height: 1))
		trigger.position = SCNVector3(0,0,-0.1)
		self.addChildNode(trigger)
		
		label = SCNLabel(text:placeholder,scale:0.1,color:grey,align:align)
		self.addChildNode(label)
		
		detailsLabel = SCNLabel(text:"",scale:0.075,color:grey,align:align)
		self.addChildNode(detailsLabel)
		
		self.host = host
		
		if align == nil { label.hide() ; detailsLabel.hide() }
		else if align == alignment.left { label.position = SCNVector3(0.3,0,0) ; detailsLabel.position = SCNVector3(0.3,-0.3,0) }
		else if align == alignment.right { label.position = SCNVector3(-0.3,0,0) ; detailsLabel.position = SCNVector3(-0.3,-0.3,0) }
		else if align == alignment.center { label.position = SCNVector3(0,-0.5,0) ; detailsLabel.position = SCNVector3(0,-0.8,0) }
		
		disable()
	}
	
	override func whenRenderer()
	{
		super.whenRenderer()
		
		if isEnabled == false {
			sprite_input.update(clear)
		}
		else if event != nil {
			sprite_input.update(clear)
		}
		else{
			sprite_input.update(grey)
		}
	}
	
	func refresh()
	{
		detailsLabel.opacity = (hasDetails == true) ? 1 : 0
		
		if event != nil {
			label.update(event.name!)
			detailsLabel.update(event.details)
		}
		else{
			label.update(placeholder)
			detailsLabel.update("--")
		}
		
		if isEnabled == false { label.update(grey) }
		else if requirement != nil && event != nil && requirement.name == event.name { label.update(cyan) }
		else if requirement != nil && event != nil && requirement.name != event.name { label.update(red) }
		else if event != nil { label.update(white) }
		else{ label.update(grey) }
	}
	
	override func removeEvent()
	{
		super.removeEvent()
		refresh()
	}
	
	override func onConnect()
	{
		super.onConnect()

		if origin != nil && origin.event != nil && event == nil {
			if origin.event is Item && (origin.event as! Item).type != .cargo {
				upload(origin.event as! Item)
			}
		}
	}
	
	override func onDisconnect()
	{
		super.onDisconnect()
		host.onDisconnect()
	}
	
	override func addEvent(event:Event)
	{
		super.addEvent(event)
		refresh()
	}
	
	// MARK: Upload -
	
	var upload:Event!
	var uploadTimer:NSTimer!
	var uploadPercentage:Float = 0
	
	func upload(item:Item)
	{
		upload = item
		uploadTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(self.uploadProgress), userInfo: nil, repeats: true)
	}
	
	func uploadProgress()
	{
		if origin == nil { uploadCancel() ; return }
		
		uploadPercentage += Float(arc4random_uniform(60))/10
		if uploadPercentage > 100 {
			origin.wire.isUploading = false
			uploadComplete()
			
		}
		else{
			origin.wire.isUploading = true
			label.update("\(Int(uploadPercentage))%", color:grey)
		}
	}
	
	func enable(text:String,color:UIColor! = nil)
	{
		super.enable()
		
		label.update(text)
		if color != nil { label.update(text,color:color) }
	}
	
	func disable(text:String,color:UIColor! = nil)
	{
		super.disable()
		
		label.update(text)
		if color != nil { label.update(text,color:color) }
	}
	
	func uploadComplete()
	{
		if (origin != nil) { addEvent(syphon()) }
		uploadTimer.invalidate()
		uploadPercentage = 0
		refresh()
		
		host.onUploadComplete()
	}
	
	func uploadCancel()
	{
		uploadTimer.invalidate()
		uploadPercentage = 0
		refresh()
	}

	required init(coder aDecoder: NSCoder)
	{
	    fatalError("init(coder:) has not been implemented")
	}
}
