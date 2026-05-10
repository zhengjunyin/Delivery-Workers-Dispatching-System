<script setup>
import { computed, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Back, MoreFilled, Promotion } from '@element-plus/icons-vue'
import request from '../../utils/request'
import { t, tr } from '@/i18n'
import { normalizeRequiredBelarusPhone, requiredBelarusPhoneRule } from '@/utils/phone'

const items = ref([])
const name = ref('')
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const selectedActivity = ref(null)
const dialog = ref(false)
const ruleFormRef = ref(null)

const form = ref({
  name: '',
  phone: '',
  itemId: null
})

const rules = computed(() => ({
  name: [
    {required: true, message: tr('Please enter your name'), trigger: 'blur'}
  ],
  phone: [
    {required: true, message: t('validation.belarusPhoneRequired'), trigger: 'blur'},
    {validator: requiredBelarusPhoneRule, trigger: 'blur'}
  ]
}))

const showDetails = (activity) => {
  selectedActivity.value = activity
  dialogVisible.value = true
}

const load = () => {
  request.get("/activity/front/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      name: name.value,
    }
  }).then(res => {
    items.value = res.data?.records || []
    total.value = res.data?.total || 0
  })
}

const join = () => {
  form.value.itemId = selectedActivity.value.id

  ruleFormRef.value.validate((valid) => {
    if (valid) {
      try {
        form.value.phone = normalizeRequiredBelarusPhone(form.value.phone)
      } catch (error) {
        ElMessage.error(error.message)
        return
      }
      request.post("/activityRecord", form.value).then(res => {
        if (res.code === '200') {
          ElMessage.success(t('activity.registrationSuccess'))
          dialog.value = false
          form.value = {
            name: '',
            phone: '',
            itemId: null
          }
          load()
        } else {
          ElMessage.error(res.msg || t('activity.registrationFailed'))
        }
      })
    }
  })
}

onMounted(() => {
  load()
})
</script>

<template>
  <div class="activity-container">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">{{ $tr('Activity List') }}</h1>
        <p class="page-description">{{ $tr('Browse and participate in various exciting activities') }}</p>
      </div>
    </div>

    <div class="activities-section">
      <div class="activities-grid">
        <div
            v-for="activity in items"
            :key="activity.id"
            class="activity-card"
        >
          <div class="card-image-wrapper">
            <img
                :src="activity.img"
                :alt="activity.name"
                class="card-image"
            />
          </div>

          <div class="card-content">
            <h3 class="card-title">{{ activity.name }}</h3>

            <el-tooltip
                effect="dark"
                placement="top"
                :content="activity.info"
            >
              <p class="card-description">{{ activity.info }}</p>
            </el-tooltip>

            <div class="card-details">
              <div class="detail-item">
                <span class="detail-label">{{ $tr('Start Date:') }}</span>
                <span class="detail-value">{{ activity.startDate }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ $tr('End Date:') }}</span>
                <span class="detail-value">{{ activity.endDate }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">{{ $tr('Location:') }}</span>
                <span class="detail-value">{{ activity.address }}</span>
              </div>
            </div>

            <el-button
                type="primary"
                @click="showDetails(activity)"
            >
              <el-icon>
                <Search/>
              </el-icon>
              {{ $tr('View Details') }}
            </el-button>
          </div>
        </div>
      </div>

      <div v-if="items.length === 0" class="empty-state">
        <div class="empty-illustration">
          <el-icon class="empty-icon">
            <MoreFilled/>
          </el-icon>
        </div>
        <h3 class="empty-title">{{ $tr('No Activities') }}</h3>
        <p class="empty-text">{{ $tr('Stay tuned for more exciting activities') }}</p>
      </div>
    </div>

    <el-dialog
        v-model="dialogVisible"
        :title="$tr('Activity Details')"
        width="70%"
        center
    >
      <div v-if="selectedActivity" class="dialog-content">
        <div class="activity-header">
          <h2 class="activity-title">{{ selectedActivity.name }}</h2>
          <div class="activity-meta">
            <div class="meta-item">
              <span class="meta-label">{{ $tr('Activity Time:') }}</span>
              <span class="meta-value">{{ selectedActivity.startDate }} - {{ selectedActivity.endDate }}</span>
            </div>
            <div class="meta-item">
              <span class="meta-label">{{ $tr('Location:') }}</span>
              <span class="meta-value">{{ selectedActivity.address }}</span>
            </div>
          </div>
        </div>

        <div class="activity-content">
          <div class="rich-content" v-html="selectedActivity.content"></div>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button type="success" @click="dialog = true">
            <el-icon>
              <Promotion/>
            </el-icon>
            {{ $tr('Register') }}
          </el-button>
          <el-button @click="dialogVisible = false">
            <el-icon>
              <Back/>
            </el-icon>
            {{ $tr('Close') }}
          </el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog
        :title="$tr('Activity Registration')"
        v-model="dialog"
        width="450px"
        :close-on-click-modal="false"
        center
    >
      <div class="register-content">
        <div class="register-header">
          <p class="register-tip">{{ $tr('Please fill in your registration information') }}</p>
        </div>

        <el-form
            :model="form"
            :rules="rules"
            ref="ruleFormRef"
            class="register-form"
            label-position="top"
        >
          <el-form-item prop="name" :label="$tr('Name')">
            <el-input
                v-model="form.name"
                :placeholder="$tr('Please enter your name')"
            />
          </el-form-item>
          <el-form-item prop="phone" :label="$tr('Phone Number')">
            <el-input
                v-model="form.phone"
                :placeholder="$tr('Please enter your phone number')"
            />
          </el-form-item>
        </el-form>
      </div>

      <template #footer>
        <div class="register-footer">
          <el-button @click="dialog = false">{{ $tr('Cancel') }}</el-button>
          <el-button type="primary" @click="join">{{ $tr('Confirm Registration') }}</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.activity-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  min-height: 100vh;
  background: #f8f9fa;
}

.page-header {
  padding: 30px 0;
  margin-bottom: 30px;
  border-bottom: 1px solid #e2e8f0;
}

.header-content {
  text-align: left;
}

.page-title {
  font-size: 2rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 8px 0;
  line-height: 1.2;
}

.page-description {
  font-size: 1rem;
  color: #718096;
  margin: 0;
  line-height: 1.5;
}

.activities-section {
  background: white;
  border-radius: 24px;
  padding: 40px;
  margin-bottom: 40px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.activities-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 30px;
}

.activity-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  height: 580px;
  display: flex;
  flex-direction: column;
}

.card-image-wrapper {
  position: relative;
  height: 240px;
  overflow: hidden;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-content {
  padding: 25px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 15px 0;
  line-height: 1.4;
}

.card-description {
  color: #4a5568;
  line-height: 1.6;
  margin: 0 0 20px 0;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 5;
  -webkit-box-orient: vertical;
  cursor: pointer;
}

.card-details {
  margin-bottom: 20px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 0.9rem;
}

.detail-label {
  color: #718096;
  font-weight: 500;
}

.detail-value {
  color: #2d3748;
  font-weight: 600;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.empty-illustration {
  margin-bottom: 30px;
}

.empty-icon {
  font-size: 5rem;
  color: #cbd5e0;
}

.empty-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #4a5568;
  margin: 0 0 12px 0;
}

.empty-text {
  font-size: 1rem;
  color: #718096;
  margin: 0;
}

.dialog-content {
  padding: 20px 0;
}

.activity-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f7fafc;
}

.activity-title {
  font-size: 1.8rem;
  font-weight: 700;
  color: #2d3748;
  margin: 0 0 15px 0;
}

.activity-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.meta-label {
  color: #718096;
  font-weight: 500;
  min-width: 80px;
}

.meta-value {
  color: #2d3748;
  font-weight: 600;
}

.activity-content {
  max-height: 400px;
  overflow-y: auto;
}

.rich-content {
  line-height: 1.8;
  font-size: 16px;
  color: #4a5568;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}

.register-content {
  padding: 20px 0;
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-tip {
  color: #718096;
  font-size: 1rem;
  margin: 0;
}

.register-form {
  margin-top: 20px;
}

.register-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}
</style>





<!--
<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Back, MoreFilled, Promotion } from '@element-plus/icons-vue'
import request from '../../utils/request'

const items = ref([])
const name = ref('')
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const selectedActivity = ref(null)
const dialog = ref(false)
const ruleFormRef = ref(null)

const form = ref({
  name: '',
  phone: '',
  itemId: null
})

const rules = {
  name: [
    {required: true, message: '请输入您的姓名', trigger: 'blur'}
  ],
  phone: [
    {required: true, message: '请输入您的电话', trigger: 'blur'}
  ]
}

const showDetails = (activity) => {
  selectedActivity.value = activity
  dialogVisible.value = true
}

const load = () => {
  request.get("/activity/front/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      name: name.value,
    }
  }).then(res => {
    items.value = res.data?.records || []
    total.value = res.data?.total || 0
  })
}

const join = () => {
  form.value.itemId = selectedActivity.value.id

  ruleFormRef.value.validate((valid) => {
    if (valid) {
      request.post("/activityRecord", form.value).then(res => {
        if (res.code === '200') {
          ElMessage.success("报名成功，请按时参加！")
          dialog.value = false
          form.value = {
            name: '',
            phone: '',
            itemId: null
          }
          load()
        } else {
          ElMessage.error("报名失败")
        }
      })
    }
  })
}

onMounted(() => {
  load()
})
</script>

<template>
  <div class="activity-container">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">活动列表</h1>
        <p class="page-description">浏览并参与各类精彩活动</p>
      </div>
    </div>

    <div class="activities-section">
      <div class="activities-grid">
        <div
            v-for="activity in items"
            :key="activity.id"
            class="activity-card"
        >
          <div class="card-image-wrapper">
            <img
                :src="activity.img"
                :alt="activity.name"
                class="card-image"
            />
          </div>

          <div class="card-content">
            <h3 class="card-title">{{ activity.name }}</h3>

            <el-tooltip
                effect="dark"
                placement="top"
                :content="activity.info"
            >
              <p class="card-description">{{ activity.info }}</p>
            </el-tooltip>

            <div class="card-details">
              <div class="detail-item">
                <span class="detail-label">开始日期:</span>
                <span class="detail-value">{{ activity.startDate }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">结束日期:</span>
                <span class="detail-value">{{ activity.endDate }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">活动地点:</span>
                <span class="detail-value">{{ activity.address }}</span>
              </div>
            </div>

            <el-button
                type="primary"
                @click="showDetails(activity)"
            >
              <el-icon>
                <Search/>
              </el-icon>
              查看详情
            </el-button>
          </div>
        </div>
      </div>

      <div v-if="items.length === 0" class="empty-state">
        <div class="empty-illustration">
          <el-icon class="empty-icon">
            <MoreFilled/>
          </el-icon>
        </div>
        <h3 class="empty-title">暂无活动</h3>
        <p class="empty-text">敬请期待更多精彩活动</p>
      </div>
    </div>

    <el-dialog
        v-model="dialogVisible"
        title="活动详情"
        width="70%"
        center
    >
      <div v-if="selectedActivity" class="dialog-content">
        <div class="activity-header">
          <h2 class="activity-title">{{ selectedActivity.name }}</h2>
          <div class="activity-meta">
            <div class="meta-item">
              <span class="meta-label">活动时间:</span>
              <span class="meta-value">{{ selectedActivity.startDate }} - {{ selectedActivity.endDate }}</span>
            </div>
            <div class="meta-item">
              <span class="meta-label">活动地点:</span>
              <span class="meta-value">{{ selectedActivity.address }}</span>
            </div>
          </div>
        </div>

        <div class="activity-content">
          <div class="rich-content" v-html="selectedActivity.content"></div>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button type="success" @click="dialog = true">
            <el-icon>
              <Promotion/>
            </el-icon>
            报名参加
          </el-button>
          <el-button @click="dialogVisible = false">
            <el-icon>
              <Back/>
            </el-icon>
            关闭
          </el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog
        title="活动报名"
        v-model="dialog"
        width="450px"
        :close-on-click-modal="false"
        center
    >
      <div class="register-content">
        <div class="register-header">
          <p class="register-tip">请填写您的报名信息</p>
        </div>

        <el-form
            :model="form"
            :rules="rules"
            ref="ruleFormRef"
            class="register-form"
            label-position="top"
        >
          <el-form-item prop="name" label="姓名">
            <el-input
                v-model="form.name"
                placeholder="请输入您的姓名"
            />
          </el-form-item>
          <el-form-item prop="phone" label="联系电话">
            <el-input
                v-model="form.phone"
                placeholder="请输入您的联系电话"
            />
          </el-form-item>
        </el-form>
      </div>

      <template #footer>
        <div class="register-footer">
          <el-button @click="dialog = false">取消</el-button>
          <el-button type="primary" @click="join">确认报名</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.activity-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  min-height: 100vh;
  background: #f8f9fa;
}

.page-header {
  padding: 30px 0;
  margin-bottom: 30px;
  border-bottom: 1px solid #e2e8f0;
}

.header-content {
  text-align: left;
}

.page-title {
  font-size: 2rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 8px 0;
  line-height: 1.2;
}

.page-description {
  font-size: 1rem;
  color: #718096;
  margin: 0;
  line-height: 1.5;
}

.activities-section {
  background: white;
  border-radius: 24px;
  padding: 40px;
  margin-bottom: 40px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.activities-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 30px;
}

.activity-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  height: 580px;
  display: flex;
  flex-direction: column;
}

.card-image-wrapper {
  position: relative;
  height: 240px;
  overflow: hidden;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-content {
  padding: 25px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 15px 0;
  line-height: 1.4;
}

.card-description {
  color: #4a5568;
  line-height: 1.6;
  margin: 0 0 20px 0;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 5;
  -webkit-box-orient: vertical;
  cursor: pointer;
}

.card-details {
  margin-bottom: 20px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 0.9rem;
}

.detail-label {
  color: #718096;
  font-weight: 500;
}

.detail-value {
  color: #2d3748;
  font-weight: 600;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.empty-illustration {
  margin-bottom: 30px;
}

.empty-icon {
  font-size: 5rem;
  color: #cbd5e0;
}

.empty-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #4a5568;
  margin: 0 0 12px 0;
}

.empty-text {
  font-size: 1rem;
  color: #718096;
  margin: 0;
}

.dialog-content {
  padding: 20px 0;
}

.activity-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f7fafc;
}

.activity-title {
  font-size: 1.8rem;
  font-weight: 700;
  color: #2d3748;
  margin: 0 0 15px 0;
}

.activity-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.meta-label {
  color: #718096;
  font-weight: 500;
  min-width: 80px;
}

.meta-value {
  color: #2d3748;
  font-weight: 600;
}

.activity-content {
  max-height: 400px;
  overflow-y: auto;
}

.rich-content {
  line-height: 1.8;
  font-size: 16px;
  color: #4a5568;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}

.register-content {
  padding: 20px 0;
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-tip {
  color: #718096;
  font-size: 1rem;
  margin: 0;
}

.register-form {
  margin-top: 20px;
}

.register-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}
</style>
-->
