'''
Author      :   Anuraj Pilanku
Usecase     :   SAP Sourcing Document Processing
Code Utility:   Get FolderPath
'''
import os
#folderroot = r'C:\Users\2040664\anuraj\EDI'
def getFolderPath(folderroot):
    folderPath={}
    sub_folders = [name for name in os.listdir(folderroot) if os.path.isdir(os.path.join(folderroot, name))]
    for folder in sub_folders:
        folderPath[folder]=os.path.join(folderroot,folder)
    return folderPath