from flask import render_template, flash, redirect, session, request
from app import app
from flask_mysqldb import MySQL
from app.forms import LoginForm, SignupForm
from app.user import User, CreateUser
import json

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
    Q.upvotes, Q.downvotes, Q.asked_at, Q.title,  Q.content, Q.userid,
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q;''')
    questions = cur.fetchall()
    return render_template('home.html', questions=questions)

@app.route('/question/<int:id>')
def question(id):
    cur = mysql.connection.cursor()
    question_query = "select Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at from Question Q where Q.question_id = {}".format(id)
    cur.execute(question_query)
    questionDetail = cur.fetchone()
    answer_query = "select A.question_id, A.content, A.upvotes, A.downvotes, A.answered_at, (select U.userid from User U where U.userid = A.userid) as userid,  (select U.username from User U where U.userid = A.userid) as username from Answer A where A.question_id = {}".format(id) 
    cur.execute(answer_query)
    answerDetail = cur.fetchall()
    #print(answerDetail)
    return render_template('question.html', question=questionDetail, answers=answerDetail)

@app.route('/search', methods=['POST'])
def search():
    if request.method == 'POST':
        query = request.form['search']
        #print(query)
        cur = mysql.connection.cursor()
        question_query = "select Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at, Q.userid, Q.question_id, (select U.username from User U where U.userid = Q.userid) as username from Question Q where Q.title like '%{}%'".format(query)
        cur.execute(question_query)
        questionDetail = cur.fetchall()
        #print(questionDetail)
        #answer_query = "select A.question_id, A.content, A.upvotes, A.downvotes, A.answered_at, (select U.userid from User U where U.userid = A.userid) as userid,  (select U.username from User U where U.userid = A.userid) as username from Answer A where A.question_id = {}".format(id) 
        #cur.execute(answer_query)
        #answerDetail = cur.fetchall()
        #print(answerDetail)
        return render_template('searchresults.html', questions=questionDetail)



@app.route('/signup', methods=['GET', 'POST'])
def signup():
    form = SignupForm()

    if form.validate_on_submit():
        CreateUser(form.email.data, form.password.data, form.username.data)
        user = User(form.email.data)
        user.set_authentication(form.password.data)
        session['user'] = user.__dict__
        return redirect('/') 

    return render_template('signup.html', title='Sign In', form=form)    

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if form.validate_on_submit():
        user = User(form.email.data)
        user.set_authentication(form.password.data)
        
        if user.is_authenticated(): 
            session['user'] = user.__dict__
            return redirect('/') 

        return render_template('login.html', title='Log In', form=form)

    return render_template('login.html', title='Log In', form=form)

@app.route('/askquestion')
def askquestion():
    return render_template('askquestion.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect('/')

