

property orders : cs:C1710.OrdersSelection
property selectedOrder : cs:C1710.OrdersEntity
property sessionId : Text
property url : Text
property page : Text
property employee : cs:C1710.EmployeesEntity

property authentified : Integer
property proposedDiscount : Integer
property orderLinesURL : Text


// Header user profile properties


Class constructor
	
	//This.authentified:=1
	
	
Function formEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Load:K2:1)
			
			This:C1470.orders:=ds:C1482.Orders.all()
			
			This:C1470.employee:=cs:C1710.SessionHelper.me.employee
			
			Form:C1466.meta:=New object:C1471("fontWeight"; "bold")
			
			This:C1470.orderIsSelected:=False:C215
			
			This:C1470.keepSelected:=False:C215
			
			This:C1470.whereToGo(This:C1470.employee.role)
			
			SET TIMER:C645(-1)
			
			
		: ($formEventCode=On Timer:K2:25)
			SET TIMER:C645(0)
			
			If (This:C1470.orders.length#0)
				Case of 
					: (FORM Get current page:C276=1)
						If (This:C1470.keepSelected=False:C215)
							This:C1470.selectRow("Orders")
						End if 
						This:C1470.selectRow("Orderings")
						
					: (FORM Get current page:C276=2)
						
						LISTBOX SELECT ROWS:C1715(*; "LBOrders2"; ds:C1482.Orders.newSelection().add(This:C1470.orders.first()); lk replace selection:K53:1)
						This:C1470.loadOrderLines(FORM Get current page:C276)
						
					: (FORM Get current page:C276=3)
						LISTBOX SELECT ROWS:C1715(*; "LBOrders3"; ds:C1482.Orders.newSelection().add(This:C1470.orders.first()); lk replace selection:K53:1)
						This:C1470.loadOrderLines(FORM Get current page:C276)
				End case 
			End if 
			
			
		: ($formEventCode=On Page Change:K2:54)
			
			If (FORM Get current page:C276=1)
				This:C1470.selectRow("Orderings"; FORM Get current page:C276)
			End if 
			
			If (FORM Get current page:C276=2)
				
				If (This:C1470.orders.length#0)
					
					This:C1470.packer1:=ds:C1482.Employees.getPackers().first()
					This:C1470.packer2:=Form:C1466.packer1.next()
					
					This:C1470.selectPacker1:=Form:C1466.selectedOrder.packer.ID=This:C1470.packer1.ID ? 1 : 0
					This:C1470.selectPacker2:=Form:C1466.selectedOrder.packer.ID=This:C1470.packer2.ID ? 1 : 0
					
					SET TIMER:C645(-1)
					
				End if 
			End if 
			
			If (FORM Get current page:C276=3)
				SET TIMER:C645(-1)
			End if 
			
			
		: ($formEventCode=On Close Box:K2:21)
			// comportement de fermeture si nécessaire
			If (Is Windows:C1573 && Application info:C1599().SDIMode)
				QUIT 4D:C291
			Else 
				CANCEL:C270
			End if 
	End case 
	
	
Function initWebAreaURL($webArea : Text)
	
	var $otp : Text
	
	$otp:=Session:C1714.createOTP()
	This:C1470.orderLinesURL:="http://localhost/$lib/renderer/?w=OrderDetails&$4DSID="+$otp
	
	//Case of 
	//: ($webArea="QodlyPagePrepareOrders")
	//WA OPEN URL(*; "QodlyPagePrepareOrders"; This.orderLinesURL)
	
	//: ($webArea="QodlyPageOrdersToPrepare")
	//WA OPEN URL(*; "QodlyPageOrdersToPrepare"; This.orderLinesURL)
	//End case 
	
	WA OPEN URL:C1020(*; $webArea; This:C1470.orderLinesURL)
	
	
Function selectRow($what : Text)
	
	If (This:C1470.orders.length#0)
		Case of 
			: (($what="Orders") && (This:C1470.orderIsSelected=False:C215))
				LISTBOX SELECT ROWS:C1715(*; "LBOrders1"; ds:C1482.Orders.newSelection().add(This:C1470.orders.first()); lk replace selection:K53:1)
				This:C1470.orderIsSelected:=True:C214
				SET TIMER:C645(-1)
				
			: ($what="Orderings")
				If (This:C1470.keepSelected=False:C215)
					LISTBOX SELECT ROWS:C1715(*; "LBOrderings1"; ds:C1482.Ordering.newSelection().add(This:C1470.selectedOrder1.orderings.first()); lk replace selection:K53:1)
					This:C1470.selectedOrdering1:=This:C1470.selectedOrder1.orderings.first()
				Else 
					LISTBOX SELECT ROWS:C1715(*; "LBOrderings1"; ds:C1482.Ordering.newSelection().add(This:C1470.selectedOrder1.orderings[This:C1470.orderingIndex]); lk replace selection:K53:1)
					This:C1470.selectedOrdering1:=This:C1470.selectedOrder1.orderings[This:C1470.orderingIndex]
					This:C1470.keepSelected:=False:C215
				End if 
				
				This:C1470.selectOrdering()
		End case 
	End if 
	
	
Function applyDiscountAndSave()
	
	var $status : Object
	
	OBJECT SET VISIBLE:C603(*; "WrongDiscount@"; False:C215)
	
	This:C1470.selectedOrdering1.appliedDiscount:=This:C1470.proposedDiscount
	
	This:C1470.orderingIndex:=This:C1470.selectedOrdering1.indexOf(Form:C1466.selectedOrder1.orderings)
	This:C1470.keepSelected:=True:C214
	
	$status:=Form:C1466.selectedOrdering1.save()
	
	If ($status.success)
		$status:=This:C1470.selectedOrder1.reload()
		
		SET TIMER:C645(-1)
		
	Else 
		This:C1470.selectedOrdering1.appliedDiscount:=0
		This:C1470.discountMessage1:=$status.errors.first().message
		This:C1470.discountMessage2:=$status.errors.first().extraDescription.info
		OBJECT SET VISIBLE:C603(*; "WrongDiscount@"; True:C214)
	End if 
	
	
Function selectOrder()
	
	If (This:C1470.selectedOrder1#Null:C1517)
		LISTBOX SELECT ROWS:C1715(*; "LBOrderings1"; ds:C1482.Ordering.newSelection().add(This:C1470.selectedOrder1.orderings.first()); lk replace selection:K53:1)
		
		This:C1470.proposedDiscount:=This:C1470.selectedOrdering1.appliedDiscount
		
		OBJECT SET VISIBLE:C603(*; "WrongDiscount@"; False:C215)
	End if 
	
	
Function selectOrdering()
	
	If (This:C1470.selectedOrdering1#Null:C1517)
		This:C1470.proposedDiscount:=This:C1470.selectedOrdering1.appliedDiscount
		OBJECT SET VISIBLE:C603(*; "WrongDiscount@"; False:C215)
	End if 
	
	
Function loadOrderLines($page : Integer)
	
	var $result : Variant
	
	
	Case of 
		: ($page=2)
			
			If (This:C1470.selectedOrder2#Null:C1517)
				This:C1470.selectPacker1:=Form:C1466.selectedOrder2.packer.ID=This:C1470.packer1.ID ? 1 : 0
				This:C1470.selectPacker2:=Form:C1466.selectedOrder2.packer.ID=This:C1470.packer2.ID ? 1 : 0
				
				OBJECT SET VISIBLE:C603(*; "MailSent"; False:C215)
				WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; "QodlyPagePrepareOrders"; "Qodly.setSource"; $result; "theOrderId"; This:C1470.selectedOrder2.ID)
			End if 
			
		: ($page=3)
			If (This:C1470.selectedOrder3#Null:C1517)
				WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; "QodlyPageOrdersToPrepare"; "Qodly.setSource"; $result; "theOrderId"; This:C1470.selectedOrder3.ID)
			End if 
	End case 
	
	
Function selectPacker()
	
	OBJECT SET VISIBLE:C603(*; "MailSent"; False:C215)
	
	This:C1470.selectedOrder2.packer:=This:C1470.selectPacker1=1 ? This:C1470.packer1 : This:C1470.packer2
	
	
	
	//Function orderLinkBuilder($orderId : Integer) : Text
	//return "http://localhost/getOrder?number="+String($orderId)
	
	
Function sendToPreparation()
	
	var $status : Object
	
	$status:=Form:C1466.selectedOrder2.save()
	
	If ($status.success)
		OBJECT SET VISIBLE:C603(*; "MailSent"; True:C214)
	End if 
	
	
	
Function whereToGo($role : Text)
	
	This:C1470.initMenuAndHeader(This:C1470.employee.role)
	
	Case of 
		: ($role="SalesPeople")
			This:C1470.goToMyOrders()
			
		: ($role="Packer")
			This:C1470.ordersToPrepare()
	End case 
	
	
Function goToMyOrders()
	This:C1470.selectMenu("MenuMyOrders")
	FORM GOTO PAGE:C247(1)
	
	
Function goToPrepareOrder()
	This:C1470.selectMenu("MenuPrepareOrders")
	FORM GOTO PAGE:C247(2)
	
Function ordersToPrepare()
	This:C1470.selectMenu("MenuOrdersToPrepare")
	FORM GOTO PAGE:C247(3)
	
	
Function initMenuAndHeader($role : Text)
	
	OBJECT SET VISIBLE:C603(*; "Menu@"; False:C215)
	OBJECT SET VISIBLE:C603(*; "Discount@"; False:C215)
	
	Case of 
		: ($role="SalesPeople")
			OBJECT SET VISIBLE:C603(*; "MenuMyOrders"; True:C214)
			OBJECT SET VISIBLE:C603(*; "MenuPrepareOrders"; True:C214)
			OBJECT SET VISIBLE:C603(*; "Discount@"; True:C214)
			
		: ($role="Packer")
			OBJECT SET VISIBLE:C603(*; "MenuOrdersToPrepare"; True:C214)
	End case 
	
Function selectMenu($menuItem : Text)
	
	OBJECT SET FONT STYLE:C166(*; "Menu@"; Plain:K14:1)
	OBJECT SET FONT STYLE:C166(*; $menuItem; Bold:K14:2)
	
	OBJECT SET FONT SIZE:C165(*; "Menu@"; 16)
	OBJECT SET FONT SIZE:C165(*; $menuItem; 18)
	
	
	
Function logout()
	cs:C1710.SessionHelper.me.clearSession()
	CANCEL:C270
	
	
	