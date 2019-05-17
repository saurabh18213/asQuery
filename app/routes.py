from flask import render_template, flash, redirect, session, request, url_for
from app import app
from flask_mysqldb import MySQL
from app.forms import *
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

@app.route('/newest')
def newest():
    cur = mysql.connection.cursor()
    cur.execute('''select Q.question_id, Q.status, 
    Q.upvotes, Q.downvotes, Q.asked_at, Q.title,  Q.content, Q.userid,
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q order by Q.asked_at desc;''')
    questions = cur.fetchall()
    return render_template('home.html', questions=questions)

@app.route('/question/<int:id>', methods=['GET', 'POST'])
def question(id):
    form = AnswerForm()
    if form.validate_on_submit():
        cur = mysql.connection.cursor()
        create_question = "INSERT INTO Answer (content, question_id, userid) values ('{}', {}, {})".format(form.answer.data, id, session['user']['userid'])
        cur.execute(create_question)
        mysql.connection.commit()
        return redirect('/question/{}'.format(id))
    cur = mysql.connection.cursor()
    question_query = "select Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at, Q.userid, (select U.username from User U where U.userid = Q.userid) as username, (select count(*) from Answer A where A.question_id = Q.question_id) as answer_count from Question Q where Q.question_id = {}".format(id)
    cur.execute(question_query)
    questionDetail = cur.fetchone()
    # print(questionDetail)
    answer_query = "select A.question_id, A.content, A.upvotes, A.downvotes, A.answered_at, (select U.userid from User U where U.userid = A.userid) as userid,  (select U.username from User U where U.userid = A.userid) as username from Answer A where A.question_id = {}".format(id) 
    cur.execute(answer_query)
    answerDetail = cur.fetchall()
    #print(answerDetail)
    return render_template('question.html', question=questionDetail, answers=answerDetail, qid=id, form=form)

@app.route('/search', methods=['POST'])
def search():
    if request.method == 'POST':
        query = request.form['search']
        #print(query)
        cur = mysql.connection.cursor()
        question_query = "select Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at, Q.userid, Q.question_id, (select U.username from User U where U.userid = Q.userid) as username, (select count(*) from Answer A where A.question_id = Q.question_id) as answer_count from Question Q where Q.title like '%{}%'".format(query)
        cur.execute(question_query)
        questionDetail = cur.fetchall()
        #print(questionDetail)
        #answer_query = "select A.question_id, A.content, A.upvotes, A.downvotes, A.answered_at, (select U.userid from User U where U.userid = A.userid) as userid,  (select U.username from User U where U.userid = A.userid) as username from Answer A where A.question_id = {}".format(id) 
        #cur.execute(answer_query)
        #answerDetail = cur.fetchall()
        #print(answerDetail)
        return render_template('searchresults.html', questions=questionDetail, searchquery = query)



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

@app.route('/askquestion', methods=['GET', 'POST'])
def askquestion():
    if 'user' in session:
        form = AskQuestion() 
        if form.validate_on_submit():
            cur = mysql.connection.cursor()
            create_question = "INSERT INTO Question (status, content, title, userid) values (0, '{}', '{}', {})".format(form.body.data, form.title.data, session['user']['userid'])
            cur.execute(create_question)
            mysql.connection.commit()
            find_question = "select max(question_id) from Question"
            cur.execute(find_question)
            qid = cur.fetchone()
            print (qid['max(question_id)'])
            return redirect('/question/{}'.format(qid['max(question_id)']))
        return render_template('askquestion.html', form=form)
    return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect('/')

@app.route('/user/<int:id>')
def user(id):
    cur = mysql.connection.cursor()
    cur.execute("select u.username, u.reputation, u.userid, u.user_since from User u where u.userid = " + str(id) + ';')
    user = cur.fetchone()
    cur.execute("select q.title, q.question_id, q.asked_at, q.upvotes, q.downvotes from Question q where q.userid = " + str(id) + " order by q.asked_at DESC LIMIT 10;")
    questions = cur.fetchall()
    cur.execute("select q.title, q.question_id, a.answered_at, q.upvotes, q.downvotes from Question q, Answer a where a.question_id = q.question_id and a.userid = " + str(id) +" order by q.asked_at DESC LIMIT 10;")
    answers = cur.fetchall()
    
    return render_template('user.html', user=user, questions=questions, answers=answers)

@app.route('/users')
def users():
    cur = mysql.connection.cursor()
    cur.execute("select username, reputation, userid, user_since from User")
    users = cur.fetchall()
    users_size = len(users)
    x = int(users_size / 4)

    if users_size % 4:
        x = x + 1

    print(x)
    return render_template('users.html', users=users)

@app.route('/user_search', methods=['POST'])
def user_search():
    if request.method == 'POST':
        query = request.form['search']
        cur = mysql.connection.cursor()
        user_query = "select username, reputation, userid, user_since from User where username like '%{}%'".format(query)
        cur.execute(user_query)
        userDetail = cur.fetchall()
        return render_template('', users=userDetail)

@app.route('/tag/<string:tagname>')
def tag(tagname):
    cur = mysql.connection.cursor()
    cur.execute("select tagname, question_count, description from Tag where tagname = " + tagname)
    tag = cur.fetchone()
    cur.execute("select q.title, q.question_id, q.asked_at from Question q, Tagged t where t.question_id = q.question_id and t.tagname = " + tagname)
    questions = cur.fetchall()

    return render_template('', tag=tag, questions=questions)

@app.route('/tags')
def tags():
    cur = mysql.connection.cursor()
    cur.execute("select tagname, question_count, description from Tag")
    tags = cur.fetchall()

    return render_template('tags.html', tags=tags)

@app.route('/tag_search', methods=['POST'])
def tag_search():
    if request.method == 'POST':
        query = request.form['search']
        cur = mysql.connection.cursor()
        tag_query = "select tagname, question_count, description from Tag where tagname like '%{}%'".format(query)
        cur.execute(tag_query)
        tagDetail = cur.fetchall()
        return render_template('', tags=tagDetail)