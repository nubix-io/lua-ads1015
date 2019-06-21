print('Begin test')

local ads1015 = require 'ads1015'
local periphery = require 'periphery'

-- ============================================================================
-- Mini test framework
-- ============================================================================

local failures = 0

local function assertEquals(expected,actual,message)
  message = message or string.format('Expected %s but got %s', tostring(expected), tostring(actual))
  assert(actual==expected, message)
end

local function it(message, testFn)
  local status, err =  pcall(testFn)
  if status then
    print(string.format('✓ %s', message))
  else
    print(string.format('✖ %s', message))
    print(string.format('  FAILED: %s', err))
    failures = failures + 1
  end
end


-- ============================================================================
-- ads1015 module
-- ============================================================================

it('read_adc() works', function()
  local i2c = periphery.I2C('/dev/i2c-1')
  local device = 0x48
  local channel = 0
  local gain = 1
  local dataRate = nil
  local value = ads1015.read_adc(i2c, device, channel, gain, dataRate)
  print('** value', value)
end)
