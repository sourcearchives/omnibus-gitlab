require 'json'
require 'aws/s3'

TEN_YEARS = 10 * 365 * 24 * 60 * 60 # close to 10 years

def s3_server
  if ENV['S3_REGION']
    "s3-#{ENV['S3_REGION']}.amazonaws.com"
  else
    "s3.amazonaws.com"
  end
end

def signed_s3_url(pkg_path)
  AWS::S3::Base.establish_connection!(
    access_key_id: ENV['S3_ACCESS_KEY'],
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
    server: s3_server
  )

  AWS::S3::S3Object.url_for(
    pkg_path,
    ENV['S3_BUCKET'],
    expires_in: TEN_YEARS,
    use_ssl: true
  )
end

def main(options={})
  metadata = JSON.parse(ARGF.read)
  pkg_path = metadata.values_at(*%w{platform platform_version arch basename}).join('/')

  if options[:public]
    puts "https://" + [s3_server, ENV['S3_BUCKET'], pkg_path].join('/')
  else
    puts signed_s3_url(pkg_path)
  end
end

if ARGV.first == '--public'
  ARGV.shift
  main(public: true)
else
  main
end
