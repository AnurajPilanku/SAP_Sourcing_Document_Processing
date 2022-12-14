'''
Author      :       Anuraj Pilanku
Use Case    :       SAP Sourcing
Code Utility:       Preparation of data for next run
'''
import datetime
from datetime import timedelta
from pytz import timezone
from datetime import datetime

def next_run_preparation(data,summary_file,distributed_range_file):
    data_res = data[1:]
    try:
        new_out = data[0][1:]
        data_res.insert(0, new_out)
        count = 0
        for item in data_res:
            if item == []:
                count += 1
        if count > 0:
            # change date
            with open(summary_file,'r') as r_sumdata:
                c_data=r_sumdata.read()
                c_dic=eval(c_data)
                c_dic['Todays_Date']=str(datetime.now(timezone("Asia/Kolkata"))+timedelta(1))[:11].strip()#str(datetime.date.today()+timedelta(1))
                r_sumdata.close()
            with open(summary_file,'w') as sumdata:
                sumdata.write(str(c_dic))
                sumdata.close()
            non_empt_li = list(filter(None, data_res))
            with open(distributed_range_file,'w') as dis_data:
                dis_data.write(str(non_empt_li))
                dis_data.close()
            msge= "Todays Flow is completed.... "
        else:
            non_empt_li = list(filter(None, data_res))
            with open(distributed_range_file,'w') as dis_data:
                dis_data.write(str(non_empt_li))
                dis_data.close()
            msge= "continue todays flow...."
        if non_empt_li == []:
            # update in text file Flow    Completed
            with open(distributed_range_file,'w') as dis_data:
                dis_data.write(str('Flow Completed'))
                dis_data.close()
            msge+= " ; Entire Flow is completed..."
            return msge
        else:
            return "Entire Flow is yet to be finished.... ; "+msge
        # else:
        #     non_empt_dic = []
        #     for li_s in non_empt_li:
        #         non_empt_dic.append(list(filter(None, li_s)))
        #     #write non empt into txt
        # return  'Next flow prepared..')
    except Exception as e:
        return e