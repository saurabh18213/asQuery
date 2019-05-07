from flask import render_template
from app import app

@app.route('/')
def index():
    return render_template('base.html')

@app.route('/question')
def question():
    return render_template('index.html')