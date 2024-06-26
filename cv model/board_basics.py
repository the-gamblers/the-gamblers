import sys

from skimage.metrics import structural_similarity
import chess
import pickle
import os


class Board_basics:
    def __init__(self, side_view_compensation, rotation_count):
        self.d = [side_view_compensation, (0, 0)]
        self.rotation_count = rotation_count
        self.SSIM_THRESHOLD = 0.8
        self.SSIM_THRESHOLD_LIGHT_WHITE = 1.0
        self.SSIM_THRESHOLD_LIGHT_BLACK = 1.0
        self.SSIM_THRESHOLD_DARK_WHITE = 1.0
        self.SSIM_THRESHOLD_DARK_BLACK = 1.0
        self.ssim_table = [
            [self.SSIM_THRESHOLD_DARK_BLACK, self.SSIM_THRESHOLD_DARK_WHITE],
            [self.SSIM_THRESHOLD_LIGHT_BLACK, self.SSIM_THRESHOLD_LIGHT_WHITE],
        ]
        self.save_file = "ssim.bin"

    def initialize_ssim(self, frame):
        light_white = []
        dark_white = []
        light_empty = []
        dark_empty = []
        light_black = []
        dark_black = []
        for row in range(8):
            for column in range(8):
                square_name = self.convert_row_column_to_square_name(row, column)
                if square_name[1] == "2":
                    if self.is_light(square_name):
                        light_white.append(self.get_square_image(row, column, frame))
                    else:
                        dark_white.append(self.get_square_image(row, column, frame))
                elif square_name[1] == "4":
                    if self.is_light(square_name):
                        light_empty.append(self.get_square_image(row, column, frame))
                    else:
                        dark_empty.append(self.get_square_image(row, column, frame))
                elif square_name[1] == "7":
                    if self.is_light(square_name):
                        light_black.append(self.get_square_image(row, column, frame))
                    else:
                        dark_black.append(self.get_square_image(row, column, frame))
        ssim_light_white = max(
            structural_similarity(empty, piece, channel_axis=-1)
            for piece, empty in zip(light_white, light_empty)
        )
        ssim_light_black = max(
            structural_similarity(empty, piece, channel_axis=-1)
            for piece, empty in zip(light_black, light_empty)
        )
        ssim_dark_white = max(
            structural_similarity(empty, piece, channel_axis=-1)
            for piece, empty in zip(dark_white, dark_empty)
        )
        ssim_dark_black = max(
            structural_similarity(empty, piece, channel_axis=-1)
            for piece, empty in zip(dark_black, dark_empty)
        )
        self.SSIM_THRESHOLD_LIGHT_WHITE = min(
            self.SSIM_THRESHOLD_LIGHT_WHITE, ssim_light_white + 0.2
        )
        self.SSIM_THRESHOLD_LIGHT_BLACK = min(
            self.SSIM_THRESHOLD_LIGHT_BLACK, ssim_light_black + 0.2
        )
        self.SSIM_THRESHOLD_DARK_WHITE = min(
            self.SSIM_THRESHOLD_DARK_WHITE, ssim_dark_white + 0.2
        )
        self.SSIM_THRESHOLD_DARK_BLACK = min(
            self.SSIM_THRESHOLD_DARK_BLACK, ssim_dark_black + 0.2
        )
        self.SSIM_THRESHOLD = max(
            [
                self.SSIM_THRESHOLD,
                self.SSIM_THRESHOLD_LIGHT_WHITE,
                self.SSIM_THRESHOLD_LIGHT_BLACK,
                self.SSIM_THRESHOLD_DARK_WHITE,
                self.SSIM_THRESHOLD_DARK_BLACK,
            ]
        )
        self.ssim_table = [
            [self.SSIM_THRESHOLD_DARK_BLACK, self.SSIM_THRESHOLD_DARK_WHITE],
            [self.SSIM_THRESHOLD_LIGHT_BLACK, self.SSIM_THRESHOLD_LIGHT_WHITE],
        ]

        outfile = open(self.save_file, "wb")
        pickle.dump(
            (
                self.SSIM_THRESHOLD_LIGHT_WHITE,
                self.SSIM_THRESHOLD_LIGHT_BLACK,
                self.SSIM_THRESHOLD_DARK_WHITE,
                self.SSIM_THRESHOLD_DARK_BLACK,
                self.SSIM_THRESHOLD,
            ),
            outfile,
        )
        outfile.close()

    def load_ssim(self):
        if os.path.exists(self.save_file):
            infile = open(self.save_file, "rb")
            (
                self.SSIM_THRESHOLD_LIGHT_WHITE,
                self.SSIM_THRESHOLD_LIGHT_BLACK,
                self.SSIM_THRESHOLD_DARK_WHITE,
                self.SSIM_THRESHOLD_DARK_BLACK,
                self.SSIM_THRESHOLD,
            ) = pickle.load(infile)
            infile.close()
            self.ssim_table = [
                [self.SSIM_THRESHOLD_DARK_BLACK, self.SSIM_THRESHOLD_DARK_WHITE],
                [self.SSIM_THRESHOLD_LIGHT_BLACK, self.SSIM_THRESHOLD_LIGHT_WHITE],
            ]
        else:
            print(
                "You need to play at least 1 game before starting a game from position."
            )
            sys.exit(0)

    def update_ssim(self, previous_frame, next_frame, move, is_capture, color):
        from_square = chess.square_name(move.from_square)
        to_square = chess.square_name(move.to_square)
        for row in range(8):
            for column in range(8):
                square_name = self.convert_row_column_to_square_name(row, column)
                if square_name not in [from_square, to_square]:
                    continue
                previous_square = self.get_square_image(row, column, previous_frame)
                next_square = self.get_square_image(row, column, next_frame)
                ssim = structural_similarity(
                    next_square, previous_square, channel_axis=-1
                )
                ssim = ssim + 0.1
                if ssim > self.SSIM_THRESHOLD:
                    self.SSIM_THRESHOLD = ssim
                is_light = int(self.is_light(square_name))
                if (square_name == from_square) or (not is_capture):
                    if ssim > self.ssim_table[is_light][color]:
                        self.ssim_table[is_light][color] = ssim

    def get_square_image(self, row, column, board_img):
        height, width = board_img.shape[:2]
        minX = int(column * width / 8)
        maxX = int((column + 1) * width / 8)
        minY = int(row * height / 8)
        maxY = int((row + 1) * height / 8)
        square = board_img[minY:maxY, minX:maxX]
        return square

    def convert_row_column_to_square_name(self, row, column):
        if self.rotation_count == 0:
            number = repr(8 - row)
            letter = str(chr(97 + column))
        elif self.rotation_count == 1:
            number = repr(8 - column)
            letter = str(chr(97 + (7 - row)))
        elif self.rotation_count == 2:
            number = repr(row + 1)
            letter = str(chr(97 + (7 - column)))
        elif self.rotation_count == 3:
            number = repr(column + 1)
            letter = str(chr(97 + row))
        return letter + number

    def square_region(self, row, column):
        region = set()
        for d_row, d_column in self.d:
            n_row = row + d_row
            n_column = column + d_column
            if not (0 <= n_row < 8):
                continue
            if not (0 <= n_column < 8):
                continue
            region.add((n_row, column))
        return region

    def is_light(self, square_name):
        if square_name[0] in "aceg":
            if square_name[1] in "1357":
                return False
            else:
                return True
        else:
            if square_name[1] in "1357":
                return True
            else:
                return False

    def get_potential_moves(self, fgmask, previous_frame, next_frame, chessboard):
        board = [
            [self.get_square_image(row, column, fgmask).mean() for column in range(8)]
            for row in range(8)
        ]
        previous_board = [
            [self.get_square_image(row, column, previous_frame) for column in range(8)]
            for row in range(8)
        ]
        next_board = [
            [self.get_square_image(row, column, next_frame) for column in range(8)]
            for row in range(8)
        ]
        potential_squares = []
        for row in range(8):
            for column in range(8):
                score = board[row][column]
                if score < 10.0:
                    continue

                ssim = structural_similarity(
                    next_board[row][column],
                    previous_board[row][column],
                    channel_axis=-1,
                )
                square_name = self.convert_row_column_to_square_name(row, column)
                if ssim > self.SSIM_THRESHOLD:
                    continue
                square = chess.parse_square(square_name)
                piece = chessboard.piece_at(square)
                if piece and piece.color == chessboard.turn:
                    is_light = int(self.is_light(square_name))
                    color = int(piece.color)
                    if ssim > self.ssim_table[is_light][color]:
                        continue
                potential_squares.append((score, row, column, ssim))

        potential_squares.sort(reverse=True)
        potential_squares_castling = []
        for i in range(min(6, len(potential_squares))):
            score, row, column, ssim = potential_squares[i]
            potential_square = (
                score,
                self.convert_row_column_to_square_name(row, column),
            )
            potential_squares_castling.append(potential_square)
        potential_squares = potential_squares[:4]
        potential_moves = []

        for (
            start_square_score,
            start_row,
            start_column,
            start_ssim,
        ) in potential_squares:
            start_square_name = self.convert_row_column_to_square_name(
                start_row, start_column
            )
            start_square = chess.parse_square(start_square_name)
            start_piece = chessboard.piece_at(start_square)
            if start_piece:
                if start_piece.color != chessboard.turn:
                    continue
            else:
                continue
            start_region = self.square_region(start_row, start_column)
            for (
                arrival_square_score,
                arrival_row,
                arrival_column,
                arrival_ssim,
            ) in potential_squares:
                # if the frame's didn't change, continue
                if (start_row, start_column) == (arrival_row, arrival_column):
                    continue
                # get the UCI of the arrival square
                arrival_square_name = self.convert_row_column_to_square_name(
                    arrival_row, arrival_column
                )

                arrival_square = chess.parse_square(arrival_square_name)
                arrival_piece = chessboard.piece_at(arrival_square)
                if arrival_piece:
                    if arrival_piece.color == chessboard.turn:
                        continue
                else:
                    is_light = int(self.is_light(arrival_square_name))
                    color = int(start_piece.color)
                    if arrival_ssim > self.ssim_table[is_light][color]:
                        continue
                arrival_region = self.square_region(arrival_row, arrival_column)
                region = start_region.union(arrival_region)
                total_square_score = (
                    sum(board[row][column] for row, column in region)
                    + start_square_score
                    + arrival_square_score
                )
                potential_moves.append(
                    (total_square_score, start_square_name, arrival_square_name)
                )
        # the top part of this is going to be the highest score of potential moves [what we want]
        potential_moves.sort(reverse=True)

        return potential_squares_castling, potential_moves
