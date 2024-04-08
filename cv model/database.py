import sqlite3
import datetime


conn = sqlite3.connect("../ChessMaster/Client/ChessMaster/test.sqlite")
cursor = conn.cursor()
gameid = -1


def end_game():
    cursor.close()
    conn.close()


def get_game():
    cursor.execute("SELECT GAMEID FROM games WHERE fens = '' AND uci = ''")

    conn.commit()
    global gameid
    gameid = cursor.fetchone()[0]


def write_fen(fen):
    cursor.execute(
        "UPDATE games SET fens = '" + fen + "' WHERE GAMEID = " + str(gameid)
    )
    conn.commit()


def write_uci(uci):
    cursor.execute("UPDATE games SET uci = '" + uci + "' WHERE GAMEID = " + str(gameid))
    conn.commit()


def write_time(start, end):
    totalTime = end - start
    elapsed_time = datetime.timedelta(seconds=totalTime)

    cursor.execute(
        "UPDATE games SET time = '"
        + str(elapsed_time)
        + "' WHERE GAMEID = "
        + str(gameid)
    )
    conn.commit()
