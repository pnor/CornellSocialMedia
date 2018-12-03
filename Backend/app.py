import json
from db import db, Post, Comment, User
from flask import redirect, Flask, request
import httplib2
import os
import requests
import urllib
try:
    import urllib.request as urllib2
except ImportError:
    import urllib2
import storage

#export GOOGLE_APPLICATION_CREDENTIALS='file.txt'

db_filename = "todo.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True
app.config['SECRET_KEY'] = 'secret'
app.config['ALLOWED_EXTENSIONS'] = set(['png', 'jpg', 'jpeg', 'gif'])
app.config['CLOUD_STORAGE_BUCKET'] = 'social-media-app-223812'
app.config['PROJECT_ID'] = 'social-media-app-223812'
#os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'social-media-app-223812-41df44fe0210.json'

db.init_app(app)
with app.app_context():
    db.create_all()

SCOPES = 'https://www.googleapis.com/auth/plus.login+https://www.googleapis.com/auth/gmail.readonly'
SERVICE_ACCOUNT_FILE = 'file.txt'
APPLICATION_NAME = 'Google+ Python Quickstart'
CLIENT_ID = '787761958789-2s8u9k7e5663h79l240d57s2lf6o4005.apps.googleusercontent.com'
CLIENT_SECRET = '1QiAnxayfVBgQECmx0cFY5eU'
REDIRECT_URL = 'https://localhost:5000/login/'

id = ""
temp_image = "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"
temp_user = ""
temp_pass = ""

@app.route('/api/profile/user/create/', methods=['POST'])
def create_profile():
    global id
    global temp_image
    global temp_user
    global temp_pass
    temp_display = request.form.get('display_name')
    temp_year = request.form.get('year')
    temp_college = request.form.get('college')
    temp_major = request.form.get('major')

    image = request.files.get('image')
    if image is not None:
        image_url = upload_image_file(image)
    else:
        image_url = temp_image

    user = User(
        netid = id,
        display_name = temp_display,
        username = temp_user,
        password = temp_pass,
        image = image_url,
        year = temp_year,
        college = temp_college,
        major = temp_major
    )
    db.session.add(user)
    db.session.commit()

    return redirect('/')

@app.route('/login/', methods=['POST'])
def login():
    post_body = json.loads(request.data)
    username = post_body.get('username')

    array = username.split('@')

    if len(array) == 2 and array[1] == "cornell.edu":
        global id 
        id = array[0]
    else:
        return json.dumps({'success': False, 'error': 'Not cornell email'}), 404

    user = User.query.filter_by(netid = id).first()
    if user is not None:
        if user.password == post_body.get('password'):
            return json.dumps(user.serialize()), 200
        return json.dumps({'success': False, 'error': 'Invalid password'}), 403
    
    if (post_body.get('password') == ""):
        return json.dumps({'success': False, 'error': 'Invalid password'}), 403

    global temp_user
    global temp_pass
    temp_user = username
    temp_pass = post_body.get('password')

    return json.dumps({'success': False, 'error': 'No user profile'}), 406

@app.route('/logout/')
def logout():
    global id
    id = ""
    return redirect('/')

@app.route('/')
@app.route('/api/posts/')
def get_posts():
    posts = Post.query.all()
    res = [post.serialize() for post in posts]
    return json.dumps(res), 200

@app.route('/api/posts/user/')
def get_posts_by_id():
    global id
    posts = Post.query.filter_by(netid = id)
    res = [post.serialize() for post in posts]
    return json.dumps(res), 200

@app.route('/api/posts/<string:person>/')
def get_posts_of_person(person):
    posts = Post.query.filter_by(netid = person)
    res = [post.serialize() for post in posts]
    return json.dumps(res), 200

@app.route('/api/posts/', methods=['POST'])
def create_post():
    global id
    image = request.files.get('image')
    image_url = upload_image_file(image)
    post = Post(
        text = request.form.get('text'),
        netid = id,
        image = image_url
    )
    db.session.add(post)
    db.session.commit()
    return json.dumps(post.serialize()), 201

def upload_image_file(file):
    """
    Upload the user-uploaded file to Google Cloud Storage and retrieve its
    publicly-accessible URL.
    """
    if not file:
        return None
    public_url = storage.upload_file(
        file.read(),
        file.filename,
        file.content_type
    )
    return public_url

@app.route('/api/post/<int:post_id>/')
def get_post(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        return json.dumps(post.serialize()), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/post/<int:post_id>/', methods=['POST'])
def update_post(post_id):
    global id
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        if post.netid == id:
            image = request.files.get('image')
            image_url - upload_image_file(image)
            post.text = request.data.get('text')
            post.image = image_url
            db.session.commit() 
            return json.dumps(post.serialize()), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/post/<int:post_id>/vote/', methods=['POST'])
def vote_post(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        post_body = json.loads(request.data)
        vote = post_body.get('vote')
        if (vote is None or vote):
            post.score = post.score + 1
        else:
            post.score = post.score - 1
        db.session.commit()
        
        return json.dumps(post.serialize()), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/post/<int:post_id>/', methods=['DELETE'])
def delete_post(post_id):
    global id
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        if post.netid == id:
            db.session.delete(post)
            db.session.commit()
            return json.dumps(post.serialize()), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404 

@app.route('/api/post/<int:post_id>/comments/')
def get_comments(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        comments = [comment.serialize() for comment in post.comments]  
        return json.dumps(comments), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/post/<int:post_id>/comment/', methods=['POST'])
def create_comment(post_id): 
    post = Post.query.filter_by(id=post_id).first()
    global id
    if post is not None:
        post_body = json.loads(request.data)
        comment = Comment(
            text = post_body.get('text'),
            netid = id,
            post_id = post.id
        )
        post.comments.append(comment)
        db.session.add(comment)
        db.session.commit()
        return json.dumps(comment.serialize()), 201
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/comment/<int:comment_id>/', methods=['POST'])
def update_comment(comment_id):
    global id
    comment = Comment.query.filter_by(id=comment_id).first()
    if comment is not None:
        if comment.netid == id:
            post_body = json.loads(request.data)
            comment.text = post_body.get('text', comment.text)
            db.session.commit() 
            return json.dumps(comment.serialize()), 200
    return json.dumps({'success': False, 'error': 'Comment not found!'}), 404

@app.route('/api/comment/<int:comment_id>/vote/', methods=['POST'])
def vote_comment(comment_id):
    comment = Comment.query.filter_by(id=comment_id).first()
    if comment is not None:
        post_body = json.loads(request.data)
        vote = post_body.get('vote')
        if (vote is None or vote):
            comment.score = comment.score + 1
        else:
            comment.score = comment.score - 1
        db.session.commit()
        
        return json.dumps(comment.serialize()), 200
    return json.dumps({'success': False, 'error': 'Post not found!'}), 404

@app.route('/api/user/following/<string:person>/')
def following(person):
    global id
    user = User.query.filter_by(netid = id).first()
    if user is not None:
        followed = User.query.filter_by(netid= person).first()
        if followed is not None:
            user.following = user.following + "," + person
            followed.followers = followed.followers + "," + id
        return json.dumps(user.serialize()), 200
    return json.dumps({'success': False, 'error': 'User not found!'}), 404

@app.route('/api/profile/user/')
def get_user_profile():
    global id
    profile = User.query.filter_by(netid = id).first()
    if profile is not None:
        return json.dumps(profile.serialize()), 200
    return json.dumps({'success': False, 'error': 'Profile not found!'}), 404

@app.route('/api/profile/<string:person>/')
def get_profile(person):
    profile = User.query.filter_by(netid = person).first()
    if profile is not None:
        return json.dumps(profile.serialize()), 200
    return json.dumps({'success': False, 'error': 'Profile not found!'}), 404

@app.route('/api/profile/users/')
def get_users():
    users = User.query.all()
    res = [user.serialize() for user in users]
    return json.dumps(res), 200

'''
@app.route('/api/profile/user/image/', methods=['POST'])
def update_profile_pic():
    global id
    user = User.query.filter_by(netid=id).first()
    if user is not None:
        image = request.files.get('image')
        image_url = upload_image_file(image)
        user.image = image_url
        db.session.commit() 
        return json.dumps(user.serialize()), 200
    return json.dumps({'success': False, 'error': 'User not found!'}), 404
'''

@app.route('/api/profile/user/', methods=['POST'])
def update_profile():
    global id
    user = User.query.filter_by(netid=id).first()
    if user is not None:
        image = request.files.get('image')
        if image is not None:
            image_url = upload_image_file(image)
        else:
            image_url = temp_image

        display_name = request.form.get('display_name')
        year = request.form.get('year')
        college = request.form.get('college')
        major = request.form.get('major')

        if display_name != "":
            user.display_name = display_name
        if year != "":
            user.year = year
        if college  != "":
            user.college = college
        if major != "":
            user.major = major
        db.session.commit()
        return json.dumps(user.serialize()), 200
    return json.dumps({'success': False, 'error': 'User not found!'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)