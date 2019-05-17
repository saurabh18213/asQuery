from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Email
from wtforms.widgets import TextArea

class LoginForm(FlaskForm):
    password = PasswordField('Password', validators=[DataRequired()])
    email = StringField('Email Address', validators=[DataRequired(), Email()])
    remember_me = BooleanField('Remember Me')
    submit = SubmitField('Log In')

class SignupForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    email = StringField('Email Address', validators=[DataRequired(), Email()])
    remember_me = BooleanField('Remember Me')
    submit = SubmitField('Sign Up')

class AskQuestion(FlaskForm):
    title = StringField('Title', validators=[DataRequired()])
    body = StringField('Question Body', widget=TextArea())
    submit = SubmitField('Submit')

class AnswerForm(FlaskForm):
    answer = StringField('Post your answer', widget=TextArea())
    submit = SubmitField('Submit')