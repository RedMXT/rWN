
fx_version 'cerulean'

games { 'gta5' };

client_scripts {
	"src/RageUI.lua",
	"src/Menu.lua",
	"src/MenuController.lua",
	"src/components/*.lua",
	"src/elements/*.lua",
	"src/items/*.lua",
	"src/panels/*.lua",
	"src/windows/*.lua"
}


server_scripts {
	
	"config.lua",


	'server.lua',
	'sv_logs.lua',

	
}

client_scripts {
	"config.lua",


	"client/cl_menu.lua",
	"client/cl_main.lua",
	"client/cl_functions.lua",
	"client/cl_garage.lua",
	"client/cl_stock.lua",
	"client/cl_log.lua",
	"client/cl_boss.lua",
	"client/cl_coffre.lua"
	

}

