# in terminal pip install mysql-connector
#pip install --upgrade pip
#pip install mysqlclient

# in beggining run line 5 and 6 first
#from pip._internal import main
#main(['install','mysql-connector-python-rf'])
import mysql.connector

# TO VIEW THE TABLES
mydb2 = mysql.connector.connect(host="localhost", user="root", passwd="very_strong_password",database = "megacourse", auth_plugin='mysql_native_password')

mycursor =mydb2.cursor()

mycursor.execute("select * from student")

result = mycursor.fetchall()

for i in result:
    print(i)
