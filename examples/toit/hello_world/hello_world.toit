
main:
  print "Hello world!"

  // Countdown
  for i := 10; i >= 0; i--:
    print "Restarting in $i seconds..."
    sleep --ms=1000

  print "Restarting now."
