<template>
    <div>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Returns</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="method in methods" :key="method.name">
                    <td><code>{{ method.name }}</code></td>
                    <td>{{ method.returns }}</td>
                    <td>{{ method.description }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
    methods: {
        type: Array,
        required: true
    }
});
</script>
