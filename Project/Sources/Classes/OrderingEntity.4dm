Class extends Entity





exposed Function get price($event : Object) : Real
	
	return This:C1470.quantity*This:C1470.product.price
	
	
	
	
exposed Function get finalPrice($event : Object) : Real
	
	return This:C1470.price*(100-This:C1470.appliedDiscount)/100
	
	
	
Function event validateSave($event : Object) : Object
	
	var $result : Object
	
	
	If (This:C1470.appliedDiscount>cs:C1710.SessionHelper.me.employee.allowedDiscount)
		$result:={errCode: 1; message: "You can't apply this discount"; \
			extraDescription: {info: "You are allowed to apply a discount <= "+String:C10(cs:C1710.SessionHelper.me.employee.allowedDiscount)}; seriousError: False:C215}
	End if 
	
	return $result