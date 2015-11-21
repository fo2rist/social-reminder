import sqlite3
import os
from uuid import uuid4


class Database:
    file_path = os.path.dirname(os.path.abspath(__file__)) + '/test.db'
    file_path = file_path.replace('\\', '/')
    connection = None

    def __init__(self):
        if not os.path.exists(self.file_path):
            open(self.file_path, 'a').close()
            self.connection = sqlite3.connect(self.file_path)
            cursor = self.connection.cursor()
            cursor.execute(
                'CREATE TABLE [User](id INTEGER PRIMARY KEY AUTOINCREMENT, phone text, uid text)')
            cursor.execute('insert into [User](phone, uid) values(\'123123\', \'00000000-0000-0000-0000-000000000000\')')
            cursor.execute('CREATE TABLE [Friend](userid INTEGER, friendid INTEGER, friend_name text)')
            cursor.execute(
                'CREATE TABLE [Countdown](id INTEGER PRIMARY KEY AUTOINCREMENT, datetime integer, name text, key text, authorid integer, hasLoc , lat real, long real)')
            cursor.execute('CREATE TABLE [Subscription](userid integer, countdownid integer)')
            self.connection.commit()
        else:
            self.connection = sqlite3.connect(self.file_path)

    def exec(self, request):
        cur = self.connection.cursor()
        cur.execute(request)
        result = cur.lastrowid
        self.connection.commit()
        return result

    def get_user_by_phone(self, phone):
        request = 'select id, phone, uid from [User] where phone=\'{0}\''.format(phone)
        cursor = self.connection.cursor()
        cursor.execute(request)
        result = cursor.fetchall()
        return result

    def get_user_by_uid(self, uid):
        request = 'select id, phone, uid from [User] where uid=\'{0}\''.format(uid)
        cursor = self.connection.cursor()
        cursor.execute(request)
        result = cursor.fetchall()
        return result

    def create_user(self, user):
        request = 'insert into [User](phone, uid) values (\'{0}\', \'{1}\')'.format(user.phone, user.uid)
        self.exec(request)

    def create_countdown(self, countdown):
        request = 'insert into [Countdown](datetime, name, key, authorid) values(\'{0}\', \'{1}\', \'{2}\', \'{3}\')'
        request = request.format(countdown.datetime, countdown.name, countdown.key, countdown.author.id)
        return self.exec(request)

    def set_countdown_location(self, id, lat, long):
        request = 'update [Countdown] set lat={0}, long={1} where id={2}'.format(lat, long, id)
        self.exec(request)

    def get_all_countdowns(self):
        request = "select c.*, count(s.userid) from [Countdown] as c left join [Subscription] as s on c.id = s.countdownid group by c.id, c.name, c.datetime, c.key, c.authorid"
        cursor = self.connection.cursor()
        cursor.execute(request)
        return cursor.fetchall()

    def get_all_friends_countdowns(self, userid):
        request = "select c.*, count(sp.userid) from [Friend] as f left join [Countdown] as c on c.authorid = f.friendid left join Subscription as sp on sp.countdownid = c.id where f.userid = {0} group by c.id, c.name, c.datetime, c.key, c.authorid".format(userid)
        cursor = self.connection.cursor()
        cursor.execute(request)
        return cursor.fetchall()

    def get_countdown_by_id(self, id):
        request = 'select c.*, count(s.userid) from [Countdown] as c left join [Subscription] as s on c.id = s.countdownid where id=' + str(id) + ' group by c.id, c.name, c.datetime, c.key, c.authorid'
        cursor = self.connection.cursor()
        cursor.execute(request)
        return cursor.fetchall()

    def get_users_countdowns(self, userid):
        request = 'select c.*, count(sp.userid) from [Subscription] as s inner join [Countdown] as c on s.countdownid = c.id left join [Subscription] as sp on sp.countdownid = c.id where s.userid={0} group by c.id, c.name, c.datetime, c.key, c.authorid'.format(
            str(userid))
        cursor = self.connection.cursor()
        cursor.execute(request)
        return cursor.fetchall()

    def create_contact(self, contact):
        request = 'insert into [Friend](userid, friendid, friend_name) values(\'{0}\', \'{1}\', \'{2}\')'
        request = request.format(contact.userid, contact.friendid, contact.name)
        self.exec(request)

    def delete_friendship(self, userid, friendid):
        request = 'delete from [Friend] where userid = \'{0}\' and friendid = \'{1}\''
        request = request.format(userid, friendid)
        self.exec(request)

    def subscribe(self, userid, countdownid):

        cur = self.connection.cursor()
        cur.execute('select 1 from [Subscription] where userid={0} and countdownid={1}'.format(userid, countdownid))
        if len(cur.fetchall()) != 0:
            return

        request = 'insert into [Subscription](userid, countdownid) values(\'{0}\', \'{1}\')'
        request = request.format(userid, countdownid)
        self.exec(request)

    def unsubscribe(self, userid, countdownid):
        request = 'delete from [Subscription] where userid=\'{0}\' and countdownid =  \'{1}\''
        request = request.format(userid, countdownid)
        self.exec(request)

    def get_only_name_related(self, name):
        request = 'select c.*, count(sp.userid) from [Countdown] as c left join [Subscription] as sp on sp.countdownid = c.id where editdist3(c.name. \'{0}\') < 3 group by c.id, c.name, c.datetime, c.key, c.authorid'
        request = request.format(name)
        cursor = self.connection.cursor()
        cursor.execute(request)

    def get_name_and_datetime_related(self, name, datetime):
        request = 'select c.*, count(sp.userid) from [Countdown] as c left join [Subscription] as sp on sp.countdownid = c.id where editdist3(c.name. \'{0}\') < length(c.name) and abs(c.datetime - {1}) <= 300 group by c.id, c.name, c.datetime, c.key, c.authorid'
        request = request.format(name)
        cursor = self.connection.cursor()
        cursor.execute(request)