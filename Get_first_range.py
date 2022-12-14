def validate_str_rep(txtpath):
    try:
        with open(txtpath, 'r') as data:
            d = data.read()
        if 'flow' not in d.lower():
            if d[-1]==".":
                f = eval(d[:-1])
                return f
            else:
                f = eval(d)
                return f
        else:
            return d
    except Exception as e:
        return "validate_str_rep : error - "+str(e)
