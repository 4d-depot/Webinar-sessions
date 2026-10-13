Class extends DataStoreImplementation




exposed Function authentify($credentials : Object) : Object
	
	var $result:={toDisplay: "Authentication"; authentified: False:C215}
	
	$result.authentified:=cs:C1710.SessionHelper.me.checkUser($credentials)
	
	If ($result.authentified)
		$result.toDisplay:="OrdersPage"
	End if 
	
	return $result