import unittest
import database as db

class TestDatabaseMethods(unittest.TestCase):
    def testEndGame(self):
        print("---------------------------")
        print("This is what this gives you: ", db.get_game())
        print("This is the first output: ", db.conn.close())
        print("---------------------------")
        return
    def testGetGame(self):
        return
    def testWriteFen(self):
        return
    def testWriteUCI(self):
        return
    def testWriteTime(self):
        return
    
if __name__ == '__main__':
    unittest.main()


