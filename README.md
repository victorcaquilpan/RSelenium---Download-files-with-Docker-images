# RSelenium - Download-files-with-Docker
Use of RSelenium with Docker containers. In this repository, the entire plan about how to work with Docker is presented.

RSelenium is a useful library to monitor and extract data from web pages. Besides, this library allows you interact with pages to find specific information that you need. RSelenium works with a driver in your local computer to operate. However, if you want to get a best performance or create an automatized process si recommended to use the use of containers to execute the scraping. Configuring a container can be a difficult process, specially if you want to download files, thereby this repository is focused on giving a route about how to set this configuration in Linux (Ubuntu).For this example we will use a Docker container.

# Step 1:  Download a Docker image. 

You need to download a Docker image of RSelenium using a certain browser. Most typical options are Chrome and Mozilla. In this link, you can see where and how to obtain a RSelenium image: https://rpubs.com/johndharrison/RSelenium-Docker. If you are testing, you must download a debugger image (such as selenium/standalone-firefox-debug), which allows you to see the interaction with the page using VNC.

# Step 2: Run a container with the parameters required.

Once you have downloaded a image, you can run a container with this image. For this you need to write a statement with docker command in the terminal. Here is an example:

```sh
<script> sudo docker run --name poder_judicial -v '/home/vcaquilpan/Documentos/R Scripts/RSelenium/Poder_Judicial/Descargas':/home/seluser/Downloads:rw -d --restart unless-stopped -p 4448:4444 -p 5906:5900 selenium/standalone-firefox-debug 
```  

Where: 
  --name: is the name of your container. This is optional, but using a name is easier to identify your container.
  -v: this command indicates the relation between 'volumes' (as known as directories). This command allows you to connect a directory of your local computer (host) with a directory of your container. On this way, if you want to donwload a file in your container, this file will be downloaded in your computer. The form is "host directory:container directory". Note that in the example, the first path is written in quotations marks. This is necessary due to that path use a space inside. 
  -d: this command allows that the process run in second plane.
  -p: this command distinguishes the ports used to run the processes in a docker image and how these are related to the host ports to connect with internet. In simple words, you process should use a certain port to communicate with internet. As volumes, the form is "host port:container port". The example use two relations of ports. This happens because we are using a debug image. The first relation of ports (-p 4448:4444) indicates that the application of Selenium is working in the port 4444 of my container, which corresponds to the port 4448 in the host. You can use other ports near these values or even use the same (-p 4444:4444) On the other hand, the second relation (-p 5906-5900) points out the relation to share the screen by VNC service. Here, you can see how this works: ttps://rpubs.com/johndharrison/RSelenium-Docker.
    --restart: this command sets wheter the container has to restart or not when something happen, for instance, when the computer reboots. If you want that you container restarts always, you need to set --restart unless-stopped. More info here: https://docs.docker.com/config/containers/start-containers-automatically/

# Step 3: Give the file permissions to directory.

You need to give the right permissions to the folder where you want to save the files that you will download. You can follow this steps using the GUI or terminal: https://phoenixnap.com/kb/linux-file-permissions.

# Step 4: Set RSelenium configuration.

In our R script, we have to set some browser parameters to download files in an automatically way. You need to add these lines:

#Browser configuration. These apply to firefox Browser
fprof <- makeFirefoxProfile(list(browser.download.folderList = 2L, browser.download.dir = "home/seluser/Downloads", 
                                 browser.download.manager.showWhenStarting = FALSE,
                                 browser.helperApps.neverAsk.openFile = "application/zip",
                                 browser.helperApps.neverAsk.saveToDisk =  "application/zip"))

These parameters set parameters to download automatically "zip" files avoidin to open dialog boxes. Besides, when you use remoteDriver function, you need to select the correct port and the capabilities created before. The port used here, it should be the same that you declared when your container was created.

#Driver configuration. The object "fprof" is used in remoteDriver function.
rem_dr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                  port = 4448L,
                                  browserName = "firefox", 
                                  extraCapabilities = fprof)
                                 
# Step 5: Try production mode.

Once, you have probed that in debugging mode everything goes okay, you can use a normal image of RSelenium (for example, selenium/standalone-firefox). This image is lighter that debug option. You can use the same ports and the same directories. To download periodically, you can use CRON to run your script when you want. More info here: https://stevenmortimer.com/automating-r-scripts-with-cron/.



