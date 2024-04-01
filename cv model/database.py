import sqlite3

# from stockfish import Stockfish

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
    cursor.execute(
        "INSERT INTO games (user, title, uci, fens) VALUES ('ansley', 'ansley4', '', '')"
    )
    cursor.execute("SELECT GAMEID FROM games WHERE fens = '' AND uci = ''")

    conn.commit()
    global gameid
    gameid = cursor.fetchone()[0]


# gameid = get_game()
# print(gameid)


def write_fen(fen):
    cursor.execute(
        "UPDATE games SET fens = '" + fen + "' WHERE GAMEID = " + str(gameid)
    )
    conn.commit()


def write_uci(uci):
    cursor.execute("UPDATE games SET uci = '" + uci + "' WHERE GAMEID = " + str(gameid))
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
