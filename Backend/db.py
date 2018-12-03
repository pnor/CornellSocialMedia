from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    netid = db.Column(db.String, nullable=False)
    display_name = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)
    image = db.Column(db.String, nullable=False)
    year = db.Column(db.Integer, nullable=False)
    college = db.Column(db.String, nullable=True)
    major = db.Column(db.String, nullable=True)
    followers = db.Column(db.String, nullable=False)
    following = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.netid = kwargs.get('netid','')
        self.display_name = kwargs.get('display_name','')
        self.username = kwargs.get('username','')
        self.password = kwargs.get('password','')
        self.image = kwargs.get('image','')
        self.year = kwargs.get('year','')
        self.college = kwargs.get('college','')
        self.major = kwargs.get('major','')
        self.followers = ""
        self.following = ""
    
    def serialize(self):
        return {
            'id': self.id,
            'netid': self.netid,
            'display_name': self.display_name,
            'username': self.username,
            'password': self.password,
            'image': self.image,
            'year': self.year,
            'college': self.college,
            'major': self.major,
            'followers': self.followers,
            'following': self.following
        }


class Post(db.Model):
    __tablename__ = 'post'
    id = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Integer, nullable=False)
    text = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    image = db.Column(db.String, nullable=True)
    comments = db.relationship('Comment', cascade='delete')

    def __init__(self, **kwargs):
        self.score = 0
        self.text = kwargs.get('text', '')
        self.netid = kwargs.get('netid', '')
        self.image = kwargs.get('image', '')
    
    def serialize(self):
        return {
            'id': self.id,
            'score': self.score,
            'text': self.text,
            'netid': self.netid,
            'image': self.image
        }

class Comment(db.Model):
    __tablename__ = 'comment'
    id = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Integer, nullable=False)
    text = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'), nullable=False)

    def __init__(self, **kwargs):
        self.score = 0
        self.text = kwargs.get('text', '')
        self.netid = kwargs.get('netid', '')
        self.post_id = kwargs.get('post_id')
    
    def serialize(self):
        return {
            'id': self.id,
            'score': self.score,
            'text': self.text,
            'netid': self.netid
        }