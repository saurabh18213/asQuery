from flask import render_template
from app import app
from flask_mysqldb import MySQL

app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'cs309_project'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
mysql = MySQL(app)

@app.route('/')
def index():
    cur = mysql.connection.cursor()
    cur.execute("Select * from User")
    rv = cur.fetchall()
    print(rv)
    return render_template('base.html')

@app.route('/question')
def question():
    return render_template('index.html')