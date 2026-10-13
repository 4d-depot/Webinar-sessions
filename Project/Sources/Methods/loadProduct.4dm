//%attributes = {"invisible":true,"publishedWeb":true}


var $product : cs:C1710.ProductsEntity
var $blob : Blob
var $b64 : Text
var $result : Object


$product:=ds:C1482.Products.get(2)

$result:={name: $product.name; price: $product.price; quantityInStock: $product.quantityInStock; photo: ""}

If ($product.picture#Null:C1517)
	
	PICTURE TO BLOB:C692($product.picture; $blob; ".png")
	
	If (BLOB size:C605($blob)>0)
		BASE64 ENCODE:C895($blob; $b64)
		$result.photo:="data:image/png;base64,"+$b64
	End if 
End if 


WEB SEND TEXT:C677(JSON Stringify:C1217($result); "application/json")