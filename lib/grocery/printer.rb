module Printer
  extend self
  # https://learn.adafruit.com/networked-thermal-printer-using-cups-and-raspberry-pi?view=all
  def print(val)
    text = "This is a test.\\n\\n\\n"
    system("echo -e '#{text}' > /dev/ttyUSB0")
  end
end