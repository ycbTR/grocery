module Printer
  extend self
  # https://learn.adafruit.com/networked-thermal-printer-using-cups-and-raspberry-pi?view=all

  #** http://scruss.com/blog/2015/07/12/thermal-printer-driver-for-cups-linux-and-raspberry-pi-zj-58/

  # https://github.com/klirichek/zj-58

  # https://www.raspberrypi.org/forums/viewtopic.php?t=111669

  def print(object)
    text = if object.is_a? Order
             order_text(object)
           else
             object
           end
    # system("echo -e '#{text}' | lp ")
    puts system("echo '#{text}' | lp")
  end


  # printf "${F_VDOBLE}Esto es...\n"

  def order_text(order)
    val=<<TEXT
#{order.order_display_text}
Toplam: #{ order.total }TL
#{order.account.try(:name)}
Bakiye: #{order.account.balance.to_f}TL
#{order.completed_at.strftime("%d/%m,%H:%M")} #{order.printed_count}:#{order.id}
TEXT
    val
  end


  def print_z_report(product_report, orders, total, balance_added, start_time, end_time)
    val = "#{start_time.strftime("%d/%m,%H:%M")}-#{end_time.strftime("%d/%m,%H:%M")}"
    val += "\nÜrün Adet Tutar"
    product_report.each do |name, h|
      val += "\n #{name} #{h[:count]} #{h[:total]}TL"
    end
    val += "\nSipariş sayısı: #{orders.count}"
    val += "\nToplam: #{total.to_f}TL"
    val += "\nYüklemeler: #{balance_added.to_f}TL"
    print(val)
  end
end