# Import module
import sqlite3

curr_user = "ansley"


def start_app():
    global conn, cursor
    conn = sqlite3.connect("test.sqlite")
    cursor = conn.cursor()

    # cursor.execute("DROP TABLE IF EXISTS games")

    # ensure tables are created
    users_table = """CREATE TABLE IF NOT EXISTS users(username TEXT UNIQUE NOT NULL, password TEXT NOT NULL, primary key (username));"""
    games_table = """CREATE TABLE IF NOT EXISTS games(GAMEID INTEGER, user TEXT NOT NULL, date DATETIME DEFAULT CURRENT_DATE, title TEXT, notes TEXT, uci TEXT, primary key (GAMEID), FOREIGN KEY (user) REFERENCES users(username));"""

    cursor.execute(users_table)
    cursor.execute(games_table)


def close_app():
    conn.commit()
    conn.close()


def pause_game():
    conn.commit()


start_app()


def create_user(username, password):
    cursor.execute(
        f"""INSERT INTO users (username, password) VALUES ('{username}', '{password}')"""
    )


def change_password(username, new_password):
    cursor.execute(
        f"""UPDATE users SET password = '{new_password}' WHERE username = '{username}'"""
    )


# NOTE: this seems unnecessary
def update_user(column, value, ref_col, ref_val):
    cursor.execute(
        f"""UPDATE users SET {column} = '{value}' WHERE {ref_col} = '{ref_val}'"""
    )


def delete_user(username):
    cursor.execute(f"""DELETE FROM users WHERE username = '{username}'""")


# Q: should uci be not null? seems like it should so the replay will work
def create_game(title=None, notes=None, uci=None):
    fixed_title = title if title is not None else "NULL"
    fixed_notes = notes if notes is not None else "NULL"
    fixed_uci = uci if uci is not None else "NULL"

    cursor.execute(
        f"""INSERT INTO games (user, title, notes, uci) VALUES ('{curr_user}', '{fixed_title}', '{fixed_notes}', '{fixed_uci}')"""
    )


def edit_note(gameID, note):
    cursor.execute(f"""UPDATE games SET notes = '{note}' WHERE GAMEID = '{gameID}'""")


def edit_title(gameID, title):
    cursor.execute(f"""UPDATE games SET notes = '{title}' WHERE GAMEID = '{gameID}'""")


def retrieve_games_by_user():
    cursor.execute(f"""SELECT * FROM games WHERE user = '{curr_user}'""")
    rows = cursor.fetchall()
    return rows


def retrieve_games_by_title(title):
    cursor.execute(
        f"""SELECT * FROM games WHERE user = '{curr_user}' AND title = '{title}'"""
    )
    rows = cursor.fetchall()
    return rows


def delete_games_by_user():
    cursor.execute(f"""DELETE FROM games WHERE user = '{curr_user}'""")


def delete_game_by_id(gameID):
    cursor.execute(f"""DELETE FROM games WHERE GAMEID = '{gameID}'""")


def test_insert():
    # Connecting to sqlite
    conn = sqlite3.connect("test.sqlite")

    # Creating a cursor object using the
    # cursor() method
    cursor = conn.cursor()
    cursor.execute("""INSERT INTO STUDENT VALUES ('Please', '7th', 'W')""")

    print("Data Inserted in the table: ")
    data = cursor.execute("""SELECT * FROM STUDENT""")
    for row in data:
        print(row)

    # Closing the connection
    conn.close()


close_app()
