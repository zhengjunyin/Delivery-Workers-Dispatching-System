<script setup>
import { currentElementLocale } from './i18n'
</script>

<template>
  <el-config-provider :locale="currentElementLocale">
    <RouterView />
  </el-config-provider>
</template>

<style scoped>
</style>
