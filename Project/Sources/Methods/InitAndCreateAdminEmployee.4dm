//%attributes = {"invisible":true}

var $emp : cs:C1710.EmployeesEntity
var $user : cs:C1710.UsersEntity
var $status : Object


TRUNCATE TABLE:C1051([Employees:2])

TRUNCATE TABLE:C1051([Users:4])

SET DATABASE PARAMETER:C642([Employees:2]; Table sequence number:K37:31; 0)
SET DATABASE PARAMETER:C642([Users:4]; Table sequence number:K37:31; 0)

$user:=ds:C1482.Users.new()
$user.identifier:="admin"
$user.password:=Generate password hash:C1533("a")
$status:=$user.save()


$emp:=ds:C1482.Employees.new()
$emp.firstname:="admin"
$emp.lastname:="admin"
$emp.role:="Admin"
$emp.allowedDiscount:=0
$emp.user:=$user
$status:=$emp.save()


