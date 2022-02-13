resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'buyBusness for QBCore by @Cruso#4054. Work whith bussines'
version '0.0.1'


ui_page "html/index.html"

server_scripts {
    "server.lua",
    "config.lua",

}

client_scripts {
	"client.lua",
    "config.lua",

}

files {
    "html/*.js",
    "html/js/*.js",
    "html/*.html",
    "html/css/*.css",
    "html/img/*.png",
    
}









