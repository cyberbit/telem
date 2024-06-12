return {
  sort = require 'telem.lib.middleware.SortMiddleware',
  calcAvg = require 'telem.lib.middleware.CalcAverageMiddleware',
  calcDelta = require 'telem.lib.middleware.CalcDeltaMiddleware',
  custom = require 'telem.lib.middleware.CustomMiddleware',
}