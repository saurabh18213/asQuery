from app import app
from flask_mysqldb import MySQL
from werkzeug.security import check_password_hash

mysql = MySQL(app)

class User():
    
    email = ""
    auth = False
    userid = 0
    activity = True
    pwd_hash = ""

    def __init__(self, email):
        cur = mysql.connection.cursor()
        query = '''select password, userid from User where email = ''' + str(email) + ''' ;'''
        cur.execute(query)
        result = cur.fetchone()
        self.email = email

        if result is None:
            self.activity = False
            return

        self.pwd_hash = result['password']
        self.userid = result['userid']
        self.email = email
        return

    def set_authentication(password):
        self.auth = check_password_hash(self.pwd_hash, 'password')
        return

    def is_authenticated():
        return self.auth

    def is_active():
        return self.activity

    def is_anonymous():
        return False

    def get_id():
        return self.userid   