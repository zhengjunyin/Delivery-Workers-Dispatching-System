//我的借阅，工作记录
<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, Back } from '@element-plus/icons-vue'
import request from '../../utils/request'
import { tr } from '@/i18n'

const router = useRouter()

const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(4)
const keyword = ref("")
const tableData = ref([])
const deliverys = ref([])

const loadDeliverys = () => {
  request.get("/delivery").then(res => {
    deliverys.value = res.data || []
  })
}

const load = () => {
  request.get("/workRecord/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: keyword.value,
    }
  }).then(res => {
    tableData.value = res.data?.records || []
    total.value = res.data?.total || 0
  })
}

const getStatusClass = (status) => {
  switch (status) {
    case 'Finished':
      return 'status-returned'
    case 'At work':
      return 'status-workRecording'
    default:
      return 'status-default'
  }
}

const isOverdue = (endDate, status) => {
  if (status === 'Finished') return false
  const today = new Date()
  const dueDate = new Date(endDate)
  return today > dueDate
}

const reset = () => {
  keyword.value = ""
  load()
}

const handleSizeChange = (size) => {
  pageSize.value = size
  load()
}

const handleCurrentChange = (current) => {
  pageNum.value = current
  load()
}

const totalCount = ref(0)
const okCount = ref(0)
const noCount = ref(0)

const loadCount = ()=>{
  request.get('/workRecord/count').then(res=>{
    totalCount.value = res.data.length
    okCount.value = res.data.filter(item=>item.status==='Finished').length
    noCount.value = res.data.filter(item=>item.status==='At work').length
  })
}

onMounted(() => {
  loadDeliverys()
  load()
  loadCount()
})
</script>

<template>
  <div class="order-container">
    <div class="header-section">
      <div class="title-area">
        <h1 class="page-title">
          <el-icon class="title-icon">
            <Search />
          </el-icon>
          {{ $tr('Work Records') }}
        </h1>

      </div>

      <div class="search-area">
        <div class="search-wrapper">
          <el-input
              v-model="keyword"
              :placeholder="$tr('Please enter delivery person\'s name')"
              clearable
          >
            <template #suffix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="load">
            <el-icon><Search /></el-icon>
            {{ $tr('Search') }}
          </el-button>
          <el-button @click="reset">
            <el-icon><Back /></el-icon>
            {{ $tr('Reset') }}
          </el-button>
        </div>
      </div>
    </div>

    <div class="stats-section">
      <div class="stats-card">
        <div class="stat-item">
          <span class="stat-number">{{ totalCount }}</span>
          <span class="stat-label">{{ $tr('Total') }}</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">{{ okCount }}</span>
          <span class="stat-label">{{ $tr('Finished') }}</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">{{ noCount }}</span>
          <span class="stat-label">{{ $tr('At work') }}</span>
        </div>
      </div>
    </div>

    <div class="deliverys-section">
      <div class="section-header">
        <h2 class="section-title">{{ $tr('Work Records') }}</h2>
      </div>

      <div class="deliverys-list">
        <div
            v-for="item in tableData"
            :key="item.id"
            class="delivery-item"
        >
          <div class="delivery-cover">
            <img
                :src="deliverys.find(b => b.id === item.deliveryId)?.img"
                class="cover-image"
            />

          </div>

          <div class="delivery-details">
            <div class="delivery-header">
              <h3
                  class="delivery-title"
                  @click="router.push('/front/deliveryDetail?id=' + item.deliveryId)"
              >
                {{ deliverys.find(b => b.id === item.deliveryId)?.name}}
              </h3>
              <div class="delivery-meta">
                <span class="author">{{ deliverys.find(b => b.id === item.deliveryId)?.author  }}</span>
                <span class="separator">•</span>
                <span class="publisher">{{ deliverys.find(b => b.id === item.deliveryId)?.press  }}</span>
              </div>
            </div>

            <div class="delivery-info-grid">
              <div class="info-row">
                <div class="info-group">
                  <span class="info-label">{{ $tr('Phone') }}</span>
                  <span class="info-value">{{ deliverys.find(b => b.id === item.deliveryId)?.isbn || '——' }}</span>
                </div>
              </div>

              <div class="info-row">
                <div class="info-group">
                  <span class="info-label">{{ $tr('Outgoing Time') }}</span>
                  <span class="info-value date">{{ item.date }}</span>
                </div>
                <div class="info-group">
                  <span class="info-label">{{ $tr('Expected Completion Time') }}</span>
                  <span class="info-value date" :class="{ 'overdue': isOverdue(item.endDate, item.status) }">
                    {{ item.endDate }}
                  </span>
                </div>
              </div>

              <div class="info-row">
                <div class="info-group">
                  <span class="info-label">{{ $tr('Actual Completion Time') }}</span>
                  <span class="info-value date">{{ item.backTime || $tr('Not Returned') }}</span>
                </div>
              </div>

              <div class="info-row">
                <div class="info-group full-width">
                  <span class="info-label">{{ $tr('Rating') }}</span>
                  <span class="info-value description">{{ deliverys.find(b => b.id === item.deliveryId)?.info || '——' }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="delivery-actions">
            <div class="action-buttons">
              <el-button
                  type="primary"
                  size="small"
                  @click="router.push('/front/deliveryDetail?id=' + item.deliveryId)"
              >
                <el-icon><Search /></el-icon>
                {{ $tr('View Details') }}
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="tableData.length === 0" class="empty-state">
      <div class="empty-illustration">
        <div class="empty-icon-wrapper">
          <el-icon class="empty-icon">
            <Search />
          </el-icon>
        </div>
      </div>
      <h3 class="empty-title">{{ $tr('No Records Found') }}</h3>
      <p class="empty-text">{{ $tr('You have no work records yet') }}</p>
    </div>

    <div v-if="tableData.length > 0" class="pagination-section">
      <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[4, 8, 12, 16]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
      />
    </div>

    <div class="bottom-spacer"></div>
  </div>
</template>

<style scoped>
.order-container {
  width: 70%;
  margin: 0 auto;
  padding: 20px 0;
  background: #f5f7fa;
  min-height: 100vh;
}

.header-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.title-area {
  text-align: center;
  margin-bottom: 25px;
}

.page-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  font-size: 2.2rem;
  font-weight: 700;
  margin: 0 0 12px 0;
  color: #2d3748;
}

.title-icon {
  font-size: 2rem;
  color: #4a5568;
}

.page-subtitle {
  color: #718096;
  font-size: 1rem;
  margin: 0;
}

.search-area {
  display: flex;
  justify-content: center;
}

.search-wrapper {
  display: flex;
  align-items: center;
  gap: 15px;
}

.stats-section {
  margin-bottom: 20px;
}

.stats-card {
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-around;
  align-items: center;
}

.stat-item {
  text-align: center;
  flex: 1;
}

.stat-number {
  display: block;
  font-size: 2rem;
  font-weight: 700;
  color: #2d3748;
  line-height: 1;
  margin-bottom: 5px;
}

.stat-label {
  color: #718096;
  font-size: 0.9rem;
  font-weight: 500;
}

.stat-divider {
  width: 1px;
  height: 40px;
  background: #e2e8f0;
  margin: 0 20px;
}

.deliverys-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f1f3f4;
}

.section-title {
  font-size: 1.4rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
}

.deliverys-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.delivery-item {
  display: flex;
  gap: 20px;
  padding: 20px;
  background: #fafbfc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.delivery-cover {
  position: relative;
  flex-shrink: 0;
  width: 90px;
  height: 120px;
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.status-overlay {
  position: absolute;
  top: 5px;
  right: 5px;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
}

.status-returned {
  background: #d4edda;
  color: #155724;
}

.status-workRecording {
  background: #fff3cd;
  color: #856404;
}

.status-default {
  background: #e2e3e5;
  color: #383d41;
}

.delivery-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.delivery-header {
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 10px;
}

.delivery-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 8px 0;
  cursor: pointer;
}

.delivery-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #718096;
  font-size: 0.9rem;
}

.author, .publisher {
  font-weight: 500;
}

.separator {
  color: #cbd5e0;
}

.delivery-info-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-row {
  display: flex;
  gap: 30px;
}

.info-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-group.full-width {
  flex: none;
  width: 100%;
}

.info-label {
  color: #718096;
  font-size: 0.8rem;
  font-weight: 500;
}

.info-value {
  color: #2d3748;
  font-weight: 600;
  font-size: 0.9rem;
}

.info-value.date {
  font-family: monospace;
}

.info-value.overdue {
  color: #e53e3e;
}

.info-value.description {
  font-weight: 400;
  line-height: 1.5;
  color: #4a5568;
}

.delivery-actions {
  flex-shrink: 0;
  width: 140px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.empty-illustration {
  margin-bottom: 20px;
}

.empty-icon-wrapper {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: #f7fafc;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.empty-icon {
  font-size: 2rem;
  color: #cbd5e0;
}

.empty-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #4a5568;
  margin: 0 0 8px 0;
}

.empty-text {
  font-size: 0.9rem;
  color: #718096;
  margin: 0;
}

.pagination-section {
  display: flex;
  justify-content: center;
  padding: 25px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.bottom-spacer {
  height: 50px;
}
</style>





