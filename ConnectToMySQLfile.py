# in terminal pip install mysql-connector
#pip install --upgrade pip
#pip install mysqlclient

# in beggining run line 5 and 6 first
#from pip._internal import main
#main(['install','mysql-connector-python-rf'])
import mysql.connector # connect to mysql with this pacakge

# TO VIEW THE DATA BASES
#mydb1 = mysql.connector.connect(host="localhost", user="root", passwd="very_strong_password",auth_plugin='mysql_native_password')

# connect to mysql with host localhost is default and user root is default
#mydb = mysql.connector.connect(host ="localhost", user ="root",passwd= "password",database ="zeus")

# see databases
#mycursor =mydb1.cursor()

#mycursor.execute("Show databases")
#mycursor.execute("select * from student")

#for i in mycursor:
#   print(i)

#######################################################
# TO VIEW THE TABLES
#mydb2 = mysql.connector.connect(host="localhost", user="root", passwd="very_strong_password",database = "blake", auth_plugin='mysql_native_password')

#mycursor =mydb2.cursor()

#mycursor.execute("select * from student")

#result = mycursor.fetchall()

#for i in result:
#    print(i)
