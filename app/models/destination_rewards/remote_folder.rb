class DestinationRewards::RemoteFolder
  include Singleton

  def upload!(file, path)
    Net::SFTP.start(ENV['DR_SFTP_HOST'],
                    ENV['DR_SFTP_USERNAME'],
                    password: ENV['DR_SFTP_PASSWORD']) do |connection|
                      connection.upload!(file, path)
                    end
  end
end
