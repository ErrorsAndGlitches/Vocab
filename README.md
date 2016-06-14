# Introduction

This package provides tools to manage a vocabulary database. It integrates with Anki and the Amazon Kindle to manage
vocabulary words. The data is backed by an Aurora RDS database hosted on AWS.

Travis CI: [![Build Status](https://travis-ci.org/MusicalNeutrino/Vocab.svg?branch=master)](https://travis-ci.org/MusicalNeutrino/Vocab)

# Command Line Options

|:------:|:------------:|----------------------------------------------------------------------------------------------|
| option | argument     | description                                                                                  |
|:------:|:------------:|----------------------------------------------------------------------------------------------|
|   -h   | -            | Show the help options.                                                                       |
|   -c   | mysql.config | MySQL configuration for the vocabulary database.                                             |
|   -a   | api key      | Merriam Webster API key for accessing Dictionary API endpoint.                               |
|   -j   | api_key.json | File containing the Merriam Webster API key for accessing Dictionary API endpoint.           |
|:------:|:------------:|----------------------------------------------------------------------------------------------|
|   -i   | input.txt    | Input text file or Kindle EReader SQLite3 DB containing vocab words to upload.               |
|   -l   | input delim  | The field delimiter for the input text file. Default delimiter: "#"                          |
|   -o   | output.txt   | Output file for Anki ingestion (colon separated).                                            |
|   -u   | -            | Allow updating the MySQL database, otherwise the vocabulary word is ignored.                 |
|   -d   | -            | Clear the MySQL database.                                                                    |
|:------:|:------------:|----------------------------------------------------------------------------------------------|
