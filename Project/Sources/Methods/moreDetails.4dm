//%attributes = {"invisible":true,"publishedWeb":true}


var $product : cs:C1710.ProductsEntity


$product:=ds:C1482.Products.get(2)

WEB SEND TEXT:C677($product.getMoreDetails())
