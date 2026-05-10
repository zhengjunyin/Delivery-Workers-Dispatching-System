<script setup>
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { DataAnalysis, Key, Lock, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { projectName } from '../../config/config.default'
import request from '@/utils/request.js'
import LanguageSelector from '@/components/LanguageSelector.vue'
import { t } from '@/i18n'

const router = useRouter()
const userFormInst = ref(null)
const isAllow = ref(true)

const roleOptions = computed(() => [
  { label: t('account.user'), value: 'ROLE_USER' },
  { label: t('account.admin'), value: 'ROLE_ADMIN' }
])

const account = reactive({
  username: '',
  password: '',
  role: 'ROLE_USER'
})

const rules = computed(() => ({
  username: [
    { required: true, message: t('validation.usernameRequired'), trigger: 'blur' },
    { min: 3, max: 10, message: t('validation.length3to10'), trigger: 'blur' }
  ],
  password: [
    { required: true, message: t('validation.passwordRequired'), trigger: 'blur' },
    { min: 1, max: 20, message: t('validation.length1to20'), trigger: 'blur' }
  ],
  role: [
    { required: true, message: t('validation.roleRequired'), trigger: 'change' }
  ]
}))

const login = () => {
  userFormInst.value.validate((valid) => {
    if (!valid) return
    request.post('/web/login', account).then((res) => {
      if (res.code === '200') {
        localStorage.setItem('account', JSON.stringify(res.data))
        router.push(res.data.role === 'ROLE_ADMIN' ? '/back/home' : '/front/home')
        ElMessage.success(t('login.success'))
      } else {
        ElMessage.error(res.msg || t('login.failed'))
      }
    })
  })
}
</script>

<template>
  <div class="login-container">
    <div class="language-entry">
      <LanguageSelector />
    </div>

    <div class="background-shapes">
      <div class="shape shape-1"></div>
      <div class="shape shape-2"></div>
      <div class="shape shape-3"></div>
      <div class="shape shape-4"></div>
    </div>

    <div class="login-content">
      <div class="login-left">
        <div class="brand-logo">
          <div class="logo-circle">
            <img src="../../config/logo.svg" alt="Logo" class="logo-image" />
            <Key class="logo-icon" />
          </div>
          <h2 class="brand-name">{{ projectName }}</h2>
        </div>

        <div class="login-features">
          <div class="feature-item">
            <div class="feature-icon"><el-icon><User /></el-icon></div>
            <div class="feature-text">
              <h3>{{ t('feature.staffScheduling') }}</h3>
              <p>{{ t('feature.staffSchedulingDesc') }}</p>
            </div>
          </div>
          <div class="feature-item">
            <div class="feature-icon"><el-icon><Lock /></el-icon></div>
            <div class="feature-text">
              <h3>{{ t('feature.reliable') }}</h3>
              <p>{{ t('feature.reliableDesc') }}</p>
            </div>
          </div>
          <div class="feature-item">
            <div class="feature-icon"><el-icon><DataAnalysis /></el-icon></div>
            <div class="feature-text">
              <h3>{{ t('feature.dataIntegration') }}</h3>
              <p>{{ t('feature.dataIntegrationDesc') }}</p>
            </div>
          </div>
        </div>
      </div>

      <div class="login-right">
        <div class="login-form-container">
          <h1 class="login-title">{{ t('login.title') }}</h1>
          <p class="login-subtitle">{{ t('login.subtitle') }}</p>

          <el-form :model="account" :rules="rules" ref="userFormInst" class="login-form" @keydown.enter="login">
            <el-form-item prop="username">
              <el-input :placeholder="t('validation.usernameRequired')" size="large" :prefix-icon="User" v-model="account.username" />
            </el-form-item>

            <el-form-item prop="password">
              <el-input size="large" :prefix-icon="Lock" show-password :placeholder="t('validation.passwordRequired')" v-model="account.password" />
            </el-form-item>

            <el-form-item prop="role">
              <el-select v-model="account.role" :placeholder="t('validation.roleRequired')" size="large" style="width: 100%">
                <el-option v-for="item in roleOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>

            <el-form-item>
              <el-checkbox v-model="isAllow" class="allow-warp">
                {{ t('auth.agree') }}
                <a href="#" class="link">{{ t('auth.privacy') }}</a>
                {{ t('auth.connector') }}
                <a href="#" class="link">{{ t('auth.terms') }}</a>
              </el-checkbox>
            </el-form-item>

            <el-form-item>
              <el-button class="login-button" type="primary" size="large" :disabled="!isAllow" @click="login">
                {{ t('auth.login') }}
              </el-button>
            </el-form-item>

            <div class="register-link">
              {{ t('auth.noAccount') }}
              <a @click="router.push('/register')" class="link">{{ t('auth.register') }}</a>
            </div>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.login-container {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #f0f4f8 0%, #d7e3f3 100%);
  position: relative;
  overflow: hidden;
}

.language-entry {
  position: absolute;
  top: 22px;
  right: 28px;
  z-index: 3;
}

.background-shapes {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.shape {
  position: absolute;
  border-radius: 50%;
  background: rgba(64, 132, 217, 0.08);
}

.shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; }
.shape-2 { width: 200px; height: 200px; bottom: 10%; right: 8%; }
.shape-3 { width: 120px; height: 120px; top: 16%; right: 20%; }
.shape-4 { width: 160px; height: 160px; bottom: -60px; left: 18%; }

.login-content {
  width: min(1040px, 92vw);
  min-height: 620px;
  display: grid;
  grid-template-columns: 1fr 430px;
  background: rgba(255, 255, 255, 0.82);
  border-radius: 18px;
  box-shadow: 0 22px 60px rgba(31, 63, 112, 0.15);
  overflow: hidden;
  z-index: 1;
}

.login-left {
  padding: 58px;
  background: linear-gradient(145deg, #2f73c8, #5c9ceb);
  color: #fff;
}

.brand-logo {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 68px;
}

.logo-circle {
  width: 62px;
  height: 62px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.18);
  display: grid;
  place-items: center;
  position: relative;
}

.logo-image {
  width: 38px;
  height: 38px;
}

.logo-icon {
  display: none;
}

.brand-name {
  margin: 0;
  font-size: 24px;
}

.login-features {
  display: grid;
  gap: 26px;
}

.feature-item {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.feature-icon {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  display: grid;
  place-items: center;
  background: rgba(255, 255, 255, 0.18);
}

.feature-text h3 {
  margin: 0 0 6px;
  font-size: 18px;
}

.feature-text p {
  margin: 0;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.82);
}

.login-right {
  display: flex;
  align-items: center;
  padding: 44px;
}

.login-form-container {
  width: 100%;
}

.login-title {
  margin: 0 0 8px;
  font-size: 32px;
  color: #263445;
}

.login-subtitle {
  margin: 0 0 28px;
  color: #7b8794;
}

.login-button {
  width: 100%;
}

.link {
  color: #4084d9;
  cursor: pointer;
  margin: 0 4px;
  text-decoration: none;
}

.register-link {
  text-align: center;
  color: #606266;
}
</style>
