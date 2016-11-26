
//  Created by Devine Lu Linvega on 2016-01-14.
//  Copyright © 2016 XXIIVV. All rights reserved.

import Foundation

class Mission
{
	var id:Int = 0
	var name:String = ""
	var isCompleted:Bool = false
	var state:() -> Void
	
	var quests:Array<Quest> = []
	var currentQuest:Quest!
	
	var predicate:() -> Bool! = { return nil }
	var requirement:() -> Bool! = { return nil }
	
	init(id:Int,name:String, requirement:() -> Bool = { return true }, state:() -> Void = { } )
	{
		self.id = id
		self.name = name
		self.requirement = requirement
		self.state = state
	}
	
	func validate()
	{
		if currentQuest == nil { currentQuest = quests.first }
		if predicate() != nil && predicate() == true { complete() }
		
		for quest in quests {
			quest.validate()
			if quest.isCompleted == false {
				currentQuest = quest
				prompt()
				return
			}
		}
		isCompleted = true
	}
	
	func prompt()
	{
		if currentQuest.location != nil {
			if capsule.isDockedAtLocation(currentQuest.location) { helmet.addMessage(currentQuest.name) }
			else if capsule.system == currentQuest.location.system {
				if "\(currentQuest.location.system)" == "\(currentQuest.location.name!)" {
					helmet.addMessage("Reach \(currentQuest.location.name!)", color:red)
				}
				else{
					helmet.addMessage("Reach \(currentQuest.location.system) \(currentQuest.location.name!)", color:red)
				}
			}
			else{ helmet.addMessage("Reach the \(currentQuest.location.system) system", color:cyan) }
		}
		else{
			helmet.addMessage(currentQuest.name)
		}
	}
	
	func onComplete()
	{
		completion.refresh()
	}
	
	func complete()
	{
		isCompleted = true
		for quest in quests {
			quest.complete()
		}
	}
}
