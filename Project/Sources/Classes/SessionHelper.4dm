

session singleton Class constructor
	
	
server Function checkUser($credentials : Object) : Boolean
	
	var $user : cs:C1710.UsersEntity
	var $employee : cs:C1710.EmployeesEntity
	var $result:=False:C215
	
	//TRACE
	
	If ($credentials#Null:C1517)
		$user:=ds:C1482.Users.query("identifier === :1"; $credentials.identifier).first()
		
		If (($user#Null:C1517) && (Verify password hash:C1534($credentials.password; $user.password)))
			
			$employee:=$user.employees.first()
			
			Use (Session:C1714.storage)
				Session:C1714.storage.employeeInfo:=New shared object:C1526("id"; $employee.ID)
			End use 
			
			Session:C1714.clearPrivileges()
			Session:C1714.setPrivileges({roles: $employee.role})
			
			$result:=True:C214
		End if 
	End if 
	
	return $result
	
	
exposed server Function get employee() : cs:C1710.EmployeesEntity
	return ds:C1482.Employees.get(Session:C1714.storage.employeeInfo.id)
	
	
	// For Qodly
exposed Function loadEmployee() : cs:C1710.EmployeesEntity
	return ds:C1482.Employees.get(Session:C1714.storage.employeeInfo.id)
	
	
server Function clearSession()
	
	Use (Session:C1714.storage)
		Session:C1714.storage.employeeInfo:=Null:C1517
	End use 
	
	
	// For Qodly
exposed Function isAuthentified() : Object
	
	var $result:={toDisplay: "Authentication"; authentified: False:C215}
	
	If (Session:C1714.storage.employeeInfo.id#Null:C1517)
		$result.toDisplay:="OrdersPage"
		$result.authentified:=True:C214
	End if 
	
	return $result