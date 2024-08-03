export default {
  load() {
    return {
      generator: {
        basic: [
          { name: 'production_rate', value: '0.0 - inf', unit: 'FE/t' }
        ],

        energy: [
          { name: 'max_energy_output', value: '0.0 - inf', unit: 'FE/t' }
        ]
      },

      genericMachine: {
        basic: [
          { name: 'energy_filled_percentage', value: '0.0 - 1.0' }
        ],

        advanced: [
          { name: 'comparator_level', value: '0 - 15' }
        ],

        energy: [
          { name: 'energy',         value: '0.0 - inf', unit: 'FE' },
          { name: 'max_energy',     value: '0.0 - inf', unit: 'FE' },
          { name: 'energy_needed',  value: '0.0 - inf', unit: 'FE' }
        ]
      },

      multiblock: {
        formation: [
          { name: 'formed', value: '0 or 1',  unit: 'B' },
          { name: 'height', value: '0 - inf', unit: 'm' },
          { name: 'length', value: '0 - inf', unit: 'm' },
          { name: 'width',  value: '0 - inf', unit: 'm' }
        ]
      },

      recipeProgress: {
        recipe: [
          { name: 'recipe_progress',  value: '0 - inf', unit: 't' },
          { name: 'ticks_required',   value: '0 - inf', unit: 't' }
        ],
        recipeFactory: [
          { name: 'recipe_progress_N',  value: '0 - inf', unit: 't' },
          { name: 'ticks_required',     value: '0 - inf', unit: 't' }
        ]
      }
    }
  }
}