return {
    helloWorld = require 'telem.lib.output.HelloWorldOutputAdapter',
    custom = require 'telem.lib.output.CustomOutputAdapter',

    -- HTTP
    grafana = require 'telem.lib.output.GrafanaOutputAdapter',

    -- Basalt
    basalt = {
        label = require 'telem.lib.output.basalt.LabelOutputAdapter',
        graph = require 'telem.lib.output.basalt.GraphOutputAdapter',
    },

    -- Plotter
    plotter = {
        line = require 'telem.lib.output.plotter.ChartLineOutputAdapter',
        multiline = require 'telem.lib.output.plotter.ChartMultiLineOutputAdapter',
        area = require 'telem.lib.output.plotter.ChartAreaOutputAdapter',
    },

    -- Modem
    secureModem = require 'telem.lib.output.SecureModemOutputAdapter'
}