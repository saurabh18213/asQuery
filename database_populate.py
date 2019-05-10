import mysql.connector 

mydb = mysql.connector.connect(
  user="root",
  passwd="",
  database="cs309_project"
)

user_insert_str = "insert into User(email, password, username) values (%s, %s, %s)"
question_insert_str = "insert into Question (content, userid, title) values (%s, %s, %s);"
answer_insert_str = "insert into Answer (content, question_id, userid) values (%s, %s, %s);"

def user_insert_vals(n):
    return ("user" + str(n) + "@users.com", "samplepassword" + str(n), "user" + str(n))

def question_insert_vals(n, m):
    return ("Content of Question No. " + str(n) + " ?", m, "Title of Question " + str(n))

def answer_insert_vals(n, m, t):
    return ("This is answer number " + str(n) + " .", m, t)

mycursor = mydb.cursor()

for i in range(1, 50):
    mycursor.execute(user_insert_str, user_insert_vals(i))

k = 0

for i in range(1, 50):
    for j in range(1, 10):
        k = k + 1   
        mycursor.execute(question_insert_str, question_insert_vals(k, i))

k = 0

for i in range(1, 442):
    for j in range(1, 4):
        k = k + 1   
        mycursor.execute(answer_insert_str, answer_insert_vals(k, i, (i + j) % 9 + 1))


mydb.commit()
