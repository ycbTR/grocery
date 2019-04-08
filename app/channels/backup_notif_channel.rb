class BackupNotifChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'publish_backup'
  end
end
