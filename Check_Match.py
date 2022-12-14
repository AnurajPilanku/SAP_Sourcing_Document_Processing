def inspectMatch(lst,txt):
    try:
        if str(txt) in str(lst):
            return 'matched'
        else:
            return 'unmatched'

    except Exception as e:
        return e