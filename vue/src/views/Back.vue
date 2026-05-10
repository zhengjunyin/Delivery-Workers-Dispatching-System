<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  Flag,
  House,
  Lock,
  Notification,
  Picture,
  Reading,
  Setting,
  Ship,
  Suitcase,
  SwitchButton,
  User,
  UserFilled
} from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { projectName } from '../../config/config.default'
import LanguageSelector from '@/components/LanguageSelector.vue'
import { t } from '@/i18n'

const router = useRouter()
const route = useRoute()
const activeMenu = computed(() => route.path)
const isCollapse = ref(false)
const sideWidth = computed(() => isCollapse.value ? 64 : 210)

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
  <div class="admin-layout">
    <header class="admin-header">
      <div class="logo-container" :style="{ width: sideWidth + 'px' }" @click="isCollapse = !isCollapse">
        <img src="../../config/logo.svg" alt="Logo" class="logo-image" />
        <h1 v-show="!isCollapse" class="logo-text">{{ projectName }}</h1>
      </div>

      <div class="header-right">
        <LanguageSelector />
        <el-dropdown>
          <div class="user-info">
            <div class="user-avatar">
              <img :src="account.avatarUrl" />
            </div>
            <span class="user-name">{{ account.nickname }}</span>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item v-if="account.role === 'ROLE_ADMIN'">
                <router-link to="/back/adminPerson" class="dropdown-link">
                  <el-icon><User /></el-icon>
                  <span>{{ t('account.personalInfo') }}</span>
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/back/password" class="dropdown-link">
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

    <div class="admin-container">
      <aside class="admin-sidebar" :style="{ width: sideWidth + 'px' }">
        <el-menu :default-active="activeMenu" :collapse="isCollapse" router :collapse-transition="false">
          <el-menu-item index="/back/home">
            <el-icon><House /></el-icon>
            <template #title>{{ t('nav.backendHome') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/banner">
            <el-icon><Picture /></el-icon>
            <template #title>{{ t('nav.banner') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/article">
            <el-icon><Notification /></el-icon>
            <template #title>{{ t('nav.article') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/type">
            <el-icon><Setting /></el-icon>
            <template #title>{{ t('nav.type') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/delivery">
            <el-icon><Reading /></el-icon>
            <template #title>{{ t('nav.deliveryStaff') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/workRecord">
            <el-icon><Suitcase /></el-icon>
            <template #title>{{ t('nav.workRecords') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/activity">
            <el-icon><Ship /></el-icon>
            <template #title>{{ t('nav.activities') }}</template>
          </el-menu-item>
          <el-menu-item index="/back/activityRecord">
            <el-icon><Flag /></el-icon>
            <template #title>{{ t('nav.activityRecords') }}</template>
          </el-menu-item>
          <el-sub-menu index="roles" v-if="account.role === 'ROLE_ADMIN'">
            <template #title>
              <el-icon><UserFilled /></el-icon>
              <span>{{ t('nav.systemRole') }}</span>
            </template>
            <el-menu-item index="/back/admin">
              <el-icon><User /></el-icon>
              <template #title>{{ t('nav.admin') }}</template>
            </el-menu-item>
            <el-menu-item index="/back/user">
              <el-icon><User /></el-icon>
              <template #title>{{ t('nav.user') }}</template>
            </el-menu-item>
          </el-sub-menu>
        </el-menu>
      </aside>

      <main class="admin-content">
        <router-view @update-account="handleUpdateAccount"></router-view>
      </main>
    </div>
  </div>
</template>

<style scoped lang="scss">
.admin-layout {
  min-height: 100vh;
  background: #f4f6fa;
}

.admin-header {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  box-shadow: 0 1px 8px rgba(20, 40, 80, 0.08);
  position: sticky;
  top: 0;
  z-index: 20;
}

.logo-container {
  height: 60px;
  padding: 0 16px;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: width 0.2s;
}

.logo-image {
  width: 34px;
  height: 34px;
}

.logo-text {
  margin: 0;
  color: #4084d9;
  font-size: 18px;
  white-space: nowrap;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
  padding-right: 24px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
  border: 1px solid #e5e7eb;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-name {
  color: #303133;
}

.dropdown-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: inherit;
  text-decoration: none;
}

.admin-container {
  display: flex;
  min-height: calc(100vh - 60px);
}

.admin-sidebar {
  background: #fff;
  border-right: 1px solid #ebeef5;
  transition: width 0.2s;
}

.admin-sidebar :deep(.el-menu) {
  border-right: none;
}

.admin-content {
  flex: 1;
  min-width: 0;
  padding: 20px;
}
</style>
