from flask import Flask, request

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    if request.method == "GET":
        return {"myFavoriteAthlete": "Usain Bolt"}, 200
    else:
        return "Only GET method valid", 400


if __name__ == "__main__":
    app.run(
        host="0.0.0.0"
    )  # run the app on host IP address "0.0.0.0", which means it will be accessible from any IP address on the network
