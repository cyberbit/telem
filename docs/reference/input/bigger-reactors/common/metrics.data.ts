export default {
  load() {
    return {
      generator: {
        basic: [
          { name: 'production_rate', value: '0.0 - inf', unit: 'FE/t' }
        ],

        energy: [
          { name: 'energy',           value: '0.0 - inf', unit: 'FE' },
          { name: 'energy_capacity',  value: '0.0 - inf', unit: 'FE' }
        ]
      },

      genericMachine: {
        basic: [
          { name: 'active',     value: '0 or 1' },
          { name: 'connected',  value: '0 or 1' }
        ]
      }
    }
  }
}