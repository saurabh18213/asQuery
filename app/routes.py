from flask import render_template, flash, redirect, session
from app import app
from flask_mysqldb import MySQL
from app.forms import LoginForm
from app.user import User

app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'cs309_project'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
app.config['SECRET_KEY'] = 'you-will-never-guess'
mysql = MySQL(app)

@app.route('/')
def index():
    cur = mysql.connection.cursor()
    cur.execute('''select Q.question_id, Q.status, 
    Q.upvotes, Q.downvotes, Q.asked_at, Q.content,  
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q;''')
    questions = cur.fetchall()
    return render_template('home.html', questions=questions)

# @app.route('/question')
# def question():
#     return render_template('question.html')

# # @login_manager.user_loader
# # def user_loader(email):
# #     user = User(email)

# #     if user.is_active() is False:
# #         return

# #     return user


# # @login_manager.request_loader
# # def request_loader(request):
# #     email = request.form.get('email')
# #     user = User(email)

# #     if user.is_active() is False:
# #         return
# #     # DO NOT ever store passwords in plaintext and always compare password
# #     # hashes using constant-time comparison!
# #     user.set_authentication(request.form['password'])
# #     return user

# @app.route('/login', methods=['GET', 'POST'])
# def login():
#     form = LoginForm()

#     if form.validate_on_submit():
#         user = User(form.email.data)
#         user.set_authentication(form.password.data)
        
#         if user.is_authenticated(): 
#             session['user'] = user  
#             return redirect('/') 

#         return render_template('login.html', title='Sign In', form=form)

#     return render_template('login.html', title='Sign In', form=form)
