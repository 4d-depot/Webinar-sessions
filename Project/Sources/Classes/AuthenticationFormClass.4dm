

property credentials : Object
property authentified : Integer
//property sessionHelper : cs.SessionHelper


Class constructor()
	
	This:C1470.credentials:={identifier: "Lucas"}
	This:C1470.authentified:=0
	
	
	
	//MARK: - Form & form objects event handlers
Function formEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Load:K2:1)
			
			
			
			//: ($formEventCode=On Close Box)
			//If (Is Windows && Application info().SDIMode)
			//QUIT 4D
			//Else 
			//CANCEL
			//End if 
	End case 
	
	
Function login()
	
	var $result : Boolean
	
	OBJECT SET VISIBLE:C603(*; "WrongCredentials"; False:C215)
	
	This:C1470.credentials.password:="a"
	
	$result:=cs:C1710.SessionHelper.me.checkUser(This:C1470.credentials)
	
	If ($result)
		This:C1470.authentified:=1
		ACCEPT:C269
	Else 
		This:C1470.credentials.password:="*"
		OBJECT SET VISIBLE:C603(*; "WrongCredentials"; True:C214)
	End if 
	
	
Function quit()
	
	This:C1470.authentified:=2
	CANCEL:C270
	