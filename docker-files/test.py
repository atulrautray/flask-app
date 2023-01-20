import unittest
from unittest.mock import MagicMock
from flask import Flask, request
from app import home

app = Flask(__name__)


class TestHome(unittest.TestCase):
    def test_home(self):
        with app.test_request_context():
            request.method = "GET"
            response = home()
            self.assertEqual(response[0], {"myFavoriteAthlete": "Usain Bolt"})
            self.assertEqual(response[1], 200)

    def test_home_invalid_method(self):
        with app.test_request_context():
            request.method = "POST"
            response = home()
            self.assertEqual(response[0], "Only GET method valid")
            self.assertEqual(response[1], 400)


if __name__ == "__main__":
    unittest.main()
