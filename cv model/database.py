import sqlite3
import datetime
import time

# from stockfish import Stockfish

conn = sqlite3.connect("../ChessMaster/Client/ChessMaster/test.sqlite")
cursor = conn.cursor()

# cursor.execute("DELETE FROM games;")
# conn.commit()

gameid = -1

# cursor.execute("DELETE FROM games;")
# conn.commit()


def end_game():
    cursor.close()
    conn.close()


cursor.execute("DELETE FROM games;")
conn.commit()


def get_game():
    cursor.execute(
        "INSERT INTO games (user, title, uci, fens) VALUES ('ansley', 'ansley10ABCs', '', '')"
    )
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
    print("writing to db: " + uci)
    cursor.execute("UPDATE games SET uci = '" + uci + "' WHERE GAMEID = " + str(gameid))
    conn.commit()


def write_time(start, end):
    totalTime = end - start
    elapsed_time = time.strftime("%H:%M:%S", totalTime)

    cursor.execute(
        "UPDATE games SET time = '" + elapsed_time + "' WHERE GAMEID = " + str(gameid)
    )
    print("wrote to database")
    conn.commit()


# need to figure out python constructor
# def get_best_move(fen):
#     stockfish = Stockfish()
#     stockfish.set_fen_position(fen)
#     return stockfish.get_best_move()


# print(
#     get_best_move("r1b1kbnr/p1pp1ppp/1pn5/4p1B1/4P3/3P1Q2/PPP2PPP/RN2KBNR w KQkq - 0 5")
# )


# def write_best_move(moves):
#     cursor.execute(
#         "UPDATE games SET best_move = '" + moves + "' WHERE GAMEID = " + str(gameid)
#     )
#     conn.commit()
