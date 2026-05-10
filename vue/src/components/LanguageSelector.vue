<script setup>
import { computed } from 'vue'
import { currentLocale, languageOptions, setLocale, t } from '@/i18n'

const locale = computed({
  get: () => currentLocale.value,
  set: (value) => setLocale(value)
})
</script>

<template>
  <div class="language-selector">
    <span class="language-label">{{ t('language.label') }}</span>
    <el-select v-model="locale" size="small" style="width: 118px">
      <el-option
          v-for="item in languageOptions"
          :key="item.value"
          :label="item.label"
          :value="item.value"
      />
    </el-select>
  </div>
</template>

<style scoped>
.language-selector {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  white-space: nowrap;
}

.language-label {
  color: #606266;
  font-size: 13px;
}
</style>
