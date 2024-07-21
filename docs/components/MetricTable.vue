<template>
    <div>
        <table style="display: table; width: 100%">
            <thead>
                <tr>
                    <th style="width: 50%">Name</th>
                    <th>Value</th>
                    <th>Unit</th>
                    <template v-if="showHeritage">
                        <th>Adapter</th>
                        <th>Source</th>
                    </template>
                </tr>
            </thead>
            <tbody>
                <template v-for="(metric, i) in metrics" :key="metric.name">
                    <tr>
                        <td>
                            <code>{{ prefix + metric.name }}</code>
                            <template v-if="metric.badge">
                                <br><Badge class="metric-badge" :type="metric.badge.type" :text="metric.badge.text" />
                            </template>
                        </td>
                        <td>{{ metric.value }}</td>
                        <td>{{ metric.unit || '' }}</td>
                        <template v-if="showHeritage">
                            <template v-if="allAdapters">
                                <td
                                    v-if="i === 0"
                                    :rowspan="metrics.length"
                                >
                                    <code v-if="allAdapters">{{ allAdapters }}</code>
                                </td>
                            </template>
                            <template v-else>
                                <td><code v-if="metric.adapter">{{ metric.adapter }}</code></td>
                            </template>
                            <template v-if="allSources">
                                <td
                                    v-if="i === 0"
                                    :rowspan="metrics.length"
                                >
                                    <code v-if="allSources">{{ allSources }}</code>
                                </td>
                            </template>
                            <template v-else>
                                <td><code v-if="metric.source">{{ metric.source }}</code></td>
                            </template>
                        </template>
                    </tr>
                </template>
            </tbody>
        </table>
    </div>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
    metrics: {
        type: Array,
        required: true
    },
    prefix: {
        type: String,
        default: ''
    },
    showHeritage: {
        type: Boolean,
        default: false
    },
    allAdapters: {
        type: String,
        default: null
    },
    allSources: {
        type: String,
        default: null
    }
});
</script>

<style>
.metric-badge {
    margin-top: 0.5rem;
}
</style>