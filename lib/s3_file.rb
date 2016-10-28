require 'tempfile'

class S3File
  def initialize(s3_client, bucket, key)
    @s3_client      = s3_client
    @bucket         = bucket
    @key            = key
    @local_filepath = key
  end

  def download
    @s3_client.get_object(
      response_target: @local_filepath,
      bucket:          @bucket,
      key:             @key)
  end

  def local_filepath
    @local_filepath
  end

  def upload
    File.open(@local_filepath, 'rb') do |file|
      @s3_client.put_object(bucket: @bucket, key: @key, body: file)
    end
  end
end