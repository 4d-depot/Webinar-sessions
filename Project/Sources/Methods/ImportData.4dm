//%attributes = {}

var $result : Object
var $checkUser : Boolean


InitAndCreateAdminEmployee

$checkUser:=cs:C1710.SessionHelper.me.checkUser({identifier: "admin"; password: "a"})

$result:=importEmployees
ASSERT:C1129($result.count=4)
ASSERT:C1129($result.success=True:C214)


$result:=importProducts
ASSERT:C1129($result.count=15)
ASSERT:C1129($result.success=True:C214)

$result:=importOrders
ASSERT:C1129($result.countOrders=20)
ASSERT:C1129($result.countOrderings=93)
ASSERT:C1129($result.successOrders=True:C214)
ASSERT:C1129($result.successOrderings=True:C214)


ALERT:C41("Data successfully imported")