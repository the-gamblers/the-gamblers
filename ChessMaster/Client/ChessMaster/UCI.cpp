#include <iostream>
#include <cstring> // For strcpy and strdup

char* UCI_to_FEN(const char* uci) {
    // Initialize FEN representation with enough space to include castling information
    char fen[] = "8/8/8/8/8/8/8/8 KQkq"; // Initial FEN representation with placeholders for castling info
    int rank = 7; // Starting rank
    int file = 0; // Starting file
    bool castling_white_kingside = true; // Assume white can castle kingside
    bool castling_white_queenside = true; // Assume white can castle queenside
    bool castling_black_kingside = true; // Assume black can castle kingside
    bool castling_black_queenside = true; // Assume black can castle queenside

    const char* ptr = uci;
    while (*ptr != '\0') {
        char c = *ptr;
        if (c == '/') { // Move to the next rank
            rank--;
            file = 0;
        } else if (c >= '0' && c <= '9') { // Skip empty squares
            file += (c - '0');
        } else if (c == 'K') { // White can't castle kingside
            castling_white_kingside = false;
        } else if (c == 'Q') { // White can't castle queenside
            castling_white_queenside = false;
        } else if (c == 'k') { // Black can't castle kingside
            castling_black_kingside = false;
        } else if (c == 'q') { // Black can't castle queenside
            castling_black_queenside = false;
        } else { // Place the piece
            fen[rank * 9 + file] = c;
            file++;
        }
        ptr++;
    }

    // Update the FEN string with castling information
    fen[64] = (castling_white_kingside ? 'K' : '-');
    fen[65] = (castling_white_queenside ? 'Q' : '-');
    fen[66] = (castling_black_kingside ? 'k' : '-');
    fen[67] = (castling_black_queenside ? 'q' : '-');

    // Return a copy of the FEN string to avoid returning a pointer to a local variable
    return strdup(fen);
}

int main() {
    const char* uci = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"; // Example UCI string
    char* fen = UCI_to_FEN(uci); // Convert UCI to FEN
    std::cout << "FEN: " << fen << std::endl; // Output FEN representation
    free(fen); // Free dynamically allocated memory
    return 0;
}
