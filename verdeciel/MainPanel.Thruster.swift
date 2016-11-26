
//  Created by Devine Lu Linvega on 2015-07-06.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class PanelThruster : MainPanel
{
	var accelerate:SCNTrigger!
	var decelerate:SCNTrigger!
	var action:SCNTrigger!
	
	// Speed Lines
	var interface_flight = Empty()
	var line1:SCNLine!
	var line2:SCNLine!
	var line3:SCNLine!
	var line4:SCNLine!
	
	var interface_cutlines = Empty()
	var cutLine1:SCNLine!
	var cutLine2:SCNLine!
	var cutLine3:SCNLine!
	var cutLine4:SCNLine!
	
	// Docking
	var interface_dock = Empty()
	
	// Warping
	var interface_warp = Empty()
	
	var lineLeft:SCNLine!
	var lineRight:SCNLine!
	
	var speed:Int = 0
	var actualSpeed:Float = 0
	
	var canWarp:Bool = false
	var isLocked:Bool = false
	
	// MARK: Default -
	
	override init()
	{
		super.init()
		
		name = "thruster"
		details = "moves the capsule"
		
		// Flight
		
		mainNode.addChildNode(interface_flight)
		
		line1 = SCNLine(vertices: [SCNVector3(-0.5, -0.3, 0), SCNVector3(0.5, -0.3, 0)], color: grey)
		line2 = SCNLine(vertices: [SCNVector3(-0.5, -0.1, 0), SCNVector3(0.5, -0.1, 0)], color: grey)
		line3 = SCNLine(vertices: [SCNVector3(-0.5, 0.1, 0), SCNVector3(0.5, 0.1, 0)], color: grey)
		line4 = SCNLine(vertices: [SCNVector3(-0.5, 0.3, 0), SCNVector3(0.5, 0.3, 0)], color: grey)
		
		interface_flight.addChildNode(line1)
		interface_flight.addChildNode(line2)
		interface_flight.addChildNode(line3)
		interface_flight.addChildNode(line4)
		
		mainNode.addChildNode(interface_cutlines)
		
		cutLine1 = SCNLine(vertices: [SCNVector3(-0.5, -0.3, 0), SCNVector3(-0.1, -0.3, 0), SCNVector3(0.5, -0.3, 0), SCNVector3(0.1, -0.3, 0)], color: grey)
		cutLine2 = SCNLine(vertices: [SCNVector3(-0.5, -0.1, 0), SCNVector3(-0.1, -0.1, 0), SCNVector3(0.5, -0.1, 0), SCNVector3(0.1, -0.1, 0)], color: grey)
		cutLine3 = SCNLine(vertices: [SCNVector3(-0.5, 0.1, 0), SCNVector3(-0.1, 0.1, 0), SCNVector3(0.5, 0.1, 0), SCNVector3(0.1, 0.1, 0)], color: grey)
		cutLine4 = SCNLine(vertices: [SCNVector3(-0.5, 0.3, 0), SCNVector3(-0.1, 0.3, 0),SCNVector3(0.5, 0.3, 0), SCNVector3(0.1, 0.3, 0)], color: grey)
		
		interface_cutlines.addChildNode(cutLine1)
		interface_cutlines.addChildNode(cutLine2)
		interface_cutlines.addChildNode(cutLine3)
		interface_cutlines.addChildNode(cutLine4)
		
		interface_cutlines.hide()
		
		// Dock
		
		mainNode.addChildNode(interface_dock)
		interface_dock.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, 0, 0), SCNVector3(0, 0.1, 0)], color: grey))
		interface_dock.addChildNode(SCNLine(vertices: [SCNVector3(0.1, 0, 0), SCNVector3(0, 0.1, 0)], color: grey))
		interface_dock.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, -0.1, 0), SCNVector3(0, 0, 0)], color: grey))
		interface_dock.addChildNode(SCNLine(vertices: [SCNVector3(0.1, -0.1, 0), SCNVector3(0, 0, 0)], color: grey))
		
		// Warp
		
		mainNode.addChildNode(interface_warp)
		var verticalOffset:CGFloat = 0.1
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(-0.4, verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0.4, verticalOffset, 0)], color: cyan))
		verticalOffset = -0.1
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(-0.4, verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0.4, verticalOffset, 0)], color: cyan))
		verticalOffset = 0.3
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(-0.4, verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0.4, verticalOffset, 0)], color: cyan))
		verticalOffset = -0.3
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0, 0.1 + verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(-0.1, verticalOffset, 0), SCNVector3(-0.4, verticalOffset, 0)], color: cyan))
		interface_warp.addChildNode(SCNLine(vertices: [SCNVector3(0.1, verticalOffset, 0), SCNVector3(0.4, verticalOffset, 0)], color: cyan))
		
		// Etcs
		
		lineLeft = SCNLine(vertices: [SCNVector3(-0.5, 0.5, 0), SCNVector3(-0.5, -0.5, 0)], color: red)
		mainNode.addChildNode(lineLeft)
		lineRight = SCNLine(vertices: [SCNVector3(0.5, 0.5, 0), SCNVector3(0.5, -0.5, 0)], color: red)
		mainNode.addChildNode(lineRight)
		
		// Triggers
		
		accelerate = SCNTrigger(host: self, size: CGSize(width: 1, height: 1), operation: 1)
		accelerate.position = SCNVector3(0, 0.5, 0)
		accelerate.addChildNode(SCNLine(vertices: [SCNVector3(0, 0.2, 0), SCNVector3(0.5, 0, 0)], color: cyan))
		accelerate.addChildNode(SCNLine(vertices: [SCNVector3(0, 0.2, 0), SCNVector3(-0.5, 0, 0)], color: cyan))
		
		decelerate = SCNTrigger(host: self, size: CGSize(width: 1, height: 1), operation: 0)
		decelerate.position = SCNVector3(0, -0.5, 0)
		decelerate.addChildNode(SCNLine(vertices: [SCNVector3(0, -0.2, 0), SCNVector3(0.5, 0, 0)], color: red))
		decelerate.addChildNode(SCNLine(vertices: [SCNVector3(0, -0.2, 0), SCNVector3(-0.5, 0, 0)], color: red))
		
		action = SCNTrigger(host: self, size: CGSize(width: 1.5, height: 1.5), operation: 2)
		
		mainNode.addChildNode(accelerate)
		mainNode.addChildNode(decelerate)
		mainNode.addChildNode(action)
		
		detailsLabel.update("--")
		
		decals.empty()
	}

	override func touch(id:Int = 0)
	{
		if id == 0 {
			speedDown()
			audio.playSound("click3")
		}
		else if id == 1 {
			speedUp()
			audio.playSound("click4")
		}
		if id == 2 {
			if canWarp == true {
				capsule.warp(pilot.port.origin.event as! Location)
			}
			else{
				capsule.undock()
			}
			audio.playSound("click2")
		}
	}
	
	override func update()
	{
		if maxSpeed() > 0 { line1.show() } else { line1.hide() }
		if maxSpeed() > 1 { line2.show() } else { line2.hide() }
		if maxSpeed() > 2 { line3.show() } else { line3.hide() }
		line4.hide()
	}
	
	override func whenRenderer()
	{
		super.whenRenderer()
		
		canWarp = false
		
		update()
		
		if isLocked == true {
			modeLocked()
		}
		else if battery.thrusterPort.isReceivingItemOfType(.battery) == false {
			speed = 0
			modeUnpowered()
		}
		else if capsule.isWarping == true {
			modeWarping()
		}
		else if port.isReceiving(items.warpDrive) == true && pilot.port.isReceivingLocationOfTypePortal() == true && abs(pilot.target.align) == 0 {
			if pilot.port.origin.event != capsule.dock{
				modeWaitingForWarp()
				canWarp = true
			}
			else{
				modeWarpError()
			}
		}
		else if port.isReceiving(items.warpDrive) == true {
			modeMisaligned()
			canWarp = true
		}
		else if capsule.isDocked == true && capsule.dock.storedItems().count > 0 {
			modeStorageBusy()
		}
		else if capsule.isDocked == true {
			modeDocked()
		}
		else if capsule.dock != nil {
			modeDocking()
		}
		else {
			modeFlight()
		}
//
		thrust()
	}
	
	// MARK: Locking
	
	func lock()
	{
		isLocked = true
	}
	
	func unlock()
	{
		isLocked = false
	}
	
	// MARK: Custom -
	
	func onPowered()
	{
		refresh()
	}
	
	func onUnpowered()
	{
		refresh()
	}
	
	// MARK: Modes -
	
	func modeFlight()
	{
		detailsLabel.update(String(format: "%.1f", actualSpeed), color:white)
		
		interface_cutlines.hide()
		interface_flight.show()
		interface_dock.hide()
		interface_warp.hide()
		
		if speed > 0 { line1.color(white) } else { line1.color(grey) }
		if speed > 1 { line2.color(white) } else { line2.color(grey) }
		if speed > 2 { line3.color(white) } else { line3.color(grey) }
		if speed > 3 { line4.color(white) } else { line4.color(grey) }
		
		action.disable()
		
		accelerate.enable()
		decelerate.enable()
		
		accelerate.updateChildrenColors((speed == maxSpeed() ? grey : cyan))
		decelerate.updateChildrenColors((speed == 0 ? grey : red))
		
		lineLeft.color(clear)
		lineRight.color(clear)
		
		interface_dock.hide()
		interface_flight.show()
	}
	
	func modeLocked()
	{
		detailsLabel.update("locked", color:grey)
		
		interface_flight.hide()
		interface_dock.show()
		interface_warp.hide()
		
		action.disable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(grey)
		decelerate.updateChildrenColors(grey)
		
		lineLeft.color(grey)
		lineRight.color(grey)
	}
	
	func modeWarping()
	{
		detailsLabel.update("warping", color:white)
		
		interface_flight.hide()
		interface_dock.hide()
		interface_warp.blink()
		
		action.disable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(clear)
		decelerate.updateChildrenColors(clear)
		
		line1.show() ; cutLine1.hide()
		line2.show() ; cutLine2.hide()
		line3.show() ; cutLine3.hide()
		line4.show() ; cutLine4.hide()
		
		line1.blink()
		line2.blink()
		line3.blink()
		line4.blink()
		
		lineLeft.color(clear)
		lineRight.color(clear)
	}
	
	func modeWaitingForWarp()
	{
		detailsLabel.update("warp", color:white)
		
		interface_flight.hide()
		interface_dock.hide()
		interface_warp.show()
		interface_warp.updateChildrenColors(cyan)
		
		action.enable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(cyan)
		decelerate.updateChildrenColors(cyan)
		
		lineLeft.color(cyan)
		lineRight.color(cyan)
	}
	
	func modeWarpError()
	{
		detailsLabel.update("error", color:red)
		
		interface_flight.hide()
		interface_dock.hide()
		interface_warp.show()
		interface_warp.updateChildrenColors(red)
		
		action.disable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(red)
		decelerate.updateChildrenColors(red)
		
		lineLeft.color(red)
		lineRight.color(red)
	}
	
	func modeMisaligned()
	{
		if pilot.target == nil { return }
		if pilot.target.align == nil { return }
		
		detailsLabel.update("\(String(format: "%.1f",(abs(pilot.target.align)/180)*100))%", color:red)
		
		interface_flight.hide()
		interface_dock.hide()
		interface_warp.updateChildrenColors(grey)
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(red)
		decelerate.updateChildrenColors(red)
		
		line1.show() ; cutLine1.hide() 
		line2.show() ; cutLine2.hide() 
		line3.show() ; cutLine3.hide() 
		line4.show() ; cutLine4.hide()
		
		lineLeft.color(red)
		lineRight.color(red)
		
		action.disable()
	}
	
	func modeUnpowered()
	{
		detailsLabel.update("unpowered", color:grey)
		
		interface_flight.hide()
		interface_dock.hide()
		interface_warp.hide()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(grey)
		decelerate.updateChildrenColors(grey)
		
		line1.hide() ; cutLine1.show()
		line2.hide() ; cutLine2.show()
		line3.hide() ; cutLine3.show()
		line4.hide() ; cutLine4.show()
		
		lineLeft.update(grey)
		lineRight.update(grey)
	}
	
	func modeDocking()
	{
		let dockingProgress = Int((1 - distanceBetweenTwoPoints(capsule.at, point2: capsule.dock.at)/0.5) * 100)
		detailsLabel.update("docking \(dockingProgress)%", color:grey)
		
		interface_flight.hide()
		interface_dock.show()
		interface_warp.hide()
		
		action.enable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(grey)
		decelerate.updateChildrenColors(grey)
		
		lineLeft.color(clear)
		lineRight.color(clear)
	}
	
	func modeStorageBusy()
	{
		detailsLabel.update("Take \(capsule.dock.storedItems().first!.name!)", color:red)
		
		interface_flight.hide()
		interface_dock.show()
		interface_warp.hide()
		
		action.disable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(grey)
		decelerate.updateChildrenColors(grey)
		
		lineLeft.color(grey)
		lineRight.color(grey)
	}
	
	func modeDocked()
	{
		detailsLabel.update("undock", color:white)
		
		interface_flight.hide()
		interface_dock.show()
		interface_warp.hide()

		action.enable()
		
		accelerate.disable()
		decelerate.disable()
		accelerate.updateChildrenColors(red)
		decelerate.updateChildrenColors(red)
		
		lineLeft.color(red)
		lineRight.color(red)
	}
	
	// MARK: Misc -
	
	func maxSpeed() -> Int
	{
		return battery.cellCount()
	}
	
	func speedUp()
	{
		if speed < maxSpeed() {
			speed += 1
		}
	}
	
	func speedDown()
	{
		if speed >= 1 {
			speed -= 1
		}
	}
	
	func thrust()
	{
		if capsule.isWarping == true { speed = 100 ; journey.distance += actualSpeed ; return }
		if capsule.isDocked ==  true { speed = 0 ; actualSpeed = 0 ; return }
		
		if speed * 10 > Int(actualSpeed * 10) {
			actualSpeed += 0.1
		}
		else if speed * 10 < Int(actualSpeed * 10) {
			actualSpeed -= 0.1
		}
		
		if capsule.dock != nil {
			speed = 0
		}
		else if actualSpeed < 0.1 {
			actualSpeed = 0.1
		}
		
		if actualSpeed > 0
		{
			let speed:Float = actualSpeed/600
			let angle:Float = capsule.direction % 360
			
			let angleRad = degToRad(angle)
			
			capsule.at.x += CGFloat(speed) * CGFloat(sin(angleRad))
			capsule.at.y += CGFloat(speed) * CGFloat(cos(angleRad))
		}
		
		journey.distance += actualSpeed
	}
	
	override func onInstallationBegin()
	{
		super.onInstallationBegin()
		
		player.lookAt(deg: -45)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
