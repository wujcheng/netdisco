default["netdisco"]["home"] = "/home/netdisco"
default["netdisco"]["opt"] = "/opt/netdisco"
default["netdisco"]["directory"] = "/netdisco"
default["netdisco"]["package"] = "netdisco-1.3.3_with_mibs.tar.gz"
default["netdisco"]["database"]["user"] = "netdisco"
default["netdisco"]["database"]["password"] = "netdisco"
default["netdisco"]["dependancies"] = [
	'libdbd-pg-perl',
	'libsnmp-perl',
	'build-essential',
	'curl',
    'apache2'
]

default["netdisco"]["pg"]["corrections"] = [
	'print "Creating User',
    'print "Enter the $SYS_DB_USER',
    'system\(\$CREATEUSER\) and bug', 
    'print "Creating Database',
    'print "Enter the \$SYS_DB_USER',
    'system\(\$CREATEDB\) and bug', 
    'print "Creating tables and in',
    'print "If prompted'
]