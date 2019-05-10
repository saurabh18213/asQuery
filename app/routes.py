from flask import render_template, flash, redirect, url_for, session, request, logging
from app import app
from flask_mysqldb import MySQL
from app.forms import LoginForm
#from wtforms import Form, StringField, TextAreaField, PasswordField, validators, IntegerField

app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'cs309_project'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
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
    #print(questions)
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



@app.route('/login', methods=['GET', 'POST'])
def login():
    # form = LoginForm(request.form)
    # if request.method == 'POST':
        # email = form['email'].data
        # password_input = form['password'].data
# 
        # cur = mysql.connection.cursor()
        # result = cur.execute("SELECT * FROM User where email = %s", [email])
        # if result>0:
            # data = cur.fetchone()
            # password = data['password']
            # if (password_input==password):
                # result = cur.execute("SELECT username FROM User where email = %s", [email])
                # data = cur.fetchone()
                # session['logged_in'] = True
                # session['username'] = username
                # session['userid'] = data['userid']
                # flash("You are now logged in", 'success')
                # return redirect(url_for('/'))
            # else:
                # error = 'Invalid Login'
                # return render_template('login.html', error= error)
        # else:
            # error = 'Invalid Login'
            # return render_template('login.html', error= error)
        # cur.close()
    return render_template('login.html')

    # if current_user.is_authenticated:
        # return redirect(url_for('/'))
    # form = LoginForm()
    # if form.validate_on_submit():
        # flash('Login requested for user {}, remember_me={}'.format(
            # form.username.data, form.remember_me.data))
        # return redirect('/')
    # return render_template('login.html', title='Sign In', form=form)
