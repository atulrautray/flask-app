import unittest
from unittest.mock import patch, Mock
import requests


class TestGetRequest(unittest.TestCase):
    @patch("requests.get")
    def test_get_request(self, mock_get):
        # Set up a mock response
        mock_response = requests.Response()
        mock_response.status_code = 200
        mock_response.json = Mock(return_value={"myFavoriteAthlete": "Usain Bolt"})
        mock_get.return_value = mock_response

        # Get the IP address
        ip_address = "192.168.49.2"
        # print(ip_address)

        # Perform the GET request
        url = f"http://{ip_address}/"
        response = requests.get(url)

        # Assert that the request was successful
        self.assertEqual(response.status_code, 200)

        self.assertEqual(response.json(), {"myFavoriteAthlete": "Usain Bolt"})

        # Assert that the mock_get function was called with the correct URL
        mock_get.assert_called_with(f"http://{ip_address}/")

        print("Test passed successfully")


if __name__ == "__main__":
    unittest.main()
