//  Created by Devine Lu Linvega on 2015-06-22.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class PanelRadar : MainPanel
{
	var x:Float = 0
	var z:Float = 0
	
	var eventPivot = Empty()
	var eventView = universe
	var shipCursor:Empty!
	
	var targetter:Empty!
	var targetterFar:Empty!
	
	var handle:SCNHandle!
	
	// MARK: Default -
	
	override init()
	{
		super.init()
		
		name = "radar"
		details = "displays locations"
		
		mainNode.addChildNode(eventPivot)
		eventPivot.addChildNode(eventView)
		
		// Ship
		
		shipCursor = Empty()
		shipCursor.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: 0.2, z: 0),  SCNVector3(x: 0.2, y: 0, z: 0)],color:white))
		shipCursor.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: 0.2, z: 0),  SCNVector3(x: -0.2, y: 0, z: 0)],color:white))
		mainNode.addChildNode(shipCursor)
		
		targetterFar = Empty()
		targetterFar.addChildNode(SCNLine(vertices: [SCNVector3(0.8,0,0), SCNVector3(1,0,0)], color: red))
		targetterFar.hide()
		mainNode.addChildNode(targetterFar)
		
		// Targetter
		
		let scale:Float = 0.3
		let depth:Float = 0
		targetter = Empty()
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: scale, z: depth), SCNVector3(x: scale * 0.2, y: scale * 0.8, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: scale, z: depth), SCNVector3(x: -scale * 0.2, y: scale * 0.8, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: -scale, z: depth), SCNVector3(x: scale * 0.2, y: -scale * 0.8, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: 0, y: -scale, z: depth), SCNVector3(x: -scale * 0.2, y: -scale * 0.8, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: scale, y: 0, z: depth), SCNVector3(x: scale * 0.8, y: scale * 0.2, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: scale, y: 0, z: depth), SCNVector3(x: scale * 0.8, y: -scale * 0.2, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: -scale, y: 0, z: depth), SCNVector3(x: -scale * 0.8, y: scale * 0.2, z: depth)], color: red))
		targetter.addChildNode(SCNLine(vertices: [SCNVector3(x: -scale, y: 0, z: depth), SCNVector3(x: -scale * 0.8, y: -scale * 0.2, z: depth)], color: red))
		targetter.hide()
		mainNode.addChildNode(targetter)
		
		self.position = SCNVector3(0,0,0)
		
		handle = SCNHandle(destination: SCNVector3(1,0,0),host:self)
		footer.addChildNode(handle)
	}
	
	override func refresh()
	{
	}
	
	override func whenRenderer()
	{
		super.whenRenderer()
		
		eventView.position = SCNVector3(capsule.at.x * -1,capsule.at.y * -1,0)
		
		let directionNormal = Double(Float(capsule.direction)/180) * -1
		shipCursor.rotation = SCNVector4Make(0, 0, 1, Float(M_PI * directionNormal))
		
		updateTarget()
	}

	// MARK: Custom -
	
	func updateTarget()
	{		
		if port.hasEvent() == false { return }
		
		let shipNodePosition = CGPoint(x: CGFloat(capsule.at.x), y: CGFloat(capsule.at.y))
		let eventNodePosition = CGPoint(x: CGFloat(port.event.at.x), y: CGFloat(port.event.at.y))
		let distanceFromShip = Float(distanceBetweenTwoPoints(shipNodePosition,point2: eventNodePosition))
		
		if distanceFromShip > 2 {
			let angleTest = angleBetweenTwoPoints(capsule.at, point2: port.event.at, center: capsule.at)
			let targetDirectionNormal = Double(Float(angleTest)/180) * 1
			targetterFar.rotation = SCNVector4Make(0, 0, 1, Float(M_PI * targetDirectionNormal))
			targetterFar.show()
		}
		else{
			targetter.position = SCNVector3(port.event.at.x - capsule.at.x,port.event.at.y - capsule.at.y,0)
			targetterFar.hide()
		}
		
		// Targetter
		if distanceFromShip > 2 { targetter.updateChildrenColors(clear) }
		else if port.event != capsule.dock { targetter.updateChildrenColors(red) ; targetter.blink() }
		else{ targetter.updateChildrenColors(grey) ; targetter.show()  }
		
	}

	func addTarget(event:Location)
	{
		if capsule.dock != nil && capsule.isDocked == false { return }
		if capsule.isWarping == true { return }
		
		port.event = event
		
		updateTarget()
		
		// Check for overlapping events
		for newEvent in eventView.childNodes {
			if newEvent.position.x == event.position.x && newEvent.position.y == event.position.y && event != newEvent {
				print("Overlapping event: \(newEvent.name!) -> \(event.position.x)")
			}
		}
	}
	
	func removeTarget()
	{
		port.event = nil
		targetter.hide()
	}
	
	override func onInstallationBegin()
	{
		super.onInstallationBegin()
		
		player.lookAt(deg: -90)
	}
	
	// MARK: Map
	
	var overviewMode:Bool = false
	
	func modeNormal()
	{
		overviewMode = false
		
		thruster.show()
		pilot.show()
		decals.show()
		header.show()
		footer.show()
		handle.show()
		
		for location in universe.childNodes as! [Location] {
			location.onRadarView()
		}
	}
	
	func modeOverview()
	{		
		overviewMode = true
		
		thruster.hide()
		pilot.hide()
		decals.hide()
		header.hide()
		handle.hide()
		
		for location in universe.childNodes as! [Location] {
			location.onHelmetView()
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
