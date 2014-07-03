require 'spec_helper'

describe DestinationRewards::RemoteFolder do
  let(:remote_folder) { DestinationRewards::RemoteFolder.instance }

  it 'does not allow new instances of the DestinationRewards::RemoteFolder to be created' do
    expect{DestinationRewards::RemoteFolder.new}.to raise_error
  end

  describe '#instance' do
    it 'returns the single instace of the file uploader' do
      expect(DestinationRewards::RemoteFolder.instance).to equal remote_folder
    end
  end

  describe '#upload!' do
    let(:file) { double('File') }

    it 'starts a new SFTP connection to the remote folder' do
      expect(Net::SFTP).to receive(:start).with 'example.com',
                                                'username',
                                                 password: 'password'

      remote_folder.upload!(file, '/enrollment.csv')
    end

    it 'uploads the IO object passed in to the function to the specificed endpoint' do
      sftp_connection = double

      Net::SFTP.stub(:start).and_yield sftp_connection

      expect(sftp_connection).to receive(:upload!)

      remote_folder.upload!(file, '/enrollment.csv')
    end
  end
end
