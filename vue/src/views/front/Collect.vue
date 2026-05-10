<!--
<script setup>
import {ref, onMounted} from 'vue'
import {ElMessage} from 'element-plus'
import {Search, Back, MoreFilled} from '@element-plus/icons-vue'
import request from '../../utils/request'
import {useRouter} from "vue-router";
import { tr } from '@/i18n'

const router = useRouter()
const items = ref([])
const keyword = ref('')
const pageNum = ref(1)
const pageSize = ref(8)
const total = ref(0)
const imgs = ref([
  "https://demosc.chinaz.net/Files/DownLoad/webjs1/201907/jiaoben6919/img/lunbo1.jpg",
  "https://pic2.zhimg.com/v2-d0e775ca666f3f2b049de8a88fc4aba5_r.jpg",
  "https://ts1.cn.mm.bing.net/th/id/R-C.bd3b631bde86bfdd75720dd544e3d32f?rik=IxwYcffHn4f3tQ&riu=http%3a%2f%2fimg.zcool.cn%2fcommunity%2f01f6625768ad220000012e7e78a909.jpg&ehk=TjQyehtL0i1DZVMZkrwUyBShDQclVX2ACNRZTTDKbzk%3d&risl=&pid=ImgRaw&r=0"
])

const load = () => {
  request.get("/delivery/collect/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: keyword.value,
    }
  }).then(res => {
    if (res.code === '200') {
      items.value = res.data?.records || []
      total.value = res.data?.total || 0
    }
  }).catch(error => {
    console.error('加载收藏数据失败:', error)
  })
}

const handleSizeChange = (size) => {
  pageSize.value = size
  load()
}

const handleCurrentChange = (current) => {
  pageNum.value = current
  load()
}

const cancel = (id) => {
  request.delete('/collect/' + id).then(res => {
    if (res.code === '200') {
      ElMessage.success('取消收藏成功')
      load()
    }
  }).catch(error => {
    console.error('取消收藏失败:', error)
    ElMessage.error('取消收藏失败，请稍后重试')
  })
}

const reset = () => {
  keyword.value = ''
  load()
}

onMounted(() => {
  load()
})
</script>

<template>
  <div class="collect-container">
    <div class="collect-section">
      <div class="collect-content">
        <h1 class="collect-title">
          我的收藏
        </h1>
        <p class="collect-subtitle">珍藏您喜爱的图书</p>
      </div>
    </div>

    <div class="search-section">
      <div class="search-card">
        <div class="search-content">
          <div class="search-wrapper">
            <el-input
                v-model="keyword"
                placeholder="搜索收藏的图书..."
                :prefix-icon="Search"
                clearable
                @keyup.enter="load"
            />
          </div>
          <div class="search-buttons">
            <el-button type="primary" @click="load">
              <el-icon>
                <Search/>
              </el-icon>
              {{ $tr('搜索') }}
            </el-button>
            <el-button @click="reset">{{ $tr('重置') }}</el-button>
          </div>
        </div>
      </div>
    </div>

    <div class="main-content">
      <div class="content-left">
        <div class="deliverys-section">
          <div class="deliverys-grid">
            <div
                v-for="(item, index) in items"
                :key="item.id"
                class="delivery-card"
            >
              <div class="delivery-image-wrapper" @click="router.push('/front/deliveryDetail?id=' + item.id)">
                <img
                    :src="item.img"
                    :alt="item.name"
                    class="delivery-image"
                />
                <div class="delivery-overlay">
                  <el-icon class="overlay-icon">
                    <Search/>
                  </el-icon>
                </div>
              </div>

              <div class="delivery-content">
                <h3 class="delivery-title">{{ item.name }}</h3>
                <p class="delivery-author">{{ item.author }}</p>

                <div class="delivery-actions">
                  <el-popconfirm
                      title="确定要取消收藏这本书吗？"
                      confirm-button-text="确定"
                      cancel-button-text="取消"
                      @confirm="cancel(item.id)"
                      width="200"
                  >
                    <template #reference>
                      <el-button type="danger">
                        <el-icon>
                          <Back/>
                        </el-icon>
                        取消收藏
                      </el-button>
                    </template>
                  </el-popconfirm>
                </div>
              </div>
            </div>
          </div>

          <div v-if="items.length === 0" class="empty-state">
            <el-empty v-if="items.length === 0" description="暂无符合条件的收藏图书"></el-empty>
          </div>

          <div v-if="items.length > 0" class="pagination-section">
            <el-pagination
                v-model:current-page="pageNum"
                v-model:page-size="pageSize"
                :page-sizes="[8, 16, 24, 32]"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>

      <div class="content-right">
        <div class="carousel-section">
          <div class="carousel-card">
            <el-carousel height="320px" :interval="8000">
              <el-carousel-item v-for="(img, index) in imgs" :key="index">
                <div class="carousel-item">
                  <img :src="img" class="carousel-image"/>
                </div>
              </el-carousel-item>
            </el-carousel>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.collect-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  min-height: 100vh;
  background: #f8f9fa;
}

.collect-section {
  background-color: #ffffff;
  border-radius: 20px;
  padding: 60px 40px;
  margin: 20px 0 40px 0;
  text-align: center;
  color: white;
  position: relative;
  overflow: hidden;
}

.collect-content {
  position: relative;
  z-index: 2;
}

.collect-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  font-size: 2.5rem;
  font-weight: 700;
  color: #2d3748;
  margin: 0 0 12px 0;
}

.collect-subtitle {
  font-size: 1.2rem;
  color: black;
  margin: 0;
  opacity: 0.9;
}

.search-section {
  margin-bottom: 30px;
}

.search-card {
  background: white;
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.search-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.search-wrapper {
  flex: 1;
  max-width: 400px;
}

.search-buttons {
  display: flex;
  gap: 12px;
}

.main-content {
  display: flex;
  gap: 30px;
  margin-bottom: 40px;
}

.content-left {
  flex: 1;
}

.content-right {
  width: 350px;
}

.deliverys-section {
  background: white;
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.deliverys-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 25px;
  margin-bottom: 40px;
}

.delivery-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  height: 420px;
  display: flex;
  flex-direction: column;
}

.delivery-image-wrapper {
  position: relative;
  height: 240px;
  overflow: hidden;
  cursor: pointer;
}

.delivery-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.delivery-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(44, 62, 80, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
}

.overlay-icon {
  font-size: 2.5rem;
  color: white;
}

.delivery-content {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.delivery-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2d3748;
  margin: 0 0 8px 0;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.delivery-author {
  color: #718096;
  font-size: 0.9rem;
  margin: 0 0 20px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.delivery-actions {
  margin-top: auto;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.pagination-section {
  display: flex;
  justify-content: center;
  padding-top: 20px;
  border-top: 2px solid #f7fafc;
}

.carousel-section {
  position: sticky;
  top: 20px;
}

.carousel-card {
  background: white;
  border-radius: 20px;
  padding: 25px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

.carousel-item {
  position: relative;
  height: 100%;
  border-radius: 16px;
  overflow: hidden;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>-->
