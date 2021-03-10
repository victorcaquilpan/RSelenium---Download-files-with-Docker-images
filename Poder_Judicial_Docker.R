#Carga de librerias
library(RSelenium)
library(dplyr)

#Configuracion de browser
fprof <- makeFirefoxProfile(list(browser.download.folderList = 2L, browser.download.dir = "home/seluser/Downloads", 
                                 browser.download.manager.showWhenStarting     = FALSE,
                                 browser.helperApps.neverAsk.openFile = "application/zip",
                                 browser.helperApps.neverAsk.saveToDisk =  "application/zip"))

# URL
url <- "https://numeros.pjud.cl/Descargas?fbclid=IwAR0jjyl3d88gkrk861o57ATEphxCux-o6Y4JRV3UxZhQfohMAjYRX3nV9QE"

#Configurar driver
rem_dr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                  port = 4448L,
                                  browserName = "firefox", 
                                  extraCapabilities = fprof)
#Abrir driver
rem_dr$open(silent = TRUE)
Sys.sleep(2)

#Navegar la web con Selenium
rem_dr$navigate(url)
Sys.sleep(2)

#Descargar un excel de prueba
descarga_prueba <- rem_dr$findElement(using = "css selector", value = "div.container:nth-child(4) > div:nth-child(3) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(4) > button:nth-child(2)")
descarga_prueba$clickElement()

#Cerrar servidor
rem_dr$close()

#Referencias
#https://bas-m.netlify.app/2020/05/29/batch-downloading-with-rselenium/
#https://phoenixnap.com/kb/linux-file-permissions
#https://bas-m.netlify.app/2020/05/29/batch-downloading-with-rselenium/
