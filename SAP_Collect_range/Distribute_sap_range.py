'''
Use Case    :   SAP Sourcing Document Processing
'''
#sap_range={1:20,2:23,3:31,4:37}#------Input--------#
#flow_delimiter=5#----Number of documents to be processed per activity------#
#day_delimiter=7#-----Number of activity per day-----#

def Download_per_delimiter(sap_range,flow_delimiter,day_delimiter):
    actions_per_day=[]
    cat_dic={}
    update={}
    for ke,val in sap_range.items():
        sing_use=[]
        sing_use.append(val)
        mul_delim = [mn*flow_delimiter for mn in range(0,val+1) if mn*flow_delimiter<=val]
        cat_dic[ke]=mul_delim+sing_use
    for i in range(0,len(cat_dic)):
        arr=list(cat_dic.values())[i]
        update[list(cat_dic.keys())[i]]=[arr[i] for i in range(len(arr)) if i==arr.index(arr[i])]
    #splitting into documnets per activity
    compl_split=[]
    for i,j in update.items():
        for k in range(0,len(j)):
            fj_dic = {}
            if k<len(j)-1:
                small=[sd for sd in range(j[k],j[k+1]+1)]
                fj_dic[i]=small[1:]#if zero is not required
                compl_split.append(fj_dic)
    #Splitting into actions per day
    for docs in range(0,len(compl_split),day_delimiter):
        spli_=compl_split[docs:docs+day_delimiter]
        actions_per_day.append(spli_)
    return actions_per_day