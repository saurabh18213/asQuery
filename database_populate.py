import mysql.connector 
from werkzeug.security import generate_password_hash

mydb = mysql.connector.connect(
  user="root",
  passwd="",
  database="cs309_project"
)

user_insert_str = "insert into User(email, password, username) values (%s, %s, %s)"
question_insert_str = "insert into Question (content, userid, title) values (%s, %s, %s);"
answer_insert_str = "insert into Answer (content, question_id, userid) values (%s, %s, %s);"
tag_insert_str = "insert into Tag (tagname, description) values (%s, %s);"
tagged_insert_str = "insert into Tagged (tagname, question_id) values (%s, %s);"

def user_insert_vals(n):
    return ("user" + str(n) + "@users.com", generate_password_hash("samplepassword" + str(n)), "user" + str(n))

def question_insert_vals(n, m):
    return ("Content of Question No. " + str(n) + " ?", m, "Title of Question " + str(n))

def answer_insert_vals(n, m, t):
    return ("This is answer number " + str(n) + " .", m, t)

mycursor = mydb.cursor()

for i in range(1, 300):
    mycursor.execute(user_insert_str, user_insert_vals(i))

k = 0

for i in range(1, 300):
    for j in range(1, 5):
        k = k + 1   
        mycursor.execute(question_insert_str, question_insert_vals(k, i))

for i in range(1, 1000):
    for j in range(1, 6):
        mycursor.execute(answer_insert_str, answer_insert_vals(j, i, ((i + j) % 257) + 1))

for i in range(1, 260):
	mycursor.execute(tag_insert_str, ("tag" + str(i), "description of tag" + str(i)))

for i in range(1, 260):
    for j in range(1, 5):
        mycursor.execute(tagged_insert_str,("tag" + str(i), j * i))

mydb.commit()