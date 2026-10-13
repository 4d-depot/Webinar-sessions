Class extends Entity


// For Qodly

exposed Function getDescription() : Text
	
	var $folder : 4D:C1709.Folder
	var $files : Collection
	var $file : 4D:C1709.File
	
	$folder:=Folder:C1567("/PACKAGE/Resources/Files")
	$files:=$folder.files()
	
	$file:=$files.query("name = :1"; This:C1470.name+"_desc1").first()
	return $file.getText("UTF-8")
	
	
exposed Function getMoreDetails() : Text
	
	var $folder : 4D:C1709.Folder
	var $files : Collection
	var $file : 4D:C1709.File
	
	$folder:=Folder:C1567("/PACKAGE/Resources/Files")
	$files:=$folder.files()
	
	$file:=$files.query("name = :1"; This:C1470.name+"_desc2").first()
	return $file.getText("UTF-8")
	
	
exposed Function searchInOtherWharehouses() : Text
	
	DELAY PROCESS:C323(Current process:C322; 600)
	
	return "The long process is finished"