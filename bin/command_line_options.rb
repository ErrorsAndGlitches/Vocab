require 'optparse'
require 'json'

class CommandLineOptions
  def initialize(args)
    @args    = args
  end

  def input_file
    parse_options
    @options[:input_filename]
  end

  def output_file
    parse_options
    @options[:output_filename]
  end

  def sql_config_file
    parse_options
    @options[:sql_config_filename]
  end

  def api_key
    parse_options
    @options[:api_key] || json_api_key
  end

  def update_existing?
    parse_options
    @options[:update_existing]
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

      opts.on('-i', '--input-file=FILENAME', 'File containing vocab words to upload. Can either be a regular (.txt) or Kindle sqlite3 (.db) file.') { |input_filename|
        @options[:input_filename] = input_filename
      }

      opts.on('-o', '--output-file=FILENAME', 'Output file name for Anki ingestion.') { |output_filename|
        @options[:output_filename] = output_filename
      }

      opts.on('-c', '--sql-config=SQL_CONFIG', 'Path to the MYSQL configuration file') { |sql_config_filename|
        @options[:sql_config_filename] = sql_config_filename
      }

      opts.on('-a', '--api-key=API_KEY', 'Merriam Webster API key') { |api_key|
        @options[:api_key] = api_key
      }

      opts.on('-j', '--api-key-config=API_KEY_CONFIG', 'Merriam Webster API key JSON config file') { |api_key_filename|
        @options[:api_key_filename] = api_key_filename
      }

      opts.on('-u', '--update-existing', 'Update the existing entries in the MySQL DB when the vocab word already exists') {
        @options[:update_existing] = true
      }

      opts.on('-d', '--clear-mysql', 'Clear the MySQL database') {
        @options[:clear_mysql_db] = true
      }
    }.parse(@args)
  end
end