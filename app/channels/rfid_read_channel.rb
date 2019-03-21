class RfidReadChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'rfid_read'
  end
end
