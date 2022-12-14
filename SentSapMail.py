'''
Author          :  AnurajPilanku
Use Case        :  SAP Sourcing
Code Utility    : Sent Mail
'''
import os
import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication
from os.path import basename
import sys

# From = 'USSACPrd@mmm.com'
# To = sys.argv[1]
# cc = sys.argv[2]
# bcc = sys.argv[3]
# subject = "ACTIONHIS file missing for {}".format(todaynr)
# greetings = "Hi Team"
# body = "nsne2dn2d2e"
# signature = 'CAC Automation Centre'
# fontStyle = 'Times New Roman'
# attachment_list = ""
def sentmail(From,To,cc,bcc,subject,greetings,body,signature,fontStyle,attachment_list,header,footer):
    try:
        todaynr = str(datetime.date.today())
        html_file = '''
    
        <!DOCTYPE html>
        <html>
        <head>
        </head>
        <body>
          <h1></h1>
          <body style="font-family:{fontStyle}">
          <br/><img src='cid:image1'<br/>
          <br>
          <br>
          <br /><font face='{fontStyle}'>''' + greetings + ''',</font><br/>
    
          <br /><font face='{fontStyle}'>''' + body + ''' </font><br/>
          <br>
          <br>
    
    
        <div style="overflow-x:auto;">
    
        </div>
        <br /><font face='{fontStyle}'>Regards </font><br/>
        <br /><font face='{fontStyle}'>''' + signature + '''</font><br/>
        <br>
        <br>
        <br/><img src='cid:image3'<br/>
        </div>
        </body>
        </html>
        '''.format(fontStyle=fontStyle)
        msgRoot = MIMEMultipart('related')
        msgRoot['Subject'] = subject
        msgRoot['From'] = From
        msgRoot['Cc'] = cc
        msgRoot['To'] = To
        msgRoot['Bcc'] = bcc
        msgRoot.preamble = '====================================================='
        msgAlternative = MIMEMultipart('alternative')
        msgRoot.attach(msgAlternative)
        msgText = MIMEText('Please find ')
        msgAlternative.attach(msgText)
        msgText = MIMEText(html_file, 'html')
        msgAlternative.attach(msgText)
        msgAlternative.attach(msgText)
        fp = open(header, 'rb')
        fp3 = open(footer, 'rb')
        msgImage = MIMEImage(fp.read())
        msgImage2 = MIMEImage(fp3.read())
        fp.close()
        fp3.close()
        msgImage.add_header('Content-ID', '<image1>')
        msgImage2.add_header('Content-ID', '<image3>')
        msgRoot.attach(msgImage)
        msgRoot.attach(msgImage2)
        for f in attachment_list.split(','):
            with open(f, "rb") as file:
                part = MIMEApplication(file.read(), Name=basename(f))
                part["Content-Disposition"] = 'attachment;filename="%s"' % basename(f)
                msgRoot.attach(part)
        smtp = smtplib.SMTP()
        smtp.connect('mailserv.mmm.com')
        smtp.send_message(msgRoot)
        smtp.quit()
        return "SAP process completed & Mail sent to user successfully"
    except Exception as e:
        return e

#sentmail('USSACDev@mmm.com','P.Anuraj@cognizant.com','ac5qdzz@mmm.com','ac5qdzz@mmm.com','SAP Sourcing Document Processing','Hi Team','completede','3MAutomation Centre','Times New Roman',r"C:\Users\ac5qdzz\Desktop\output\SAP_Sourcing_Document_Details.xlsx")

