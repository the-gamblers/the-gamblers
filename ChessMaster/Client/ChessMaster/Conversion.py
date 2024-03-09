import chess

def uci_to_fen(uci_moves):
    board = chess.Board()
    for move in uci_moves:
        board.push_uci(move)
    return board.fen()

# Example usage:
uci_moves = ["e2e4", "e7e5", "g1f3", "b8c6", "f1c4", "g8f6", "d2d3", "d7d6"]
fen = uci_to_fen(uci_moves)
print("FEN after moves:", fen)
