import flask
import json
import geopy
import geopy.distance
import datetime
from flask import Flask
from flask import request
from DB import Database
from uuid import uuid4

app = Flask(__name__)
DB = None
pagesize = 50


class User:
    id = ''
    phone = ''
    uid = ''

    def __init__(self, phone, uid=None):
        self.phone = phone
        if uid is None:
            self.uid = str(uuid4())
        else:
            self.uid = uid

    @staticmethod
    def from_row(row):
        result = User(row[0][1], row[0][2])
        result.id = row[0][0]
        return result


class Contact:
    userid = 0
    friendid = 0
    name = ''

    def __init__(self, userid, friendid, name):
        self.userid = userid
        self.friendid = friendid
        self.name = name

    def to_dict(self):
        result = dict()
        result['userid'] = self.userid
        result['friendid'] = self.friendid
        result['name'] = self.name
        return result


class Countdown:
    id = 0
    key = ''
    datetime = 0
    name = ''
    author = None
    subscribed = 0
    lat = None
    long = None

    @staticmethod
    def generate_key():
        return str(uuid4())

    def __init__(self, name, datetime, author, lat=None, long=None, key=None):
        self.name = name
        self.datetime = datetime
        self.author = author
        self.lat = lat
        self.long = long
        if key is None:
            self.key = self.generate_key()
        else:
            self.key = key

    def to_dict(self):
        result = dict()
        result['id'] = self.id
        result['datetime'] = self.datetime
        result['name'] = self.name
        result['key'] = self.key
        result['authorid'] = self.author.id
        result['subscribed'] = self.subscribed
        result['lat'] = self.lat
        result['long'] = self.long
        return result

def Auth():
    sign = request.headers.get('UID')
    author_row = DB.get_user_by_uid(sign)
    if len(author_row) == 0:
        return None

    return User.from_row(author_row)

@app.route('/users', methods=['POST'])
def add_user():
    js = request.json
    user = User(js.get('phone'))

    exist = DB.get_user_by_phone(user.phone)

    if len(exist) == 0:
        iid = DB.create_user(user)
        user.id == iid
    else:
        user = User.from_row(exist)
    resp = flask.Response(json.dumps(user.__dict__))
    resp.headers["content-type"] = "application/json"
    return resp


@app.route('/countdowns', methods=['POST'])
def add_countdown():

    author = Auth()
    if author is None:
        return flask.Response(status=401)

    if 'id' in request.json:
        cdid = request.json.get('id')
    else:
        js = request.json

        dt = int(js.get('datetime'))
        now = int(datetime.datetime.utcnow().timestamp())
        if dt < now:
            return flask.Response(status=400)

        cd = Countdown(js.get('name'), js.get('datetime'), author)
        cdid = DB.create_countdown(cd)
        if 'lat' in js and 'long' in js:
            DB.set_countdown_location(cdid, js.get('lat'), js.get('long'))

    cd = DB.get_countdown_by_id(cdid)
    DB.subscribe(author.id, cdid)
    result = dict()
    result['id'] = cd[0][0]
    result['datetime'] = cd[0][1]
    result['name'] = cd[0][2]
    result['key'] = cd[0][3]
    result['authorid'] = cd[0][4]
    result['lat'] = cd[0][6]
    result['long'] = cd[0][7]
    result['subscribed'] = cd[0][8]

    response = flask.Response(json.dumps(result))
    response.headers["content-type"] = "application/json"
    return response


@app.route('/countdowns/<int:countdownid>', methods=['DELETE'])
def delete_countdown(countdownid):
    author = Auth()
    if author is None:
        return flask.Response(status=401)

    DB.unsubscribe(author.id, countdownid)
    resp = flask.Response('{}')
    resp.headers["content-type"] = "application/json"
    return resp


@app.route('/user/countdowns', methods=['GET'])
def get_users_countdowns():

    author = Auth()
    if author is None:
        return flask.Response(status=401)

    result = DB.get_users_countdowns(author.id)
    result = [x for x in result if int(x[1]) > int(datetime.datetime.now().timestamp())]
    page = int(request.args.get('page', 0))

    array = []
    for cntdn in result[pagesize * page:pagesize*(page+1)]:
        add = dict()
        add['id'] = cntdn[0]
        add['datetime'] = cntdn[1]
        add['name'] = cntdn[2]
        add['key'] = cntdn[3]
        add['authorid'] = cntdn[4]
        add['lat'] = cntdn[6]
        add['long'] = cntdn[7]
        add['subscribed'] = cntdn[8]
        array.append(add)

    response = flask.Response(json.dumps(array))
    response.headers["content-type"] = "application/json"
    return response


@app.route('/countdowns', methods=['GET'])
def get_all_countdowns():

    filter = request.args.get('filter', 'unspecified')

    author = Auth()
    if author is None:
        result = DB.get_all_countdowns()
    else:
        if filter == 'friends':
            result = DB.get_all_friends_countdowns(author.id)
        else:
            result = DB.get_all_countdowns()

        xcpt = DB.get_users_countdowns(author.id)
        result = [x for x in result if x[0] is not None and x[0] not in [y[0] for y in xcpt]]

    result = [x for x in result if int(x[1]) > int(datetime.datetime.now().timestamp())]

    if filter == 'popular':
        result = sorted(result, key=lambda tup: tup[8], reverse=True)
    elif filter == 'nearby':
        if 'lat' not in request.args or 'long' not in request.args:
            return flask.Response(status=400)
        lat = request.args.get('lat')
        long = request.args.get('long')
        p = geopy.Point(lat, long)
        result = [x for x in result if (x[6] is not None) and (x[7] is not None)]
        result = sorted(result, key=lambda c: geopy.distance.distance(p, geopy.Point(c[6], c[7])).km)

    if 'search' in request.args:
        srch = request.args.get('search')
        result = [x for x in result if srch in x[2]]

    page = int(request.args.get('page', 0))
    array = []
    for cntdn in result[pagesize * page:pagesize*(page+1)]:
        add = dict()
        add['id'] = cntdn[0]
        add['datetime'] = cntdn[1]
        add['name'] = cntdn[2]
        add['key'] = cntdn[3]
        add['authorid'] = cntdn[4]
        add['lat'] = cntdn[6]
        add['long'] = cntdn[7]
        add['subscribed'] = cntdn[8]
        array.append(add)

    response = flask.Response(json.dumps(array))
    response.headers["content-type"] = "application/json"
    return response


@app.route('/contacts', methods=['POST'])
def post_all_user_contacts():

    author = Auth()
    if author is None:
        return flask.Response(status=401)

    result = []
    for con_js in request.json:

        usr_r = DB.get_user_by_phone(con_js.get('phone'))
        if len(usr_r) == 0:
            usr = User(con_js.get('phone'))
            DB.create_user(usr)
            usr = User.from_row(DB.get_user_by_phone(usr.phone))
        else:
            usr = User.from_row(usr_r)

        contact = Contact(author.id, usr.id, con_js.get('name'))
        DB.create_contact(contact)
        result.append(contact.to_dict())

    response = flask.Response(json.dumps(result))
    response.headers["content-type"] = "application/json"
    return response


@app.route('/contacts/<string:phone>', methods=['DELETE'])
def delete_contact(phone):
    author = Auth()
    if author is None:
        return flask.Response(status=401)

    usr_r = DB.get_user_by_phone(phone)
    if len(usr_r) == 0:
        return flask.Response(status=404)

    usr = User.from_row(usr_r)

    DB.delete_friendship(author.id, usr.id)
    response = flask.Response('{}')
    response.headers["content-type"] = "application/json"
    return response


@app.route('/related', methods=['GET'])
def get_related_countdowns():
    if 'name' not in request.args:
        return flask.Response(status=400)

    name = request.args.get('name')
    if 'datetime' not in request.args:
        result = DB.get_only_name_related(name)
    else:
        result = DB.get_name_and_datetime_related(name, int(request.args.get('datetime')))
    array = []
    for cntdn in result[0:2]:
        add = dict()
        add['id'] = cntdn[0]
        add['datetime'] = cntdn[1]
        add['name'] = cntdn[2]
        add['key'] = cntdn[3]
        add['authorid'] = cntdn[4]
        add['lat'] = cntdn[6]
        add['long'] = cntdn[7]
        add['subscribed'] = cntdn[8]
        array.append(add)

    response = flask.Response(json.dumps(array))
    response.headers["content-type"] = "application/json"
    return response


@app.route('/')
def hi():
    return "Это API, долбоёб!"


if __name__ == '__main__':
    DB = Database()
    app.run(host='10.10.40.12')