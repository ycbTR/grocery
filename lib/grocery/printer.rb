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
    item_text = ""
    order.grouped_items.each do |h|
      item_text+="#{h[:count]} #{h[:name]} #{h[:total]}TL\n"
    end
    val=<<TEXT
#{item_text}
Toplam: #{ order.total }TL
#{order.account.try(:name)}
Bakiye: #{order.account.balance.to_f}TL
#{order.completed_at.strftime("%d/%m %H:%M")} #{order.printed_count}:#{order.id}
TEXT
    val
  end


  def print_z_report(product_report, orders, total, balance_added, balance_refunded, start_time, end_time)
    val = "      Z RAPORU"
    val += "\n#{start_time.strftime("%d/%m/%Y %H:%M")}\n#{end_time.strftime("%d/%m/%Y %H:%M")}"
    val += "\n******************\n"
    val += "\nÜrün|Adet|Tutar\n"
    product_report.each do |name, h|
      val += "\n#{name.to_s}|#{h[:count]}|#{h[:total]}TL"
    end
    val += "\n\n******************\n"
    val += "\nSipariş ad.: #{orders.count}"
    val += "\nToplam: #{total.to_f}TL"
    val += "\nYükleme: #{balance_added.to_f}TL"
    val += "\nİade sipariş: #{balance_refunded.to_f}TL"
    print(val)
  end
end
