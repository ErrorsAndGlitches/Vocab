# Introduction

This package provides tools to manage a vocabulary database. It integrates with Anki and the Amazon Kindle to manage
vocabulary words. The data is backed by an Aurora RDS database hosted on AWS.

# Command Line Options

| option | argument     | description                                                                                  |
|:------:|:------------:|----------------------------------------------------------------------------------------------|
|   -h   |     -        | Show the help options.                                                                       |
|   -i   | input.txt    | Input text file or Kindle EReader SQLite3 DB containing vocab words to upload.               |
|   -o   | output.txt   | Output file for Anki ingestion (colon separated).                                            |
|   -c   | mysql.config | MySQL configuration for the vocabulary database.                                             |
|   -u   |     -        | Allow updating the MySQL database, otherwise the vocabulary word is ignored.                 |
