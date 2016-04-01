local SSID = "Fixiki"
local SSID_PASSWORD = "lysyedemony"


wifi.setmode (wifi.STATION)
wifi.sta.config (SSID, SSID_PASSWORD)
wifi.sta.autoconnect (1)
tmr.alarm (1, 800, 1, function ( )
  if wifi.sta.getip ( ) == nil then
     print ("Waiting for Wifi connection")
  else
     tmr.stop (1)
     print ("Config done, IP is " .. wifi.sta.getip ( ))
  end
end)
outpin=4 -- Select right IO index !! Here is settings for GPIO2 (Lua build 20141219)
uart.setup(0,9600,8,0,1,0)
sv=net.createServer(net.TCP, 60)
global_c = nil
sv:listen(9999, function(c)
     if global_c~=nil then
          global_c:close()
     end
     global_c=c
     
     c:on("receive",function(sck,pl)
      
     gpio.mode(outpin,gpio.OUTPUT)
      dotaz=string.upper(pl) 
     --print (dotaz)
     dotaz2=string.match(dotaz,"ON")
    dotaz3=string.match(dotaz,"OFF")
     if dotaz2=="ON" then gpio.write(outpin,gpio.HIGH) end
    if dotaz3=="OFF" then gpio.write(outpin,gpio.LOW) end
     uart.write(0,pl);
     
     --gpio.write(outpin,gpio.HIGH) 
     end)
end)

uart.on("data",4, function(data)
     if global_c~=nil then
          global_c:send(data)
          --gpio.write(outpin,gpio.LOW)
     end
end, 0)

