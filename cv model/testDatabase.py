import unittest
import database as db
import datetime

class TestDatabaseMethods(unittest.TestCase):
    def testGetGame(self):
        db.get_game()
        self.assertEqual(db.gameid, 1)
    def testWriteFen(self):
        fen = "N7/PpP5/1K4N1/PQ5n/2p2Pk1/1p3p2/3r1B2/8 w - - 0 1"
        db.get_game()
        db.write_fen(fen)
        self.assertEqual(db.get_GameID_From_Fen(fen), 1)
    def testWriteUCI(self):
        uci = "c2c4e7e5b1c3g8f6"
        db.get_game()
        db.write_uci(uci)
        self.assertEqual(db.get_GameID_From_UCI(uci), 1)
    def testWriteTime(self):
        totalTime = 500 - 10
        elapsed_time = datetime.timedelta(seconds=totalTime)
        db.get_game()
        db.write_time(10, 500)
        self.assertEqual(db.get_GameID_From_Time(elapsed_time), 1)

    
if __name__ == '__main__':
    unittest.main()


