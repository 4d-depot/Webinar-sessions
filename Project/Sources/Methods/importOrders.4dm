//%attributes = {"invisible":true}
#DECLARE() : Object


var $result : Object:={success: False:C215; count: 0; error: ""}
var $file : 4D:C1709.File
var $fileContent : Text
var $jsonData : Collection
var $importedOrders : cs:C1710.OrdersSelection
var $importedOrderings : cs:C1710.OrderingSelection

var $notDropped : 4D:C1709.EntitySelection


// ORDERS
//
$file:=Folder:C1567(fk resources folder:K87:11).file("orders.json")

$fileContent:=$file.getText()


If (Not:C34($file.exists))
	$result.error:="File not found: "
	return $result
End if 

If ($fileContent="")
	$result.error:="File is empty"
	return $result
End if 


$jsonData:=JSON Parse:C1218($fileContent)

If (Not:C34(Value type:C1509($jsonData)=Is collection:K8:32))
	$result.error:="Invalid JSON format - must be a collection"
	return $result
End if 

// Delete existing orders to avoid duplicates
$notDropped:=ds:C1482.Orders.all().drop()

SET DATABASE PARAMETER:C642([Orders:5]; Table sequence number:K37:31; 0)

// Create orders from collection
$importedOrders:=ds:C1482.Orders.fromCollection($jsonData)
$result.countOrders:=$importedOrders.length
$result.successOrders:=True:C214


// ORDERINGS
//
// Build path to Resources/orders.json
$file:=Folder:C1567(fk resources folder:K87:11).file("orderings.json")

$fileContent:=$file.getText()

If (Not:C34($file.exists))
	$result.error:="File not found: "
	return $result
End if 

If ($fileContent="")
	$result.error:="File is empty"
	return $result
End if 

$jsonData:=JSON Parse:C1218($fileContent)

If (Not:C34(Value type:C1509($jsonData)=Is collection:K8:32))
	$result.error:="Invalid JSON format - must be a collection"
	return $result
End if 

// Delete existing orderings to avoid duplicates
$notDropped:=ds:C1482.Ordering.all().drop()

SET DATABASE PARAMETER:C642([Ordering:6]; Table sequence number:K37:31; 0)

// Create orders from collection
$importedOrderings:=ds:C1482.Ordering.fromCollection($jsonData)
$result.countOrderings:=$importedOrderings.length
$result.successOrderings:=True:C214


return $result
