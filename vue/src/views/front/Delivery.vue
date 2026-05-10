<script setup>
import {ref, reactive, onMounted} from 'vue'
import {useRouter} from 'vue-router'
import {Search, Back, MoreFilled} from '@element-plus/icons-vue'
import request from '../../utils/request'
import { tr } from '@/i18n'

const router = useRouter()

const items = ref([])
const types = ref([])
const searchForm = reactive({
  keyword: '',
  typeId: 0,
})

const pageNum = ref(1)
const pageSize = ref(8)
const total = ref(0)

const load = () => {
  request.get("/delivery/front/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
      typeId: searchForm.typeId,
    }
  }).then(res => {
    if (res.data) {
      items.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  })
}

const loadType = () => {
  request.get("/type").then(res => {
    types.value = res.data
  })
}

const changeType = (id) => {
  searchForm.typeId = id
  pageNum.value = 1
  load()
}

const handleSizeChange = (newSize) => {
  pageSize.value = newSize
  load()
}

const handleCurrentChange = (newPage) => {
  pageNum.value = newPage
  load()
}

const reset = () => {
  searchForm.keyword = ''
  searchForm.typeId = 0
  load()
}

const handleDeliveryClick = (id) => {
  router.push(`/front/deliveryDetail?id=${id}`)
}

onMounted(() => {
  load()
  loadType()
})
</script>

<template>
  <div class="home-container">
    <div class="main-layout">
      <div class="left-sidebar">
        <div class="filter-section">
          <div class="category-header">
            <span class="category-label">{{ $tr('Category') }}</span>
          </div>

          <div class="category-tags">
            <button
                class="category-tag"
                :class="{ active: searchForm.typeId === 0 }"
                @click="changeType(0)"
            >
              {{ $tr('All') }}
            </button>
            <button
                v-for="item in types"
                :key="item.id"
                class="category-tag"
                :class="{ active: searchForm.typeId === item.id }"
                @click="changeType(item.id)"
            >
              {{ item.name }}
            </button>
          </div>

          <div class="search-container">
            <div class="search-wrapper">
              <Search class="search-icon"/>
              <input
                  v-model="searchForm.keyword"
                  :placeholder="$tr('Search...')"
                  class="search-input"
                  @keyup.enter="load"
              />
            </div>
            <button class="search-btn" @click="load">
              <el-icon>
                <Search/>
              </el-icon>
              {{ $tr('Search') }}
            </button>
            <button class="reset-btn" @click="reset">
              <el-icon>
                <Back/>
              </el-icon>
              {{ $tr('Reset') }}
            </button>
          </div>
        </div>
      </div>

      <div class="right-content">
        <div class="deliverys-section">
          <div class="deliverys-header">
            <h2 class="deliverys-title">{{ $tr('Delivery Staff List') }}</h2>
            <span class="deliverys-count">{{ $tr('Total') }} {{ total }} {{ $tr('Delivery Staff') }}</span>
          </div>

          <div v-if="items.length > 0" class="deliverys-grid">
            <div
                v-for="item in items"
                :key="item.id"
                class="delivery-card"
                @click="handleDeliveryClick(item.id)"
            >
              <div class="delivery-image-container">
                <img :src="item.img" :alt="item.name" class="delivery-image"/>
              </div>
              <div class="delivery-content">
                <h3 class="delivery-title">{{ item.name }}</h3>
              </div>
            </div>
          </div>

          <div v-else class="empty-state">
            <el-empty v-if="items.length === 0" :description="$tr('No delivery staff found matching the criteria')"></el-empty>
          </div>

          <div class="pagination-container" v-if="total > 0">
            <el-pagination
                background
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="pageNum"
                :page-sizes="[8, 12, 16, 20]"
                :page-size="pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total">
            </el-pagination>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  min-height: 100vh;
  background: #f8f9fa;
}

.main-layout {
  display: flex;
  gap: 30px;
  align-items: flex-start;
}

.left-sidebar {
  width: 320px;
  flex-shrink: 0;
  position: sticky;
  top: 20px;
}

.right-content {
  flex: 1;
  min-width: 0;
}

.filter-section {
  background: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.category-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f1f5f9;
}

.category-icon {
  width: 24px;
  height: 24px;
  color: #667eea;
}

.category-label {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2d3748;
}

.category-tags {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 30px;
}

.category-tag {
  padding: 12px 20px;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  background: white;
  color: #4a5568;
  font-weight: 500;
  cursor: pointer;
  text-align: left;
  width: 100%;
}

.category-tag.active {
  background: #2c3e50;
  border-color: transparent;
  color: white;
  box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
}

.search-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.search-wrapper {
  position: relative;
}

.search-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  color: #a0aec0;
}

.search-input {
  width: 100%;
  padding: 15px 15px 15px 50px;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  font-size: 1rem;
  outline: none;
  background: #f7fafc;
  box-sizing: border-box;
}

.search-btn, .reset-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 20px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  width: 100%;
}

.search-btn {
  background: #3498db;
  color: white;
}

.reset-btn {
  background: #f7fafc;
  color: #4a5568;
  border: 2px solid #e2e8f0;
}

.deliverys-section {
  background: white;
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.deliverys-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 30px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f1f5f9;
}

.deliverys-title {
  font-size: 2rem;
  font-weight: 700;
  color: #2d3748;
  margin: 0;
}

.deliverys-count {
  font-size: 1rem;
  color: #718096;
  background: #f7fafc;
  padding: 8px 16px;
  border-radius: 20px;
}

.deliverys-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.delivery-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  cursor: pointer;
}

.delivery-image-container {
  position: relative;
  height: 320px;
  overflow: hidden;
}

.delivery-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.delivery-content {
  padding: 25px;
}

.delivery-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.pagination-container {
  margin-top: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>





<!--
<script setup>
import {ref, reactive, onMounted} from 'vue'
import {useRouter} from 'vue-router'
import {Search, Back, MoreFilled} from '@element-plus/icons-vue'
import request from '../../utils/request'

const router = useRouter()

const items = ref([])
const types = ref([])
const searchForm = reactive({
  keyword: '',
  typeId: 0,
})

const pageNum = ref(1)
const pageSize = ref(8)
const total = ref(0)

const load = () => {
  request.get("/delivery/front/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
      typeId: searchForm.typeId,
    }
  }).then(res => {
    if (res.data) {
      items.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  })
}

const loadType = () => {
  request.get("/type").then(res => {
    types.value = res.data
  })
}

const changeType = (id) => {
  searchForm.typeId = id
  pageNum.value = 1
  load()
}

const handleSizeChange = (newSize) => {
  pageSize.value = newSize
  load()
}

const handleCurrentChange = (newPage) => {
  pageNum.value = newPage
  load()
}

const reset = () => {
  searchForm.keyword = ''
  searchForm.typeId = 0
  load()
}

const handleDeliveryClick = (id) => {
  router.push(`/front/deliveryDetail?id=${id}`)
}

onMounted(() => {
  load()
  loadType()
})
</script>

<template>
  <div class="home-container">
    <div class="main-layout">
      <div class="left-sidebar">
        <div class="filter-section">
          <div class="category-header">
            <Filter class="category-icon"/>
            <el-icon>
              <MoreFilled/>
            </el-icon>
            <span class="category-label">分类</span>
          </div>

          <div class="category-tags">
            <button
                class="category-tag"
                :class="{ active: searchForm.typeId === 0 }"
                @click="changeType(0)"
            >
              全部
            </button>
            <button
                v-for="item in types"
                :key="item.id"
                class="category-tag"
                :class="{ active: searchForm.typeId === item.id }"
                @click="changeType(item.id)"
            >
              {{ item.name }}
            </button>
          </div>

          <div class="search-container">
            <div class="search-wrapper">
              <Search class="search-icon"/>
              <input
                  v-model="searchForm.keyword"
                  placeholder="搜索..."
                  class="search-input"
                  @keyup.enter="load"
              />
            </div>
            <button class="search-btn" @click="load">
              <el-icon>
                <Search/>
              </el-icon>
              搜索
            </button>
            <button class="reset-btn" @click="reset">
              <el-icon>
                <Back/>
              </el-icon>
              重置
            </button>
          </div>
        </div>
      </div>

      <div class="right-content">
        <div class="deliverys-section">
          <div class="deliverys-header">
            <h2 class="deliverys-title">配送员列表</h2>
            <span class="deliverys-count">共 {{ total }} 本图书</span>
          </div>

          <div v-if="items.length > 0" class="deliverys-grid">
            <div
                v-for="item in items"
                :key="item.id"
                class="delivery-card"
                @click="handleDeliveryClick(item.id)"
            >
              <div class="delivery-image-container">
                <img :src="item.img" :alt="item.name" class="delivery-image"/>
              </div>
              <div class="delivery-content">
                <h3 class="delivery-title">{{ item.name }}</h3>
              </div>
            </div>
          </div>

          <div v-else class="empty-state">
            <el-empty v-if="items.length === 0" description="暂无符合条件的配送员信息"></el-empty>
          </div>

          <div class="pagination-container" v-if="total > 0">
            <el-pagination
                background
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="pageNum"
                :page-sizes="[8, 12, 16, 20]"
                :page-size="pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total">
            </el-pagination>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  min-height: 100vh;
  background: #f8f9fa;
}

.main-layout {
  display: flex;
  gap: 30px;
  align-items: flex-start;
}

.left-sidebar {
  width: 320px;
  flex-shrink: 0;
  position: sticky;
  top: 20px;
}

.right-content {
  flex: 1;
  min-width: 0;
}

.filter-section {
  background: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.category-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f1f5f9;
}

.category-icon {
  width: 24px;
  height: 24px;
  color: #667eea;
}

.category-label {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2d3748;
}

.category-tags {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 30px;
}

.category-tag {
  padding: 12px 20px;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  background: white;
  color: #4a5568;
  font-weight: 500;
  cursor: pointer;
  text-align: left;
  width: 100%;
}

.category-tag.active {
  background: #2c3e50;
  border-color: transparent;
  color: white;
  box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
}

.search-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.search-wrapper {
  position: relative;
}

.search-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  width: 20px;
  height: 20px;
  color: #a0aec0;
}

.search-input {
  width: 100%;
  padding: 15px 15px 15px 50px;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  font-size: 1rem;
  outline: none;
  background: #f7fafc;
  box-sizing: border-box;
}

.search-btn, .reset-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 20px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  width: 100%;
}

.search-btn {
  background: #3498db;
  color: white;
}

.reset-btn {
  background: #f7fafc;
  color: #4a5568;
  border: 2px solid #e2e8f0;
}

.deliverys-section {
  background: white;
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.deliverys-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 30px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f1f5f9;
}

.deliverys-title {
  font-size: 2rem;
  font-weight: 700;
  color: #2d3748;
  margin: 0;
}

.deliverys-count {
  font-size: 1rem;
  color: #718096;
  background: #f7fafc;
  padding: 8px 16px;
  border-radius: 20px;
}

.deliverys-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.delivery-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  cursor: pointer;
}

.delivery-image-container {
  position: relative;
  height: 320px;
  overflow: hidden;
}

.delivery-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.delivery-content {
  padding: 25px;
}

.delivery-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.pagination-container {
  margin-top: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>-->
