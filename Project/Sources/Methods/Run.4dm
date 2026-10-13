//%attributes = {}


var $win : Integer
var $authenticationForm; $ordersForm : Object


$authenticationForm:=cs:C1710.AuthenticationFormClass.new()

While ($authenticationForm.authentified=0)
	$win:=Open form window:C675("Authentication"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
	
	SET WINDOW TITLE:C213("The 4D sessions webinar")
	
	DIALOG:C40("Authentication"; $authenticationForm)
	
	CLOSE WINDOW:C154
	
	If ($authenticationForm.authentified=1)
		$win:=Open form window:C675("Orders"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
		
		$ordersForm:=cs:C1710.OrdersFormClass.new()
		
		DIALOG:C40("Orders"; $ordersForm)
		
		$authenticationForm:=cs:C1710.AuthenticationFormClass.new()
		
		CLOSE WINDOW:C154
	End if 
End while 