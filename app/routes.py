from flask import render_template, flash, redirect, session, request, url_for, jsonify
from app import app
from flask_mysqldb import MySQL
from app.forms import *
from app.user import User, CreateUser
from app.methods import convert_to_four_column_bootstrap_renderable_list
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
    cur.execute("start transaction read only;")
    cur.execute('''select Q.question_id, Q.status, 
    Q.upvotes, Q.downvotes, Q.asked_at, Q.title,  Q.content, Q.userid,
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q;''')
    questions = cur.fetchall()
    cur.execute("commit;")
    return render_template('home.html', questions=questions)

@app.route('/newest')
def newest():
    cur = mysql.connection.cursor()
    cur.execute("start transaction read only;")
    cur.execute('''select Q.question_id, Q.status, 
    Q.upvotes, Q.downvotes, Q.asked_at, Q.title,  Q.content, Q.userid,
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q order by Q.asked_at desc;''')
    questions = cur.fetchall()
    cur.execute("commit;")
    return render_template('home.html', questions=questions)

@app.route('/popular')
def popular():
    cur = mysql.connection.cursor()
    cur.execute('''select Q.question_id, Q.status, 
    Q.upvotes, Q.downvotes, Q.asked_at, Q.title,  Q.content, Q.userid,
    (select count(*) from Answer A where A.question_id = Q.question_id)
    as answer_count, ( select U.username from User U where U.userid = Q.userid) 
    as username from Question Q order by (Q.upvotes-Q.downvotes) desc;''')
    questions = cur.fetchall()
    return render_template('home.html', questions=questions)

@app.route('/question/<int:id>', methods=['GET', 'POST'])
def question(id):
    form = AnswerForm()
    if form.validate_on_submit():
        cur = mysql.connection.cursor()
        create_question = "INSERT INTO Answer (content, question_id, userid) values (%s, %s, %s)"
        cur.execute(create_question, [form.answer.data, id, session['user']['userid']])
        mysql.connection.commit()
        return redirect('/question/{}'.format(id))
    cur = mysql.connection.cursor()
    question_query = "select Q.question_id, Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at, Q.userid, (select U.username from User U where U.userid = Q.userid) as username, (select count(*) from Answer A where A.question_id = Q.question_id) as answer_count from Question Q where Q.question_id = {}".format(id)
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
        cur.execute("start transaction read only;")
        query2 = '%' + request.form['search'] + '%'
        cur = mysql.connection.cursor()
        question_query = "select Q.title, Q.content, Q.upvotes, Q.downvotes, Q.asked_at, Q.userid, Q.question_id, (select U.username from User U where U.userid = Q.userid) as username, (select count(*) from Answer A where A.question_id = Q.question_id) as answer_count from Question Q where Q.title like %s"
        cur.execute(question_query, [query2])
        questionDetail = cur.fetchall()
        cur.execute("commit;")
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
            create_question = "INSERT INTO Question (status, content, title, userid) values (0, %s, %s, %s)"
            cur.execute(create_question, [form.body.data, form.title.data, session['user']['userid']])
            tags = request.form['dbtags']
            # print(tags)
            tags = tags.split()
            mysql.connection.commit()
            find_question = "select max(question_id) from Question"
            cur.execute(find_question)
            qid = cur.fetchone()
            cur = mysql.connection.cursor()
            # print(tags)

            for tag in tags:
                cquery = "select * from Tag where tagname='" + tag + "';"
                cur.execute(cquery)
                ctag = cur.fetchall()
                # print(ctag)

                if ctag:
                    tag_query = "Insert into Tagged(Tagname, question_id) values ('" + tag + "', " + str(qid['max(question_id)']) + ");"
                    cur.execute(tag_query)

            mysql.connection.commit()
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
    cur.execute("start transaction read only;")
    cur.execute("select u.username, u.reputation, u.userid, u.user_since from User u where u.userid = " + str(id) + ';')
    user = cur.fetchone()
    cur.execute("select q.title, q.question_id, q.asked_at, q.upvotes, q.downvotes from Question q where q.userid = " + str(id) + " order by q.asked_at DESC LIMIT 10;")
    questions = cur.fetchall()
    cur.execute("select q.title, q.question_id, a.answered_at, q.upvotes, q.downvotes from Question q, Answer a where a.question_id = q.question_id and a.userid = " + str(id) +" order by q.asked_at DESC LIMIT 10;")
    answers = cur.fetchall()
    cur.execute("commit;")
    return render_template('user.html', user=user, questions=questions, answers=answers)

@app.route('/users')
def users():
    cur = mysql.connection.cursor()
    cur.execute("start transaction read only;")
    cur.execute("select username, reputation, userid, user_since from User")
    users = cur.fetchall()
    cur.execute("commit;")
    user_list = convert_to_four_column_bootstrap_renderable_list(users)
    return render_template('users.html', user_list=user_list)

@app.route('/user_search', methods=['POST'])
def user_search():
    if request.method == 'POST':
        query = request.form['search']
        cur = mysql.connection.cursor()
        cur.execute("start transaction read only;")
        user_query = "select username, reputation, userid, user_since from User where username like '%{}%'".format(query)
        cur.execute(user_query)
        users = cur.fetchall()
        cur.execute("commit;")
        user_list = convert_to_four_column_bootstrap_renderable_list(users)
        return render_template('user_search.html', user_list=user_list, query=query)

@app.route('/tag/<string:tagname>')
def tag(tagname):
    cur = mysql.connection.cursor()
    cur.execute("start transaction read only;")
    cur.execute("select tagname, question_count, description from Tag where tagname = '" + tagname + "'")
    tag = cur.fetchone()
    cur.execute('''select q.title, q.question_id, q.asked_at, q.upvotes, q.downvotes, q.content, q.userid, (select count(*) from Answer A where A.question_id = q.question_id)
    as answer_count, ( select U.username from User U where U.userid = q.userid) 
    as username from Question q, Tagged t where t.question_id = q.question_id and t.tagname = "''' + tagname + '''";''')
    questions = cur.fetchall()
    cur.execute("commit;")
    return render_template('tag.html', tag=tag, questions=questions)

@app.route('/tags')
def tags():
    cur = mysql.connection.cursor()
    cur.execute("start transaction read only;")
    cur.execute("select tagname, question_count, description from Tag")
    tags = cur.fetchall()
    tag_list = convert_to_four_column_bootstrap_renderable_list(tags)
    cur.execute("commit;")
    return render_template('tags.html', tag_list=tag_list)

@app.route('/tag_search', methods=['POST'])
def tag_search():
    if request.method == 'POST':
        query = request.form['search']
        cur = mysql.connection.cursor()
        cur.execute("start transaction read only;")
        tag_query = "select tagname, question_count, description from Tag where tagname like '%{}%'".format(query)
        cur.execute(tag_query)
        tags = cur.fetchall()
        tag_list = convert_to_four_column_bootstrap_renderable_list(tags)
        cur.execute("commit;")
        return render_template('tag_search.html', tag_list=tag_list, query=query)


@app.route('/tag_match', methods=['POST'])
def tag_match():
    tag = request.form['tag']
    cur = mysql.connection.cursor()
    cur.execute("start transaction read only;")
    tag_query = "select tagname, description from Tag where tagname like '%{}%' LIMIT 6;".format(tag)
    cur.execute(tag_query)
    tags = cur.fetchall()
    cur.execute("commit;")
    return jsonify({'tags':tags})

@app.route('/upvote', methods=['POST'])
def upvote():
    if 'user' in session:
        if session['user']['reputation']>=5:
            qid = request.form['question_id']
            cur = mysql.connection.cursor()
            #query = "update Question set upvotes = upvotes + 1 where question_id = {};".format(qid)
            #cur.execute(query)
            #mysql.connection.commit()
            query = "call QuestionVote({}, {}, {});".format(session['user']['userid'], qid, 0)
            cur.execute(query)
            mysql.connection.commit()
            query = "select upvotes, downvotes from Question where question_id = {};".format(qid)
            cur.execute(query)
            response = cur.fetchone()
            print (response)
            return '{}'.format(response['upvotes']-response['downvotes'])

@app.route('/downvote', methods=['POST'])
def downvote():
    if 'user' in session:
        if session['user']['reputation']>=10:
            qid = request.form['question_id']
            cur = mysql.connection.cursor()
            query = "call QuestionVote({}, {}, {});".format(session['user']['userid'],qid, 1)
            cur.execute(query)
            mysql.connection.commit()
            query = "select upvotes, downvotes from Question where question_id = {};".format(qid)
            cur.execute(query)
            response = cur.fetchone()
            print (response)
            return '{}'.format(response['upvotes']-response['downvotes'])

@app.route('/upvoteanswer', methods=['POST'])
def upvoteAnswer():
    if 'user' in session:
        if session['user']['reputation']>=5:
            qid = request.form['question_id']
            aid = request.form['answer_id']
            cur = mysql.connection.cursor()
            query = "call AnswerVote({}, {}, {},{});".format(session['user']['userid'], qid, aid, 0)
            cur.execute(query)
            mysql.connection.commit()
            query = "select upvotes, downvotes from Answer where question_id = {} and answer_id = {};".format(qid, aid)
            cur.execute(query)
            response = cur.fetchone()
            print (response)
            return '{}'.format(response['upvotes']-response['downvotes'])

@app.route('/downvoteanswer', methods=['POST'])
def downvoteA():
    if 'user' in session:
        if session['user']['reputation']>=10:
            qid = request.form['question_id']
            aid = request.form['answer_id']
            cur = mysql.connection.cursor()
            query = "call AnswerVote({}, {}, {},{});".format(session['user']['userid'],qid, aid, 1)
            cur.execute(query)
            mysql.connection.commit()
            query = "select upvotes, downvotes from Answer where question_id = {} and answer_id = {};".format(qid, aid)
            cur.execute(query)
            response = cur.fetchone()
            print (response)
            return '{}'.format(response['upvotes']-response['downvotes'])