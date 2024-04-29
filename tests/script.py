import sqlite3
import datetime

conn = sqlite3.connect("db.sqlite")
cursor = conn.cursor()


cursor.execute("DELETE FROM users WHERE username != 'aiersntmasneritm'")
cursor.execute("DELETE FROM games WHERE user != 'aiersntmasnerim'")

# cursor.execute("INSERT INTO users (username, password) VALUES ('check_user_pass', 'CheckUserPass')")

# cursor.execute("INSERT INTO users (username, password) VALUES ('check_user_fail', 'fail')")

# cursor.execute("INSERT INTO users (username, password) VALUES ('change_password_pass', 'ChangePasswordPass')")

# cursor.execute("INSERT INTO users (username, password) VALUES ('delete_user_pass', 'DeleteUserPass')")
# cursor.execute("INSERT INTO games (user, title, notes, uci, fens) VALUES ('delete_user_pass', 'unit_test', 'unit_test', 'e2e4', 'fen')")

conn.commit()
