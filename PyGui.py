import tkinter as tk
import os

root = tk.Tk()

# Create a variable to store the arguments for file.bat
arguments = []

def toggle_conda():
    global arguments
    if arguments.count("--conda") == 0:
        arguments.append("--conda")
    else:
        arguments.remove("--conda")
    print(arguments)

def toggle_colmap():
    global arguments
    if arguments.count("--colmap") == 0:
        arguments.append("--colmap")
    else:
        arguments.remove("--colmap")
    print(arguments)

def run_file():
    # Run file.bat with the specified arguments
    os.system("echo " + " ".join(arguments))


# Create a button to toggle conda
conda_btn = tk.Button(root, text="Use Conda", command=toggle_conda)
conda_btn.pack(pady=5)

# Create a button to toggle colmap
colmap_btn = tk.Button(root, text="Install Colmap for CUDA", command=toggle_colmap)
colmap_btn.pack(pady=5)

# Create a button to run file.bat
run_btn = tk.Button(root, text="Install for RTX 3000", command=run_file)
run_btn.pack(pady=5)


root.mainloop()