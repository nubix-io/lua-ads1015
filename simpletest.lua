-- Simple demo of reading each analog input from the ADS1x15 and printing it to the screen.
-- Author: Tony DiCola
-- License: Public Domain
-- ported to Lua by Nubix

local ads1015 = require 'ads1015'
local periphery = require 'periphery'
local socket = require 'socket'

local unpack = unpack or table.unpack

local busnum = 1
local i2c = periphery.I2C(string.format('/dev/i2c-%d', busnum))

local address = 0x48

-- Choose a gain of 1 for reading voltages from 0 to 4.09V.
-- Or pick a different gain to change the range of voltages that are read:
--  - 2/3 = +/-6.144V
--  -   1 = +/-4.096V
--  -   2 = +/-2.048V
--  -   4 = +/-1.024V
--  -   8 = +/-0.512V
--  -  16 = +/-0.256V
-- See table 3 in the ADS1015/ADS1115 datasheet for more info on gain.
local gain = 1

print('Reading ADS1015 values, press Ctrl-C to quit...')
print('|      0 |      1 |      2 |      3 |')
print('+--------+--------+--------+--------+')

-- Main loop
while true do
    -- Read all the ADC channel values in a list
    local values = {}
    for channel = 0, 3 do
    
      -- Read the specified ADC channel using the previously set gain value
      values[#values+1] = ads1015.read_adc(i2c, address, channel, gain)
      
      -- Note you can also pass in an optional data_rate parameter that controls
      -- the ADC conversion time (in samples/second). Each chip has a different
      -- set of allowed data rate values, see datasheet Table 9 config register
      -- DR bit values.
      --values[channel+1] = ads1015.read_adc(i2c, address, channel, gain, 128)
      -- Each value will be a 12 bit signed integer value.
    end
  
  -- Print the ADC values
  print(string.format('| %6d | %6d | %6d | %6d |', unpack(values)))
  
  -- Pause for half a second
  socket.sleep(0.5)
end
