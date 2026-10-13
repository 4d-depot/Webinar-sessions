//%attributes = {"invisible":true}




#DECLARE()->$result : Object

var $event : Object

$event:=FORM Event:C1606

$result:=New object:C1471

Case of 
	: ($event.code=On Display Detail:K2:22)
		If ($event.isRowSelected)
			$result:=Form:C1466.meta
		End if 
End case 