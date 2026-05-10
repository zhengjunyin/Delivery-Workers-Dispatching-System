import { computed, ref, watch } from 'vue'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import en from 'element-plus/es/locale/lang/en'
import ru from 'element-plus/es/locale/lang/ru'
import { literalMessages, messages } from './messages'

const STORAGE_KEY = 'locale'
const locales = ['zh', 'en', 'ru']
const defaultLocale = 'zh'

export const currentLocale = ref(normalizeLocale(localStorage.getItem(STORAGE_KEY)))

export const languageOptions = computed(() => [
  { label: messages[currentLocale.value]['language.zh'], value: 'zh' },
  { label: messages[currentLocale.value]['language.en'], value: 'en' },
  { label: messages[currentLocale.value]['language.ru'], value: 'ru' }
])

export const currentElementLocale = computed(() => {
  if (currentLocale.value === 'en') return en
  if (currentLocale.value === 'ru') return ru
  return zhCn
})

const literalKeyByText = new Map()
for (const locale of locales) {
  Object.entries({ ...messages[locale], ...literalMessages[locale] }).forEach(([key, value]) => {
    literalKeyByText.set(key, key)
    literalKeyByText.set(value, key)
  })
}

export function t(key) {
  return messages[currentLocale.value][key]
      || literalMessages[currentLocale.value][key]
      || messages.en[key]
      || literalMessages.en[key]
      || key
}

export function setLocale(locale) {
  currentLocale.value = normalizeLocale(locale)
  localStorage.setItem(STORAGE_KEY, currentLocale.value)
}

export function normalizeLocale(locale) {
  return locales.includes(locale) ? locale : defaultLocale
}

export function translateLiteral(value) {
  if (value == null) return value
  const text = String(value)
  const trimmed = text.trim()
  if (!trimmed) return value
  const key = literalKeyByText.get(trimmed)
  if (!key) return value
  return text.replace(trimmed, t(key))
}

export const tr = translateLiteral

export function installI18n(app) {
  app.config.globalProperties.$t = t
  app.config.globalProperties.$tr = tr
}

watch(currentLocale, () => {
  document.documentElement.lang = currentLocale.value === 'zh' ? 'zh-CN' : currentLocale.value
}, { immediate: true })
