'''
Author      :   Anuraj Pilanku
Usecase     :   SAP Sourcing Document Processing
Code Utility:   Get count of Files in Folder
'''
import os
#folderroot=r"C:\Users\2040664\anuraj\ipi2k\abc\anal\2022-12-08"
def CollectFileCount(folderroot):
    sub_folders = [name for name in os.listdir(folderroot) if os.path.isdir(os.path.join(folderroot, name))]
    TotalFoldercount = 0
    for folder in sub_folders:
        fold_in_fold_path = os.path.join(folderroot, folder)
        fold_in_fold = os.listdir(fold_in_fold_path)
        for sufolder in fold_in_fold:
            nav_files = os.path.join(fold_in_fold_path, sufolder)
            files = os.listdir(nav_files)
            lg = int(len(files))
            TotalFoldercount += lg
    return TotalFoldercount