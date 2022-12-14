from pytz import timezone
from datetime import datetime
def indiantimeUpdate():
    ind_time = str(datetime.now(timezone("Asia/Kolkata")).strftime('%Y-%m-%d')).strip()
    return ind_time