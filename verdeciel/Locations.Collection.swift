
//  Created by Devine Lu Linvega on 2015-10-07.
//  Copyright (c) 2016 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class LocationCollection
{
	let loiqe = Loiqe(offset: CGPoint(x: 0,y: -3))
	let usul  = Usul(offset: CGPoint(x: -3,y: 0))
	let valen = Valen(offset: CGPoint(x: 3,y: 0))
	let senni = Senni(offset: CGPoint(x: 0,y: 3))
	let close = Close(offset: CGPoint(x: 0,y: 0))
	
	init()
	{
	}
}

class Loiqe
{
	var system:Systems = .loiqe
	var offset:CGPoint!
	
	init(offset:CGPoint)
	{
		self.offset = offset
	}
	
	func star() -> LocationStar
	{
		let location = LocationStar(name:"Loiqe",system:system)
		location.at = offset
		return location
	}
	
	func spawn() -> LocationSatellite
	{
		return LocationSatellite(name: "spawn", system:system, at: CGPoint(x: offset.x, y: offset.y - 2.75), message:"Are you sure$that you are in$space.", item: items.teapot, mapRequirement: items.map2)
	}
	
	func harvest() -> LocationHarvest
	{
		return LocationHarvest(name: "Harvest", system: system, at:CGPoint(x: offset.x, y: offset.y - 2), grows: Item(like:items.currency1))
	}
	
	func city() -> LocationTrade
	{
		return LocationTrade(name: "City", system:system, at: CGPoint(x: offset.x, y: offset.y - 1), want: items.currency1, give: items.valenPortalFragment1)
	}
	
	func horadric() -> LocationHoradric
	{
		return LocationHoradric(name:"Horadric",system:system, at: CGPoint(x: offset.x + 2, y: offset.y))
	}
	
	func portal() -> LocationPortal
	{
		return LocationPortal(name: "portal", system:system, at:CGPoint(x: offset.x, y: offset.y + 1))
	}
	
	func satellite() -> LocationSatellite
	{
		return LocationSatellite(name: "satellite", system:system, at: CGPoint(x: offset.x + 1, y: offset.y), message:"something broken$half lost", item: items.valenPortalFragment2)
	}
	
	func port() -> LocationTrade
	{
		return LocationTrade(name: "port",system:system, at:CGPoint(x: offset.x - 1, y: offset.y), want:items.currency4, give:items.senniPortalKey)
	}
	
	// MARK: Fog
	
	func transit() -> LocationTransit
	{
		return LocationTransit(name: "transit", system:system, at:CGPoint(x: offset.x, y: offset.y + 2), mapRequirement: items.map1)
	}
	
	func fog() -> LocationTrade
	{
		return LocationTrade(name: "fog",system:system, at:CGPoint(x: offset.x - 2, y: offset.y), want:items.currency5, give:items.usulPortalFragment2, mapRequirement: items.map1)
	}
	
	// Constellations
	
	func c_1() -> LocationConstellation
	{
		return LocationConstellation(name: "", system:system, at: CGPoint(x:offset.x, y: offset.y - 1.5), structure: StructureTunnel())
	}
}

class Usul
{
	var system:Systems = .usul
	var offset:CGPoint!
	
	init(offset:CGPoint)
	{
		self.offset = offset
	}
	
	func star() -> LocationStar
	{
		let location = LocationStar(name:"Usul",system:.usul)
		location.at = offset
		return location
	}
	
	func portal() -> LocationPortal
	{
		return LocationPortal(name: "portal",system:system, at:CGPoint(x: offset.x + 1, y: offset.y))
	}
	
	// MARK: Fog
	
	func transit() -> LocationTransit
	{
		return LocationTransit(name: "transit", system:system, at:CGPoint(x: offset.x + 2, y: offset.y), mapRequirement: items.map1)
	}
	
	func station() -> LocationStation
	{
		return LocationStation(name:"station",system:system, at: CGPoint(x: offset.x, y: offset.y + 1), requirement:items.currency5, installation:{ shield.install() }, installationName:"shield", mapRequirement:items.map1)
	}
	
	func telescope() -> LocationSatellite
	{
		return LocationSatellite(name:"telescope",system:system, at:CGPoint(x: offset.x, y: offset.y - 1), message:"extra sight$map format", item:items.map2, mapRequirement:items.map1)
	}
	
	// MARK: Blind
	
	func silence() -> LocationTrade
	{
		return LocationTrade(name: "silence", system: .usul, at: CGPoint(x: offset.x - 1, y: offset.y), want: items.currency6, give: items.shield, mapRequirement: items.map2)
	}
}

class Valen
{
	var system:Systems = .valen
	var offset:CGPoint!
	
	init(offset:CGPoint)
	{
		self.offset = offset
	}
	
	func star() -> LocationStar
	{
		return LocationStar(name:"Valen",system:system, at: offset)
	}
	
	func bank() -> LocationBank
	{
		return LocationBank(name:"Bank",system:system, at: CGPoint(x: offset.x, y: offset.y + 1))
	}
	
	func portal() -> LocationPortal
	{
		return LocationPortal(name: "portal",system:system, at:CGPoint(x: offset.x - 1, y: offset.y))
	}
	
	func harvest() -> LocationHarvest
	{
		return LocationHarvest(name: "harvest",system:system, at:CGPoint(x: offset.x, y: offset.y + 2), grows: Item(like:items.currency2))
	}
	
	func station() -> LocationStation
	{
		return LocationStation(name:"station",system:system, at: CGPoint(x: offset.x + 1, y: offset.y + 1), requirement:items.currency2, installation:{ radio.install() }, installationName:"Radio")
	}
	
	func cargo() -> LocationSatellite
	{
		return LocationSatellite(name:"cargo",system:system, at:CGPoint(x: offset.x + 1, y: offset.y + 2), message:"Extra power$battery format", item:items.battery2)
	}
	
	func market() -> LocationTrade
	{
		return LocationTrade(name: "market", system: system, at: CGPoint(x: offset.x + 1, y: offset.y - 1), want: items.waste, give: items.kelp)
	}
	
	// MARK: Fog
	
	func transit() -> LocationTransit
	{
		return LocationTransit(name: "transit", system:system, at:CGPoint(x: offset.x - 2, y: offset.y), mapRequirement: items.map1)
	}
	
	func fog() -> LocationSatellite
	{
		return LocationSatellite(name: "fog",system:system, at:CGPoint(x: offset.x, y: offset.y - 1), message:"something broken$half lost", item:items.usulPortalFragment1, mapRequirement: items.map1)
	}
	
	func beacon() -> LocationBeacon
	{
		return LocationBeacon(name: "beacon", system: system, at: CGPoint(x: offset.x, y: offset.y - 2), message: "scribbles$scribbles$scrib..", mapRequirement: items.map1)
	}
	
	func c_1() -> LocationConstellation
	{
		return LocationConstellation(name: "", system:system, at: CGPoint(x:offset.x + 0.5, y: offset.y + 1.5), structure: StructureDoor())
	}
	
	// MARK: Blind
	
	func void() -> LocationTrade
	{
		return LocationTrade(name: "void", system:system, at: CGPoint(x: offset.x + 1, y: offset.y - 2), want: items.teapot, give: items.kelp, mapRequirement: items.map2)
	}
	
	func wreck() -> LocationSatellite
	{
		return LocationSatellite(name:"wreck",system:system, at:CGPoint(x: offset.x + 2, y: offset.y), message:"Memories$radio format", item:items.record3, mapRequirement: items.map2)
	}
}

class Senni
{
	var system:Systems = .senni
	var offset:CGPoint!
	
	init(offset:CGPoint)
	{
		self.offset = offset
	}
	
	func star() -> LocationStar
	{
		return LocationStar(name:"Senni",system:system,at:offset)
	}
	
	func portal() -> LocationPortal
	{
		return LocationPortal(name: "portal",system:system, at:CGPoint(x: offset.x, y: offset.y - 1))
	}
	
	func cargo() -> LocationSatellite
	{
		return LocationSatellite(name:"cargo",system:system, at:CGPoint(x: offset.x - 1, y: offset.y), message:"extra sight$map format", item:items.map1)
	}
	
	func harvest() -> LocationHarvest
	{
		return LocationHarvest(name: "harvest",system:system, at:CGPoint(x: offset.x, y: offset.y + 1), grows: Item(like:items.currency3))
	}
	
	func station() -> LocationStation
	{
		return LocationStation(name:"station",system:system, at: CGPoint(x: offset.x + 1, y: offset.y), requirement:items.currency3, installation:{ map.install() }, installationName:"Map")
	}
	
	// MARK: Fog
	
	func transit() -> LocationTransit
	{
		return LocationTransit(name: "transit", system:system, at:CGPoint(x: offset.x, y: offset.y - 2), mapRequirement: items.map1)
	}
	
	func horadric() -> LocationHoradric
	{
		return LocationHoradric(name:"Horadric",system:system, at: CGPoint(x: offset.x, y: offset.y + 2), mapRequirement: items.map1)
	}
	
	func fog() -> LocationSatellite
	{
		return LocationSatellite(name:"fog",system:system, at:CGPoint(x: offset.x + 2, y: offset.y), message:"Extra power$battery format", item:items.battery3, mapRequirement: items.map1)
	}
	
	func wreck() -> LocationSatellite
	{
		return LocationSatellite(name:"wreck",system:system, at:CGPoint(x: offset.x - 2, y: offset.y), message:"Memories$radio format", item:items.record2, mapRequirement: items.map1)
	}
	
	// MARK: Silence
	
	func bog() -> LocationTrade
	{
		return LocationTrade(name: "bog", system:system, at: CGPoint(x: offset.x + 1, y: offset.y + 1), want: items.kelp, give: items.record_oquonie, mapRequirement: items.map2)
	}
}

class Close
{
	var system:Systems = .close
	var offset:CGPoint!
	
	init(offset:CGPoint)
	{
		self.offset = offset
	}
	
	func void() -> LocationClose
	{
		return LocationClose(name:"close",system:system,at:offset, mapRequirement: items.map2)
	}
}
