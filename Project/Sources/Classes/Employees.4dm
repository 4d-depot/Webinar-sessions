Class extends DataClass



Function getPackers() : cs:C1710.EmployeesSelection
	
	return This:C1470.query("role = :1"; "Packer")