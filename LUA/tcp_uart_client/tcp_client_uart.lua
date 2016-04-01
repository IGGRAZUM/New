local SSID = "Ludoed"
local SSID_PASSWORD = "bezumfixik"
outpin=4 -- Select right IO index !! Here is settings for GPIO2 (Lua build 20141219)
respin=7
 gpio.mode(outpin,gpio.OUTPUT)
 gpio.write(outpin,gpio.LOW)
 gpio.mode(respin,gpio.OUTPUT)
 gpio.write(respin,gpio.LOW)
wifi.setmode (wifi.STATION)
wifi.sta.config (SSID, SSID_PASSWORD)
wifi.sta.autoconnect (1)
tmr.alarm (1, 800, 1, function ( )
  if wifi.sta.getip ( ) == nil then
     --print ("Waiting for Wifi connection")
  else
     tmr.stop (1)
     --print ("Config done, IP is " .. wifi.sta.getip ( ))
     sk:connect(9999,"192.168.4.1")  
     print ("OK")   
  end
end)


uart.setup(0,38400,8,0,1,0)
sk=net.createConnection(net.TCP, 0)
--sk:connect(9999,"192.168.4.1")
sk:on("receive", function(sck,pl) 
uart.write(0,pl)
gpio.write(outpin,gpio.LOW)
 gpio.write(respin,gpio.HIGH)
end)

uart.on("data",4, function(data)
gpio.write(outpin,gpio.HIGH)
 gpio.write(respin,gpio.LOW) 
sk:send(data)
end,0)
          --gpio.write(outpin,gpio.LOW)
     


