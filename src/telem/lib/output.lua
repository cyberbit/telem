return {
    helloWorld = require 'telem.lib.output.HelloWorldOutputAdapter',
    custom = require 'telem.lib.output.CustomOutputAdapter',

    -- HTTP
    grafana = require 'telem.lib.output.GrafanaOutputAdapter',

    -- Basalt
    basalt = {
        label = require 'telem.lib.output.basalt.LabelOutputAdapter',
    },

    -- Plotter
    plotter = {
        line = require 'telem.lib.output.plotter.ChartLineOutputAdapter',
    },

    -- Modem
    secureModem = require 'telem.lib.output.SecureModemOutputAdapter'
}