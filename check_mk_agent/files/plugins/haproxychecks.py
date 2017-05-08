# Example checks for the HAProxy plugin
checks = [
    #fieldname, warning, critical
    ['scur', '2000', '3000'],
    ['chkfail', '15', '25'],
    ['status', '', ''] # status stays at the end, just for formatting purposes
]

if __name__ == "__main__":
        print "This file is not meant to be called directly"
