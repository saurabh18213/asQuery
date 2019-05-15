from app import app
import mysql.connector 
from werkzeug.security import check_password_hash, generate_password_hash

mydb = mysql.connector.connect(
  user="root",
  passwd="",
  database="cs309_project"
)

user_insert_str = "insert into User(email, password, username) values (%s, %s, %s)"

def CreateUser(email, password, username):
    user_data = (str(email), generate_password_hash(password), str(username))
    cur = mydb.cursor()
    cur.execute(user_insert_str, user_data)
    mydb.commit()
    return

class User():
    
    email = ""
    auth = False
    userid = 0
    activity = True
    pwd_hash = ""
    username = ""

    def __init__(self, email):
        cur = mydb.cursor()
        query = "select password, userid, username  from User where email = '" + email +  "';"
        cur.execute(query)
        result = cur.fetchone()
        self.email = email

        if result is None:
            self.activity = False
            return

        self.pwd_hash = result[0]
        self.userid = result[1]
        self.email = email
        self.username = result[2]
        return

    def set_authentication(self, password):
        self.auth = check_password_hash(self.pwd_hash, password)
        return

    def is_authenticated(self):
        return self.auth

    def is_active(self):
        return self.activity

    def is_anonymous(self):
        return False

    def get_id(self):
        return self.userid       