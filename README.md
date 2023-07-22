### **Makes making a Nerf, simple and easy**

### **Requires Python To Be Installed 3.8 And Above Along With The Latest Cuda Driver**

### **NVIDIA GPU REQUIRED TO RUN AND USE INSTANT-NGP**

### **Things to know**
- any paths with a space will cause errors which include:
  - the location where you cloned/downloaded this repo
  - any paths that you input in the config.txt - config.txt will appear after running the install bat
- any Y/N questions can only be responded in capitals, Y or N
- if you don't have anaconda or miniconda installed and come across " - use conda (Y/N): " simply reply **N**
- dir/path/folder may be used interchangeably in the command line prompts and in this repo
- any numerical questions can only be responded to in numbers or it can create unwanted errors
- when running the **install_rtx_3000_and_4000.bat** you agree to the Licence that comes with this repo


### **How to use**
1. download this repo/clone it in any folder of your choice - make sure the path that you choose has no **spaces**
2. run the **install_rtx_3000_and_4000.bat**
3. open the config.txt file and paste the full path to any **empty folder** right after the "=", it should look something like this "ProjectDir=C:\project" **note**: the project folder is where any saved data will go including images, videos that you wish to convert into nerfs and generated colmap data
4. place any video that you want to convert into a nerf inside the project folder, then run the **videotoimages.bat** it will ask " - Name of video inside **Where ever you decided the project path to be**: " and respond with the video file name - for example, **VIDEO.MP4** it will then ask, " - Frames per second ( 5 recommended ): " - high fps will produce better nerf models but will negatively impact performance
5. run **imagestonerf.bat** the speed of this process may depend on what hardware you are running
6. (**OPTIONAL**) running **openproject.bat** will open instant-ngp and 

this may still have bugs and it would be appreciated if you create an issue post describing the bug 

if your GPU is not from the 3000 or 4000 you will need to build instant ngp yourself refer to [Compilation for Windows](https://github.com/NVlabs/instant-ngp#compilation:~:text=Compilation,config%20RelWithDebInfo%20%2Dj) and edit NgpPath in config.txt to where you built instant-ngp
