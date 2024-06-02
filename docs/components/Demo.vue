<template>
  <div class="demo-wrapper">
    <div class="mask">
      <div :class="[ 'content', {'pedro': clicks >= 10 }]" @click="handleClick"></div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const clicks = ref(0)

const handleClick = () => clicks.value++
</script>

<style>
.demo-wrapper {
  width: 100%;
  max-height: 350px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.demo-wrapper .content {
  /* aspect-ratio: 1 / 1; */
  position: relative;
  top: 4.5%;
  width: 100%;
  height: 100%;
  /* border: 1px solid red; */
  transform: skewY(18.8deg) scale(0.45, 0.6);
  /* background: black; */
  color: white;
  background-image: url('/assets/chart-line-square.webp');
  background-size: 101% 101%;
  background-repeat: no-repeat;
  background-position: center;
}

.demo-wrapper .content.pedro {
  background-image: url('/assets/pedro-cc.webp');
}

.demo-wrapper .mask {
  display: flex;
  aspect-ratio: 1 / 1;
  /* position: absolute; */
  /* top: -400px; */
  /* left: 0; */
  /* border: 1px solid red; */
  width: 100%;
  height: 100%;
  max-width: 400px;
  background-image: url('/assets/advanced_monitor_stack_crop.png');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
}
</style>