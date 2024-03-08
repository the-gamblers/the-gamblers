from stockfish import Stockfish

stockfish = Stockfish()

def return_board():
    game = Stockfish()
    game.startEngine()
    board = game.get_board_visual()
    return board

return_board()