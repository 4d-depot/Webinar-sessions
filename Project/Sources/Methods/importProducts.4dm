//%attributes = {"invisible":true}
#DECLARE() : Object



var $result : Object:={success: False:C215; count: 0; error: ""}
var $file; $descr1File; $descr2File : 4D:C1709.File
var $fileContent; $path : Text
var $jsonData : Collection
var $productToImport; $status : Object
var $product : cs:C1710.ProductsEntity
var $importedProducts; $notDropped : cs:C1710.ProductsSelection
var $blob : Blob
var $filesFolder : 4D:C1709.Folder
var $files; $photoFiles : Collection
var $myPhoto : Picture



$file:=Folder:C1567(fk resources folder:K87:11).file("products.json")

$fileContent:=$file.getText()


// Check if file exists
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

// Delete existing products to avoid duplicates
$notDropped:=ds:C1482.Products.all().drop()

SET DATABASE PARAMETER:C642([Products:3]; Table sequence number:K37:31; 0)

// Create products from collection
$importedProducts:=ds:C1482.Products.fromCollection($jsonData)
$result.count:=$importedProducts.length
$result.success:=True:C214

$path:="/PACKAGE/Resources/Files/"
$filesFolder:=Folder:C1567($path)

$files:=$filesFolder.files()

For each ($file; $files)
	$file.delete()
End for each 

For each ($productToImport; $jsonData)
	$product:=ds:C1482.Products.query("name = :1"; $productToImport.name).first()
	
	$descr1File:=File:C1566($path+$product.name+"_desc1")
	TEXT TO BLOB:C554($productToImport.description1; $blob; UTF8 C string:K22:15)
	$descr1File.setContent($blob)
	
	$descr2File:=File:C1566($path+$product.name+"_desc2")
	TEXT TO BLOB:C554($productToImport.description2; $blob; UTF8 C string:K22:15)
	$descr2File.setContent($blob)
	
	$status:=$product.save()
End for each 

$photoFiles:=Folder:C1567("/RESOURCES/Images/").files()

For each ($product; ds:C1482.Products.all())
	$file:=$photoFiles.query("fullName = :1"; $product.name+".png").first()
	READ PICTURE FILE:C678($file.platformPath; $myPhoto)
	$product.picture:=$myPhoto
	$status:=$product.save()
End for each 


return $result
