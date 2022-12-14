def retrieveTodaydate(txtpath):
    try:
        with open(txtpath,'r') as data:
            d=data.read()
        f=eval(d)
        return f['Todays_Date']
    except Exception as e:
        return e