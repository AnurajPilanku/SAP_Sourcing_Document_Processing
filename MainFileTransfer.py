'''
Author          :  Anuraj Pilanku
Use case        : SAP Sourcing Document Processing
Code Utility    : creates versioning of duplicate files
'''
'''____________import modules__________ '''
import os
import shutil
import sys

# downloads=r"C:\Users\2040664\anuraj\lcs_borker"
# targetfolder=r"C:\Users\2040664\anuraj\ERP"
#file_names=['t2','t2','t2','vdgeef']
def mainDocFileTransfer(file_names,foldername,targetfolder,downloads):
    '''______Create Directories in target Folder________'''
    mainfolder=os.path.join(targetfolder,foldername)
    os.mkdir(mainfolder)
    os.mkdir(os.path.join(mainfolder,"Master_Agreements"))

    '''______Create Versioning of the dupliacte files________'''
    extenChange=lambda x:x.replace(".docx","").replace(".txt","").replace(".csv","").replace(".pdf","").replace(".xlsx","").replace(".py","").replace(".docs","")
    filenames=list(map(extenChange,file_names))
    if type(filenames) in ['str',str]:
        print(1111)
        uniqueFilelist=list(set(list(eval(filenames))))
    else:
        uniqueFilelist=list(set(list(filenames)))
    Allfiles=[]
    filecount={}
    for i in uniqueFilelist:
        filecount[i]=filenames.count(i)
    for file,count in filecount.items():
        for i in range(count):
            if i==0:
                Allfiles.append(file+".")
            else:
                Allfiles.append(file+"("+str(i)+")"+".")

    '''_________Transfer Files from downloads to target folder__________'''
    MainFileslist=[]
    fileNamesinDownloads=os.listdir(downloads)
    for filename in Allfiles:
        for dirfile in fileNamesinDownloads:
            if filename in dirfile:
                shutil.copy(os.path.join(downloads, dirfile), os.path.join(mainfolder, "Master_Agreements"))
                os.remove(os.path.join(downloads, dirfile))
                MainFileslist.append(dirfile)
    return  {"Downloaded Files Names : ":MainFileslist}
#print(mainDocFileTransfer(file_names,sys.argv[1]))



