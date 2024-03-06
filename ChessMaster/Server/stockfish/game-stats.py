from stockfish import Stockfish

DEPTH = 16

stockfish = Stockfish(depth=DEPTH)

# def create_game():


def analyze_move(move: str) -> dict:
    ret = {}

    if stockfish.is_move_correct(move):
        stockfish.set_position([move])
        print(stockfish.get_board_visual())
        ret["best move"] = stockfish.get_best_move()
        ret["wdl"] = stockfish.get_wdl_stats()
        ret["eval"] = stockfish.get_evaluation()
        # ret["perft"] = stockfish.get_perft(3)
        # ret["capture"] = stockfish.will_move_be_a_capture(move)
    else:
        return {"Error": "Invalid move"}

    return ret


first_move = analyze_move("e2e4")
print(first_move)
stockfish.flip()
print(analyze_move(first_move["best move"]))
