'''
Author      :       Anuraj Pilanku
Use Case    :       SAP Sourcing
Code Utility:       Segragation of folders into a single Folder
'''
import datetime
import os
from datetime import timedelta,datetime
from pytz import timezone
import shutil
#combinedfolderpath=r"C:\Users\2040664\anuraj\ipi2k\abc"
#splittedfolderpath=r"C:\Users\2040664\anuraj\ipi2k\abc\anal"
def sap_directory_segregation(combinedfolderpath,splittedfolderpath):
    dateNow = str(datetime.now(timezone("Asia/Kolkata")))[:11].strip()
    newfolderpath = os.path.join(combinedfolderpath, dateNow)
    os.mkdir(newfolderpath)
    for folder in [x for x in os.listdir(splittedfolderpath) if '.xlsx' not in x]:
        # print(folder)
        mainmasteragree_dir = os.path.join(splittedfolderpath, folder)
        masteragree_dir = os.path.join(newfolderpath, folder)
        os.mkdir(masteragree_dir)
        subsub_dir = [x for x in os.listdir(mainmasteragree_dir) if '.' not in x]
        print(subsub_dir)
        for subfolder in subsub_dir:
            mainsubsub_dir_dir = os.path.join(mainmasteragree_dir, subfolder)
            subsub_dir_dir = os.path.join(masteragree_dir, subfolder)
            os.mkdir(subsub_dir_dir)
            for file in os.listdir(mainsubsub_dir_dir):
                shutil.copy(os.path.join(mainsubsub_dir_dir, file), subsub_dir_dir)
    return newfolderpath
#directory_segregation(combinedfolderpath,splittedfolderpath)
