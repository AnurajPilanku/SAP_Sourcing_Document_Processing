'''
Author      :   Anuraj Pilanku
Usecase     :   SAP Sourcing Document Processing
Code Utility:   Delete sub directories in Folder
'''
import shutil
import os
#folder=r"C:\Users\2040664\anuraj\EDI"#r"C:\Users\ac5qdzz\Desktop\output"
def deleteFolders(folder):
    try:
        rootdir = folder
        for it in os.scandir(rootdir):
            if it.is_dir():
                shutil.rmtree(str(it.path))
        return "Folders removed"
    except Exception as e:
        return e



