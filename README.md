# **Makes creating a Nerf, simple and easy**, based on [Insant-ngp](https://github.com/NVlabs/instant-ngp)

- **Requires Python To Be Installed 3.8 And Above Along With The Latest Cuda Driver**

-  **NVIDIA GPU REQUIRED TO RUN AND USE INSTANT-NGP**
  
- **CMAKE & GIT MUST BE INSTALLED IF YOU WOULD LIKE TO BUILD FROM SCRATCH** 

## **Things to know**
- any paths with a space will cause errors which include:
  - the location where you cloned/downloaded this repo
    
  - any paths that you input in the config.txt - config.txt will appear after running the install bat
    
- any Y/N questions can only be responded in capitals, Y or N
  
- if you don't have anaconda or miniconda installed and come across " - use conda (Y/N): " simply reply **N**
  
- dir/path/folder may be used interchangeably in the command line prompts and in this repo
  
- any numerical questions can only be responded to in numbers or it can create unwanted errors
  
- when running the `install_rtx_3000_and_4000.bat` you agree to the Licence that comes with this repo
  
- if your GPU is not from the 3000 or 4000 you will need to build instant ngp yourself refer to [Compilation for Windows](https://github.com/NVlabs/instant-ngp#compilation:~:text=Compilation,config%20RelWithDebInfo%20%2Dj) or run `buildfromscratch.bat` and edit NgpPath in config.txt to where you built instant-ngp


## **How to use**
1. download this repo/clone it in any folder of your choice - make sure the path that you choose has no **spaces**
   
2. run the `install_rtx_3000_and_4000.bat` or `buildfromscratch.bat` inside Installs
   
3. open the config.txt file and paste the full path to any **empty folder** right after the "=", it should look something like this `"ProjectDir=C:\project"` `note:` the project folder is where any saved data will go including images, videos that you wish to convert into nerfs and generated colmap data
   
4. place any video that you want to convert into a nerf inside the project folder, then run the `videotoimages.bat` in QuickRuns it will ask " - Name of video inside **Where ever you decided the project path to be**: " and respond with the video file name - for example, `VIDEO.MP4` it will then ask, " - Frames per second ( 5 recommended ): " - high fps will produce better nerf models but will negatively impact performance
   
5. run `imagestonerf.bat` in QuickRuns the speed of this process may depend on what hardware you are running
    
6. (**OPTIONAL**) running `openproject.bat` in QuickRuns will quickly open instant-ngp


## **Command line args**
### Intall bats
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints all commands                                      |
| --conda  `env-name`     | Activates the conda environment you chose, passing 0 will not activate conda but will avoid it asking if you would like to use conda|
| --colmapforcuda `(Y/N)` | Installs the cuda version of colmap for supported devices|
### videotoimages.bat
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints all commands                                      |
| --video  `Vid name`     | The target video to convert to images inside the project dir|
| --fps `fps`             | How many frames you will extract for every second of the video|
### imagestonerf.bat
| Command                 | Use                                                      |
| :---------------------- | :------------------------------------------------------- |
| -h                      | Prints all commands                                      |
| --conda  `env-name`     | Activates the conda environment you chose, passing 0 will not activate conda but will avoid it asking if you would like to use conda|
| --colmaprun `(Y/N)`    | Runs colmap in order to convert images into a nerf       |



buildfromscratch.bat may not work as it still has some bugs

