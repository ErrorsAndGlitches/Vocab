require 'optparse'
require 'json'

class CommandLineOptions
  DEFAULT_FILE_DELIMITER = '#'

  def initialize(args)
    @args = args
  end

  def sqlite_config_file
    parse_options
    @options[:sqlite_config_filename]
  end

  def sqlite_create_or_read_db
    parse_options
    @options[:sqlite_create_or_read_db]
  end

  def api_key
    parse_options
    @options[:api_key] || json_api_key
  end

  def list_db_vocab
    parse_options
    @options[:list_db_vocab]
  end

  def input_file
    parse_options
    @options[:input_filename]
  end

  def input_file_delimiter
    parse_options
    @options[:input_file_delimiter] || DEFAULT_FILE_DELIMITER
  end

  def output_file
    parse_options
    @options[:output_filename]
  end

  def output_file_delimiter
    parse_options
    @options[:output_file_delimiter] || DEFAULT_FILE_DELIMITER
  end

  def update_existing?
    parse_options
    @options[:update_existing]
  end

  def removal_word
    parse_options
    @options[:removal_word]
  end

  def clear_mysql_db?
    parse_options
    @options[:clear_mysql_db]
  end

  private

  def parse_options
    parse unless @options
  end

  def json_api_key
    if @options[:api_key_filename].nil?
      nil
    else
      JSON.parse(File.read(@options[:api_key_filename]))['apiKey']
    end
  end

  def parse
    @options = {}
    OptionParser.new { |opts|
      opts.banner = "Usage: #{$0} [options]"

      opts.on('-h', '--help', 'Show help') {
        puts opts
        exit 0
      }

      opts.on('-s', '--sqlite-config-filename=SQLITE_CONFIG_FILENAME', 'Path to the SQLite3 configuration file') { |sqlite_config_filename|
        @options[:sqlite_config_filename] = sqlite_config_filename
      }

      opts.on('-c', '--sqlite-create-or-read-db', 'Create the SQLite DB file if it does not exist, otherwise just read it') {
        @options[:sqlite_create_or_read_db] = true
      }

      opts.on('-a', '--api-key=API_KEY', 'Merriam Webster API key') { |api_key|
        @options[:api_key] = api_key
      }

      opts.on('-j', '--api-key-config=API_KEY_CONFIG', 'Merriam Webster API key JSON config file') { |api_key_filename|
        @options[:api_key_filename] = api_key_filename
      }

      opts.on('-l', '--list-vocab', 'List the vocabulary words stored in the SQLite Db. The word, definition, and example are tab separated.') {
        @options[:list_db_vocab] = true
      }

      opts.on('-i', '--input-file=FILENAME', 'File containing vocab words to upload. Can either be a regular (.txt) or Kindle sqlite3 (.db) file.') { |input_filename|
        @options[:input_filename] = input_filename
      }

      opts.on('-p', '--input-delim=DELIMITER', "The field delimiter for the input text file. Default: #{DEFAULT_FILE_DELIMITER}") { |delimiter|
        @options[:input_file_delimiter] = delimiter
      }

      opts.on('-m', '--output-delim=DELIMITER', "The field delimiter for the output Anki text file. Default: #{DEFAULT_FILE_DELIMITER}") { |delimiter|
        @options[:output_file_delimiter] = delimiter
      }

      opts.on('-o', '--output-file=FILENAME', 'Output file name for Anki ingestion.') { |output_filename|
        @options[:output_filename] = output_filename
      }

      opts.on('-u', '--update-existing', 'Update the existing entries in the SQLite DB when the vocab word already exists') {
        @options[:update_existing] = true
      }

      opts.on('-r', '--removal-word=WORD', 'Delete the word from the SQLite database') { |word|
        @options[:removal_word] = word
      }

      opts.on('-d', '--clear-mysql', 'Clear the SQLite database') {
        @options[:clear_mysql_db] = true
      }
    }.parse(@args)
  end
end