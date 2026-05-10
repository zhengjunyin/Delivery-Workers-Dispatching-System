
<script setup>
//我的参加，活动记录
import { ref, onMounted } from 'vue'
import { CollectionTag, Flag, SuccessFilled, InfoFilled } from '@element-plus/icons-vue'
import request from '../../utils/request'
import { tr } from '@/i18n'

const tableData = ref([])
const activities = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(12)
const keyword = ref("")

const load = () => {
  request.get("/activityRecord/page", {
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

const loadActivities = () => {
  request.get("/activity").then(res => {
    activities.value = res.data || []
  })
}

const getStatusType = (status) => {
  switch (status) {
    case 'Joined':
      return 'success'
    case 'Not checked in':
      return 'warning'
    default:
      return 'info'
  }
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
  request.get('/activityRecord/count').then(res=>{
    totalCount.value = res.data.length
    okCount.value = res.data.filter(item=>item.status==='Joined').length
    noCount.value = res.data.filter(item=>item.status==='Not checked in').length
  })
}

onMounted(() => {
  load()
  loadActivities()
  loadCount()
})
</script>

<template>
  <div class="activity-container">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          {{ $tr('Activity Records') }}
        </h1>
        <p class="page-subtitle">{{ $tr('View all activity participation records') }}</p>
      </div>
    </div>
<!--    <div class="stats-section">
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon><Flag /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ totalCount }}</div>
            <div class="stat-label">Total Participations</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon completed">
            <el-icon><SuccessFilled /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ okCount }}</div>
            <div class="stat-label">Joined</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon ongoing">
            <el-icon><InfoFilled /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ noCount }}</div>
            <div class="stat-label">{{ $tr('Not Checked In') }}</div>
          </div>
        </div>
      </div>
    </div>-->

    <div class="activities-section">
      <div class="section-header">
<!--        <h2 class="section-title">{{ $tr('Activity Records') }}</h2>-->
      </div>

      <div class="activities-list">
        <div
            v-for="item in tableData"
            class="list-item"
        >
          <div class="list-left">
            <div class="activity-icon-wrapper">
              <el-icon class="activity-icon">
                <el-icon><CollectionTag /></el-icon>
              </el-icon>
            </div>
          </div>

          <div class="list-content">
            <div class="list-header">
              <h4 class="list-title">
                {{ activities.find(a => a.id === item.itemId)?.name || $tr('Unknown Activity') }}
              </h4>
<!--              <el-tag
                  :type="getStatusType(item.status)"
                  size="small"
              >
                {{ item.status || 'Unknown' }}
              </el-tag>-->
            </div>

            <div class="list-details">
              <div class="detail-group">
                <span class="detail-label">{{ $tr('Event Date:') }}</span>
                <span class="detail-value">
                  {{ activities.find(a => a.id === item.itemId)?.startDate}} - {{ activities.find(a => a.id === item.itemId)?.endDate}}
                </span>
              </div>
<!--              <div class="detail-group">-->
<!--                <span class="detail-label">{{ $tr('Participation Time:') }}</span>-->
<!--                <span class="detail-value">{{ item.time || '-' }}</span>-->
<!--              </div>-->
              <div class="detail-group">
                <span class="detail-label">{{ $tr('Participant:') }}</span>
                <span class="detail-value">{{ item.name || '-' }}</span>
              </div>
              <div class="detail-group">
                <span class="detail-label">{{ $tr('Phone:') }}</span>
                <span class="detail-value phone">{{ item.phone || '-' }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="tableData.length === 0" class="empty-state">
        <h3 class="empty-title">{{ $tr('No Activity Records') }}</h3>
        <p class="empty-text">{{ $tr('You haven\'t participated in any activities yet. Go join some exciting activities!') }}</p>
      </div>

      <div v-if="tableData.length > 0" class="pagination-section">
        <el-pagination
            v-model:current-page="pageNum"
            v-model:page-size="pageSize"
            :page-sizes="[6, 12, 18, 24]"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.activity-container {
  width: 70%;
  margin: 0 auto;
  padding: 20px 0;
  background: #f8f9fa;
  min-height: 100vh;
}

.page-header {
  background: white;
  border-radius: 12px;
  padding: 40px;
  margin-bottom: 30px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 600px;
  margin: 0 auto;
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

.page-subtitle {
  font-size: 1rem;
  margin: 0;
  color: #718096;
}

.stats-section {
  margin-bottom: 30px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: #718096;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.stat-icon.completed {
  background: #38a169;
}

.stat-icon.ongoing {
  background: #d69e2e;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 2rem;
  font-weight: 700;
  color: #2d3748;
  line-height: 1;
}

.stat-label {
  color: #718096;
  font-size: 0.9rem;
  margin-top: 5px;
}

.activities-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.section-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #e2e8f0;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
}

.activities-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.list-item {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px;
  background: #f7fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.list-left {
  flex-shrink: 0;
}

.activity-icon-wrapper {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: #4a5568;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.activity-icon {
  font-size: 1.2rem;
}

.list-content {
  flex: 1;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.list-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
}

.list-details {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
}

.detail-group {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.detail-label {
  color: #718096;
  font-size: 0.8rem;
  font-weight: 500;
}

.detail-value {
  color: #2d3748;
  font-weight: 600;
  font-size: 0.9rem;
}

.detail-value.phone {
  font-family: monospace;
  color: #4a5568;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
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
  padding-top: 30px;
  margin-top: 30px;
  border-top: 2px solid #e2e8f0;
}
</style>



<!--
<script setup>
import { ref, onMounted } from 'vue'
import { CollectionTag, Flag, SuccessFilled, InfoFilled } from '@element-plus/icons-vue'
import request from '../../utils/request'

const tableData = ref([])
const activities = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(12)
const keyword = ref("")

const load = () => {
  request.get("/activityRecord/page", {
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

const loadActivities = () => {
  request.get("/activity").then(res => {
    activities.value = res.data || []
  })
}

const getStatusType = (status) => {
  switch (status) {
    case '已参加':
      return 'success'
    case '待打卡':
      return 'warning'
    default:
      return 'info'
  }
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
  request.get('/activityRecord/count').then(res=>{
    totalCount.value = res.data.length
    okCount.value = res.data.filter(item=>item.status==='已参加').length
    noCount.value = res.data.filter(item=>item.status==='待打卡').length
  })
}

onMounted(() => {
  load()
  loadActivities()
  loadCount()
})
</script>

<template>
  <div class="activity-container">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          我的活动
        </h1>
        <p class="page-subtitle">查看您参与的所有活动记录</p>
      </div>
    </div>

    <div class="stats-section">
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon><Flag /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ totalCount }}</div>
            <div class="stat-label">参与活动</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon completed">
            <el-icon><SuccessFilled /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ okCount }}</div>
            <div class="stat-label">已参加</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon ongoing">
            <el-icon><InfoFilled /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-number">{{ noCount }}</div>
            <div class="stat-label">待打卡</div>
          </div>
        </div>
      </div>
    </div>

    <div class="activities-section">
      <div class="section-header">
        <h2 class="section-title">活动记录</h2>
      </div>

      <div class="activities-list">
        <div
            v-for="item in tableData"
            class="list-item"
        >
          <div class="list-left">
            <div class="activity-icon-wrapper">
              <el-icon class="activity-icon">
                <el-icon><CollectionTag /></el-icon>
              </el-icon>
            </div>
          </div>

          <div class="list-content">
            <div class="list-header">
              <h4 class="list-title">
                {{ activities.find(a => a.id === item.itemId)?.name || '未知活动' }}
              </h4>
              <el-tag
                  :type="getStatusType(item.status)"
                  size="small"
              >
                {{ item.status || '未知' }}
              </el-tag>
            </div>

            <div class="list-details">
              <div class="detail-group">
                <span class="detail-label">活动日期:</span>
                <span class="detail-value">
                  {{ activities.find(a => a.id === item.itemId)?.startDate}} - {{ activities.find(a => a.id === item.itemId)?.endDate}}
                </span>
              </div>
              <div class="detail-group">
                <span class="detail-label">参与时间:</span>
                <span class="detail-value">{{ item.time || '-' }}</span>
              </div>
              <div class="detail-group">
                <span class="detail-label">报名人:</span>
                <span class="detail-value">{{ item.name || '-' }}</span>
              </div>
              <div class="detail-group">
                <span class="detail-label">电话:</span>
                <span class="detail-value phone">{{ item.phone || '-' }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="tableData.length === 0" class="empty-state">
        <h3 class="empty-title">暂无活动记录</h3>
        <p class="empty-text">您还没有参与任何活动，快去参加精彩活动吧！</p>
      </div>

      <div v-if="tableData.length > 0" class="pagination-section">
        <el-pagination
            v-model:current-page="pageNum"
            v-model:page-size="pageSize"
            :page-sizes="[6, 12, 18, 24]"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.activity-container {
  width: 70%;
  margin: 0 auto;
  padding: 20px 0;
  background: #f8f9fa;
  min-height: 100vh;
}

.page-header {
  background: white;
  border-radius: 12px;
  padding: 40px;
  margin-bottom: 30px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 600px;
  margin: 0 auto;
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

.page-subtitle {
  font-size: 1rem;
  margin: 0;
  color: #718096;
}

.stats-section {
  margin-bottom: 30px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: #718096;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.stat-icon.completed {
  background: #38a169;
}

.stat-icon.ongoing {
  background: #d69e2e;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 2rem;
  font-weight: 700;
  color: #2d3748;
  line-height: 1;
}

.stat-label {
  color: #718096;
  font-size: 0.9rem;
  margin-top: 5px;
}

.activities-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.section-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #e2e8f0;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
}

.activities-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.list-item {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px;
  background: #f7fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.list-left {
  flex-shrink: 0;
}

.activity-icon-wrapper {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: #4a5568;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.activity-icon {
  font-size: 1.2rem;
}

.list-content {
  flex: 1;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.list-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
}

.list-details {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
}

.detail-group {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.detail-label {
  color: #718096;
  font-size: 0.8rem;
  font-weight: 500;
}

.detail-value {
  color: #2d3748;
  font-weight: 600;
  font-size: 0.9rem;
}

.detail-value.phone {
  font-family: monospace;
  color: #4a5568;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
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
  padding-top: 30px;
  margin-top: 30px;
  border-top: 2px solid #e2e8f0;
}
</style>-->
