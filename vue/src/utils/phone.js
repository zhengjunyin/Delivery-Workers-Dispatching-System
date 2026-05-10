import { t } from '@/i18n'

const BELARUS_PHONE_PATTERN = /^\+375\d{9}$/

export function normalizeBelarusPhone(value) {
  if (value == null) return ''
  return String(value).trim().replace(/[\s\-()]/g, '')
}

export function isBelarusPhone(value) {
  return BELARUS_PHONE_PATTERN.test(normalizeBelarusPhone(value))
}

export function normalizeOptionalBelarusPhone(value) {
  const phone = normalizeBelarusPhone(value)
  if (!phone) return ''
  if (!BELARUS_PHONE_PATTERN.test(phone)) {
    throw new Error(t('validation.belarusPhone'))
  }
  return phone
}

export function normalizeRequiredBelarusPhone(value) {
  const phone = normalizeBelarusPhone(value)
  if (!BELARUS_PHONE_PATTERN.test(phone)) {
    throw new Error(t('validation.belarusPhoneRequired'))
  }
  return phone
}

export function optionalBelarusPhoneRule(rule, value, callback) {
  try {
    normalizeOptionalBelarusPhone(value)
    callback()
  } catch (error) {
    callback(new Error(error.message))
  }
}

export function requiredBelarusPhoneRule(rule, value, callback) {
  try {
    normalizeRequiredBelarusPhone(value)
    callback()
  } catch (error) {
    callback(new Error(error.message))
  }
}
