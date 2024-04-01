import sqlite3

conn = sqlite3.connect("../ChessMaster/Client/ChessMaster/test.sqlite")
cursor = conn.cursor()

gameid = -1


def start_game():
    conn = sqlite3.connect("../ChessMaster/Client/ChessMaster/test.sqlite")
    cursor = conn.cursor()


def end_game():
    cursor.close()
    conn.close()


def get_game():
    cursor.execute("SELECT GAMEID FROM games WHERE fens = '' AND uci = ''")

    conn.commit()
    return cursor.fetchone()[0]


gameid = get_game()
print(gameid)


def write_fen(fen):
    cursor.execute(
        "UPDATE games SET fens = '" + fen + "' WHERE GAMEID = " + str(gameid)
    )
    conn.commit()


def write_uci(uci):
    cursor.execute("UPDATE games SET uci = '" + uci + "' WHERE GAMEID = " + str(gameid))
    conn.commit()
