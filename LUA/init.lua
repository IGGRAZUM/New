--init.lua, something like this
uart.setup(0,38400,8,0,1,0)
respin=7
gpio.mode(4, gpio.OUTPUT)
gpio.mode(respin,gpio.OUTPUT)
gpio.write(4, gpio.HIGH);
gpio.write(respin,gpio.HIGH)
countdown = 3
tmr.alarm(0,1000,1,function()
    print(countdown)
    countdown = countdown-1
    if countdown<1 then
        tmr.stop(0)
        countdown = nil
        local s,err
        if file.open("user.lc") then
            file.close()
            s,err = pcall(function() dofile("user.lc") end)
        else
            s,err = pcall(function() dofile("tcp_uart_ap.lua") end)
        end
        if not s then print(err) end
    end
end)
