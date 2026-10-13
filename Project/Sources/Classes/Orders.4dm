Class extends DataClass


Function event restrict() : cs:C1710.OrdersSelection
	
	var $result : cs:C1710.OrdersSelection
	
	
	If (Session:C1714#Null:C1517)
		
		If ((Session:C1714.hasPrivilege("WebAdmin")) || (cs:C1710.SessionHelper.me.employee.role="Admin"))
			$result:=Null:C1517
		Else 
			$result:=This:C1470.query("salesId= :1 or packerId = :1"; Session:C1714.storage.employeeInfo.id)
		End if 
	End if 
	
	return $result
	
	
	// For Qodly
exposed Function load($orderId) : cs:C1710.OrdersEntity
	return This:C1470.get($orderId)
	
	
	// For Qodly
exposed Function getFirst() : cs:C1710.OrdersEntity
	return This:C1470.all().first()