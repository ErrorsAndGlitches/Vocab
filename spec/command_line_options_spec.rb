require_relative '../bin/command_line_options'

describe CommandLineOptions do
  context 'when given a set of command line options with the API key' do
    it 'should return the values parsed from them' do
      args          = %w(-i input_file_name -o output_file_name -s mysql_config_file_name -a merriam_webster_api_key
                         -u -d -l -r word_to_remove)
      cmd_line_opts = CommandLineOptions.new(args)

      expect(cmd_line_opts.input_file).to eq 'input_file_name'
      expect(cmd_line_opts.input_file_delimiter).to eq CommandLineOptions::DEFAULT_FILE_DELIMITER
      expect(cmd_line_opts.output_file).to eq 'output_file_name'
      expect(cmd_line_opts.sqlite_config_file).to eq 'mysql_config_file_name'
      expect(cmd_line_opts.api_key).to eq 'merriam_webster_api_key'
      expect(cmd_line_opts.update_existing?).to be true
      expect(cmd_line_opts.clear_mysql_db?).to be true
      expect(cmd_line_opts.list_db_vocab).to be true
      expect(cmd_line_opts.removal_word).to eq 'word_to_remove'
    end
  end

  context 'when given a set of command line options with a JSON API key' do
    it 'should return the values parsed from them' do
      args          = %w(-i input_file_name -p ; -o output_file_name -s mysql_config_file_name -j some_file.json)
      cmd_line_opts = CommandLineOptions.new(args)
      expect(File).to receive(:read)
                        .and_return(File.read('spec/data/merriam_webster_api_key.json'))
                        .with('some_file.json')

      expect(cmd_line_opts.input_file).to eq 'input_file_name'
      expect(cmd_line_opts.input_file_delimiter).to eq ';'
      expect(cmd_line_opts.output_file).to eq 'output_file_name'
      expect(cmd_line_opts.sqlite_config_file).to eq 'mysql_config_file_name'
      expect(cmd_line_opts.api_key).to eq '42'
      expect(cmd_line_opts.update_existing?).to be_falsey
      expect(cmd_line_opts.clear_mysql_db?).to be_falsey
      expect(cmd_line_opts.list_db_vocab).to be_falsey
      expect(cmd_line_opts.removal_word).to be nil
    end
  end


  context 'when an input file delimiter is absent' do
    it 'should return the default  input file delimiter' do
      args          = %w()
      cmd_line_opts = CommandLineOptions.new(args)
      expect(cmd_line_opts.input_file_delimiter).to eq CommandLineOptions::DEFAULT_FILE_DELIMITER
    end
  end

  context 'when an input file delimiter is given' do
    it 'should return the given input file delimiter' do
      args          = %w(-p ;)
      cmd_line_opts = CommandLineOptions.new(args)
      expect(cmd_line_opts.input_file_delimiter).to eq ';'
    end
  end
end
