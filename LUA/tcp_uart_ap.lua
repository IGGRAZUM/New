
wifi.setmode(wifi.SOFTAP);
wifi.ap.config({ssid="test",pwd="12345678"});
outpin=4 -- Select right IO index !! Here is settings for GPIO2 (Lua build 20141219)
respin=7
uart.setup(0,38400,8,0,1,0)
sv=net.createServer(net.TCP, 120)
global_c = nil
sv:listen(9999, function(c)
     if global_c~=nil then
          global_c:close()
     end
     global_c=c
     
     c:on("receive",function(sck,pl)
      
     gpio.mode(outpin,gpio.OUTPUT)
     gpio.mode(respin,gpio.OUTPUT)
      dotaz=string.upper(pl) 
     --print (dotaz)
     dotaz2=string.match(dotaz,"ON")
    dotaz3=string.match(dotaz,"OFF")
    res=string.match(dotaz,"RES")
     if dotaz2=="ON" then gpio.write(outpin,gpio.LOW) end
    if dotaz3=="OFF" then gpio.write(outpin,gpio.HIGH) end
    if res=="RES" then
    gpio.write(respin,gpio.LOW)
    tmr.alarm(0, 300, 1, function() 
    gpio.write(respin,gpio.HIGH)
    tmr.stop (0)
    end )
    
    end
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

