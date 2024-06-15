---@class cyberbit.Fluent
local Fluent = require 'fluent'

--- Multiply the value by a given multiplier.
---@param multiplier number
function Fluent:mult (multiplier)
  return self:_enqueue(function (this)
      this.value = this.value * multiplier
  end)
end

--- Divide the value by a given divisor.
---@param divisor number
function Fluent:div (divisor)
  return self:_enqueue(function (this)
      this.value = this.value / divisor
  end)
end

--- Convert the value from Mekanism joules to Forge Energy/RF.
function Fluent:joulesToFE ()
  if not mekanismEnergyHelper then
    error('mekanismEnergyHelper is not available')
  end

  return self:_enqueue(function (this)
      this.value = mekanismEnergyHelper.joulesToFE(this.value)
  end)
end

--- Set unit to fluid unit, 'B'.
function Fluent:fluid()
  return self:with('unit', 'B')
end

--- Set unit to fluid rate unit, 'B/t'.
function Fluent:fluidRate()
  return self:with('unit', 'B/t')
end

--- Set unit to temperature unit, 'K'.
function Fluent:temp()
  return self:with('unit', 'K')
end

--- Set unit to energy unit, 'FE'.
function Fluent:energy()
  return self:with('unit', 'FE')
end

--- Set unit to energy rate unit, 'FE/t'.
function Fluent:energyRate()
  return self:with('unit', 'FE/t')
end

--- Convert to format suitable for a Metric contstructor.
function Fluent:metricable()
  return self:_enqueue(function (this)
    local value = this.value

    this.value = {
      name = this.params.name,
      unit = this.params.unit,
      source = this.params.source,
      value = value,
  }
  end)
end

return Fluent