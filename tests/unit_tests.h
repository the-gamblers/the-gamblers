#include <cassert>
#include "../ChessMaster/Client/ChessMaster/db2.hpp"

void test_pass() {
    Database db = Database("test");
    // test();
    assert(0 == 0);
}

void test_fail() {
    assert(1 == 0);
}
