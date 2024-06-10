return {
  handleCollection = require 'telem.lib.middleware.HandleCollectionMiddleware',
  calcAvg = require 'telem.lib.middleware.CalcAverageMiddleware',
  calcDelta = require 'telem.lib.middleware.CalcDeltaMiddleware',
  sort = require 'telem.lib.middleware.SortCollectionMiddleware',
}