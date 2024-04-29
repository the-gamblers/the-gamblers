import sqlite3
import datetime


conn = sqlite3.connect("../ChessMaster/Client/ChessMaster/prod.sqlite")
cursor = conn.cursor()
gameid = -1


def end_game():
    cursor.close()
    conn.close()


def get_game():
    cursor.execute("SELECT GAMEID FROM games WHERE uci = '' AND fens = ''")
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


def delete_swift_game():
    cursor.execute("DELETE FROM games where uci = ''")
    conn.commit()

def get_GameID_From_Fen(fen):
    cursor.execute("SELECT GAMEID FROM games where fens = '"+str(fen)+"'")
    conn.commit()
    return cursor.fetchone()[0]

def get_GameID_From_UCI(uci):
    cursor.execute("SELECT GAMEID FROM games where uci = '"+str(uci)+"'")
    conn.commit()
    return cursor.fetchone()[0]

def get_GameID_From_Time(time):
    cursor.execute("SELECT GAMEID FROM games where time = '"+str(time)+"'")
    conn.commit()
    return cursor.fetchone()[0]
