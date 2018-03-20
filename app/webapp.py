#!/usr/bin/env python

from flask import Flask
import os

version = os.getenv("APP_VERSION")
app = Flask(__name__)


@app.route("/")
def home():
    return "version: %s" % version


if __name__ == "__main__":
    app.run(host="0.0.0.0", threaded=True)
