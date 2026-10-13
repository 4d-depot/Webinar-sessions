//%attributes = {"invisible":true}
#DECLARE() : Object


var $result : Object:={success: False:C215; count: 0; error: ""}
var $file : 4D:C1709.File
var $fileContent : Text
var $jsonData : Collection
var $emp : cs:C1710.EmployeesEntity
var $importedEmployees : cs:C1710.EmployeesSelection
var $notDropped : Variant
var $myPhoto : Picture
var $photoFiles : Collection
var $user : cs:C1710.UsersEntity
var $status : Object



$file:=Folder:C1567(fk resources folder:K87:11).file("employees.json")

If (Not:C34($file.exists))
	$result.error:="File not found: employees.json"
	return $result
End if 

$fileContent:=$file.getText()

If ($fileContent="")
	$result.error:="File is empty"
	return $result
End if 


$jsonData:=JSON Parse:C1218($fileContent)

If (Not:C34(Value type:C1509($jsonData)=Is collection:K8:32))
	$result.error:="Invalid JSON format - must be a collection"
	return $result
End if 

// Delete existing employees to avoid duplicates
$notDropped:=ds:C1482.Employees.query("firstname # :1"; "admin").drop()


// Delete existing users to avoid duplicates
$notDropped:=ds:C1482.Users.query("identifier # :1"; "admin").drop()


// Create employees from collection
$importedEmployees:=ds:C1482.Employees.fromCollection($jsonData)
$result.count:=$importedEmployees.length
$result.success:=True:C214

$photoFiles:=Folder:C1567("/RESOURCES/faces/").files()

For each ($emp; ds:C1482.Employees.query("firstname # :1"; "admin"))
	
	$file:=$photoFiles.query("fullName = :1"; $emp.firstname+".jpg").first()
	READ PICTURE FILE:C678($file.platformPath; $myPhoto)
	$emp.photo:=$myPhoto
	
	$user:=ds:C1482.Users.new()
	$user.identifier:=$emp.firstname
	$user.password:=Generate password hash:C1533("a")
	$status:=$user.save()
	
	$emp.user:=$user
	$status:=$emp.save()
End for each 

return $result
