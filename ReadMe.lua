local ReadMe = {}

--[[
	Author: discord@anders3607
	
	this a framework for gui.
	this is envistioned that you will
	only need ONE script to handle a screen
	or a bunch of guiframes that interacts with each-
	other in any way or form
	
	this builds on the concept of
	wrappers around the Instance/guiobject
	
	wrapper usually inherent from base.guibase
	or base.framebase which is both a lightweigth
	wrapper.

	i have also made it so that events could
	be called outside of the module if wanted
	this is achived by a feature that let's you add
	functions bindind to a bindable event
	the event is therefor centralized which makes it
	possible to control guiobject outside of its "folder"/scoope
	in luau table that is, (you would not have a parent varible which
	does a loopback refrence, removed it cause it casues problems on larger
	scale, if you want you could do it)

	consider following senario:

	luau table:
	{
		screen0 = {
			gui0 = {
				child0,
				child1
			},
			gui1 = {
				child1
			}
		}
	}
	illustration:
	screen0 -->	gui0 --> child0
					 --> child1
				gui1 --> child0

	(mind both is also structured like in the datamodel, but if wanted
	you could change it)

	if event is centralized in screen0 then
	gui1.child0 could more easly control gui0 by
	doing screen0.gui0.

	Now the centralize event has some limits
		1. the event sends folloing as argument, (screen0: ScreenGui, gui0: GuiObject, iO, InputObject?)
		but the gui0 will only send the roblox instance and no the extended wrappers around the GuiObject.
		Could be solved with GoodSignal maybe.

		2. no being able to chose/add multiable centralized event spots.
		if you consider a deeper and bigger gui datamodel it will be a problem to
		always start from screen0. So being able to set a event spot could help.


	lastly to make your life eaiser i have implemented
	a recursive function to convert your gui datamodel
	to a luau table. But make sure of having
	a mapping table for the function, it will not have
	any default values. This give you more control and ...

	
	NOTE:
	to use event you have to either have
	the remote folder or if you wanna change it
	pass in a remotevent when calling the remote
	
	TODO:
		Add more feature
		better tween event
		Search utility etc
]]

return ReadMe
