module Printer
  extend self
  # https://learn.adafruit.com/networked-thermal-printer-using-cups-and-raspberry-pi?view=all
  def print(object)
    val = if object.is_a? Order
            order_text(object)
          else
            object
          end
    system("echo -e '#{text}' > /dev/ttyUSB0")
  end


  def order_text(order)
    val=<<TEXT
#{order_display_text}
    Toplam: ₺#{ order.total }
    #{order.account.try(:name)} bakiyeniz ₺#{order.account.balance.to_f}
    #{order.completed_at} - P:#{order.printed_count}#:#{order.id}
TEXT
    val
  end
end