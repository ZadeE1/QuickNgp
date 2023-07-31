# Makes creating a `Nerf`, `simple` and `easy`, based on [`Instant-ngp`](https://github.com/NVlabs/instant-ngp)


- **Requires Python To Be Installed 3.8 And Above Along With The Latest Cuda Driver**

-  **NVIDIA GPU REQUIRED TO RUN AND USE INSTANT-NGP**
  
- **CMAKE GIT MSVC CUDA-TOOLKIT CONDA MUST BE INSTALLED IF YOU WOULD LIKE TO BUILD FROM SCRATCH** 

## **Things to know**
- any paths with a space  will cause errors which include:
  - the location where you cloned/downloaded this repo
    
  - any paths that you input in the config.txt - config.txt will appear after running the install bat
 
- any slashes at the end of any inputted path inside config.txt will cause errors
    
- any Y/N questions can only be responded in capitals, Y or N
  
- if you don't have anaconda or miniconda installed and come across " - use conda (Y/N): " simply reply `N`
  
- dir/path/folder may be used interchangeably  in this repo
  
- any numerical questions can only be responded to in numbers or it can create unwanted errors
  
- when running the `install_rtx_3000_and_4000.bat` or any `Install bats` you agree to the Licence that comes with this repo
  
- build instant ngp yourself using included bats if any problems occur refer to [Compilation for Windows](https://github.com/NVlabs/instant-ngp#compilation:~:text=Compilation,config%20RelWithDebInfo%20%2Dj) 

## **How to build yourself**
1. run `initbuild.bat`
  
2. (**OPTIONAL**) If you want dlss support [download vulkan sdk](https://sdk.lunarg.com/sdk/download/1.3.250.1/windows/VulkanSDK-1.3.250.1-Installer.exe) then run the installer and when it comes to configuring simply press the `select all` button then continue until installed
   
3. run `cmakebuild.bat` make sure you run it from the `Installs` folder and using an activated conda environtment, if it fails, go inside `instant-ngp` under the `Installs` folder and delete the `build` folder and try again, if that doesn't work refer to [Compile errors](https://github.com/NVlabs/instant-ngp#troubleshooting-compile-errors) 


## **How to use - Video to Images To Nerf** 
1. download this repo/clone it in any folder of your choice - make sure the path that you choose has no `spaces`
   
2. run the `install_rtx_3000_and_4000.bat` or build your self 
   
3. open the `config.txt` file and paste the full path to any empty folder right after the "=", it should look something like this `"ProjectDir=C:\project"` or alternativly drag and drop the project folder on to DragAndDropProjectDir.bat <br>  `note:` the project folder is where any saved data will go including images, videos that you wish to convert into nerfs and generated colmap data 
   
4. place any video that you want to convert into a nerf inside the project folder, then run the `videotoimages.bat` in `QuickRuns` <br>it will ask " - Name of video inside Where ever you decided the project path to be: " and respond with the video file name - for example, `VIDEO.MP4` <br> it will then ask, " - Frames per second ( 5 recommended ): " - high fps will produce better nerf models but will negatively impact performance
   
5. run `imagestonerf.bat` in `QuickRuns` the speed of this process may depend on what hardware you are running
    
6. (**OPTIONAL**) running `openproject.bat` in `QuickRuns` will quickly open `instant-ngp`

# 

## **Command line shortcuts**
### Install bats
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints help page - not implemented                               |
| --conda  `env-name`     | Activates the conda environment you chose, passing 0 will not activate conda but will avoid it asking if you would like to use conda|
| --colmapforcuda | Installs the cuda version of colmap for supported devices|
### videotoimages.bat
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints help page - not implemented                               |
| --video  `vid-name`     | The target video to convert to images inside the project dir|
| --fps `fps`             | How many frames you will extract for every second of the video|
### imagestonerf.bat
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints help page - not implemented                               |
| --conda  `env-name`     | Activates the conda environment you chose, passing 0 will not activate conda but will avoid it asking if you would like to use conda|
| --colmaprun     | Runs colmap in order to convert images into a nerf|
| --highdetail   | Changes camera position accuracy to the highest level|



some things may not work as it still in progress *any* problems that occur please create an issue

