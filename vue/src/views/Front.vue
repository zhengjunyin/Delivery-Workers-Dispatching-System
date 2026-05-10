<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Lock, SwitchButton, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { projectName } from '../../config/config.default'
import LanguageSelector from '@/components/LanguageSelector.vue'
import { t } from '@/i18n'

const router = useRouter()
const route = useRoute()
const activeMenu = computed(() => route.path)

const account = ref(
    localStorage.getItem('account') ? JSON.parse(localStorage.getItem('account')) : {}
)

const logout = () => {
  localStorage.removeItem('account')
  ElMessage.success(t('common.logoutSuccess'))
  router.push('/login')
}

const handleUpdateAccount = (updatedAccount) => {
  account.value = updatedAccount
}
</script>

<template>
  <div class="front-container">
    <header class="header-nav">
      <div class="header-left-warp">
        <div class="logo-warp">
          <div class="logo">
            <img src="../../config/logo.svg" alt="Logo" />
          </div>
          <div class="logo-text">{{ projectName }}</div>
        </div>

        <div class="header-navs">
          <el-menu router :default-active="activeMenu" mode="horizontal" :ellipsis="false">
            <el-menu-item index="/front/home">{{ t('nav.home') }}</el-menu-item>
            <el-menu-item index="/front/delivery">{{ t('nav.deliveryStaff') }}</el-menu-item>
            <el-menu-item index="/front/myWorkRecord">{{ t('nav.workRecords') }}</el-menu-item>
            <el-menu-item index="/front/activity">{{ t('nav.activities') }}</el-menu-item>
            <el-menu-item index="/front/myJoin">{{ t('nav.activityRecords') }}</el-menu-item>
          </el-menu>
        </div>
      </div>

      <div class="user-warp">
        <LanguageSelector />

        <template v-if="!account.id">
          <el-button @click="router.push('/login')">{{ t('auth.login') }}</el-button>
          <el-button @click="router.push('/register')">{{ t('auth.register') }}</el-button>
        </template>

        <el-dropdown v-else class="custom-dropdown">
          <div class="user-avatar">
            <img :src="account.avatarUrl" />
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item>{{ account.nickname }}</el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/person" class="dropdown-link">
                  <el-icon><User /></el-icon>
                  <span>{{ t('account.personalInfo') }}</span>
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/password" class="dropdown-link">
                  <el-icon><Lock /></el-icon>
                  <span>{{ t('account.changePassword') }}</span>
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <div @click="logout" class="dropdown-link">
                  <el-icon><SwitchButton /></el-icon>
                  <span>{{ t('account.logout') }}</span>
                </div>
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </header>

    <div class="main-content">
      <router-view @update-account="handleUpdateAccount"></router-view>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.front-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f6f8fb;
}

.header-nav {
  height: 64px;
  padding: 0 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  box-shadow: 0 1px 8px rgba(20, 40, 80, 0.08);
  position: sticky;
  top: 0;
  z-index: 10;
}

.header-left-warp {
  display: flex;
  align-items: center;
  min-width: 0;
}

.logo-warp {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-right: 28px;
  flex-shrink: 0;
}

.logo img {
  width: 34px;
  height: 34px;
}

.logo-text {
  color: #4084d9;
  font-weight: 700;
  font-size: 18px;
}

.header-navs :deep(.el-menu) {
  border-bottom: none;
}

.user-warp {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.user-avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  overflow: hidden;
  cursor: pointer;
  border: 1px solid #e5e7eb;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.dropdown-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: inherit;
  text-decoration: none;
}

.main-content {
  flex: 1;
}
</style>
