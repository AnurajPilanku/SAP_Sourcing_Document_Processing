import pywinauto
from robot.api.deco import keyword
from pywinauto import application as pwa
from pywinauto.application import Application
from pywinauto import Desktop
import os
import subprocess
import time
def sharepointfileupload(qualityPath,filecount):
    windows = Desktop(backend="uia").windows()
    print([w.window_text() for w in windows])
    avail_wind = [w.window_text() for w in windows]
    MainApplicationName="Evisort Contracts"
    fcount=str()
    file_multi=str()
    count=int(filecount)
    if count==int(1):
        fcount+='a'
        file_multi+="file"
    elif count==int(0):
        fcount+='0'
        file_multi += "files"
    else:
        fcount+=str(count)
        file_multi += "files"
    main_app = Application(backend="uia").connect(title_re=".*%s.*" % MainApplicationName, control_type="Window")
    app_dialog =main_app.top_window()
    app_dialog.set_focus()
    app_child = app_dialog.child_window(title="Select folder to upload", control_type="Window")
    #app_child.print_control_identifiers()
    app_child_1 = app_child.child_window(title="Folder:", auto_id="1152", control_type="Edit")
    app_child_1.iface_value.SetValue(qualityPath)
    UploadButton=app_child.child_window(title="Upload", auto_id="1", control_type="Button")
    UploadButton.invoke()
    #app_dialog.set_focus()
    time.sleep(5)
    permission=app_dialog.child_window(title="Upload {filecount} {files_mul} to this site?".format(filecount=str(fcount),files_mul=file_multi),control_type="Window")
    #permission.print_control_identifiers()
    Uploadgo=permission.child_window(title="Upload", control_type="Button")
    Uploadgo.invoke()
    time.sleep(3)
    return	"File Uploaded Successfully"
#exec_sp()