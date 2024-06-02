<template>
    <div>
        <table style="display: table; width: 100%">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Default</th>
                </tr>
            </thead>
            <tbody>
                <template v-for="property in properties" :key="property.name">
                    <tr>
                        <td style="width: 30%">
                            <code>{{ property.name }}</code><span v-if="property.setBy"> 🔒</span>
                            <template v-if="typeof property.setBy === 'string'">
                                <br><em>(set by {{ property.setBy }})</em>
                            </template>
                        </td>
                        <td><code>{{ property.type }}</code></td>
                        <td><code>{{ property.default }}</code></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <template v-if="$slots[property.name]">
                                <slot :name="property.name" />
                            </template>
                            <template v-else>{{ property.description }}</template>
                        </td>
                    </tr>
                </template>
                
            </tbody>
        </table>
        <h1><slot></slot></h1>
    </div>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
    properties: {
        type: Array,
        required: true
    }
});
</script>