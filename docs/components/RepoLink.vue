<template>
    <a
        :href="repoUrl"
        target="_blank"
        style="float: right; font-size: 16px;"
    >{{ label || 'Source' }}</a>
</template>

<script setup>
import { defineProps, computed } from 'vue';

const props = defineProps({
    path: {
        type: String,
        required: true
    },
    label: {
        type: String
    },
    module: {
        type: Boolean
    }
});

const repoUrl = computed(() => {
    const repo = props.module ? 'telem-modules' : 'telem';
    
    return `https://github.com/cyberbit/${repo}/blob/main/src/telem/${props.path}`;
});
</script>
