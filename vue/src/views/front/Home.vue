<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Cellphone, Clock } from '@element-plus/icons-vue'
import request from '../../utils/request'
import { tr } from '@/i18n'

const router = useRouter()
const items = ref([])
const banner = ref([])

const handleArticleClick = (id) => {
  router.push(`/front/articleDetail?id=${id}`)
}

const loadData = () => {
  request.get("/article").then(res => {
    items.value = res.data
  })
}

const loadBanners = () => {
  request.get("/banner").then(res => {
    banner.value = res.data
  })
}

onMounted(() => {
  loadData()
  loadBanners()
})
</script>

<template>
  <div class="home-container">
    <div class="carousel-section">
      <el-carousel :interval="4000" type="card" height="400px">
        <el-carousel-item v-for="(item, index) in banner" :key="index">
          <div class="carousel-overlay">
            <div class="carousel-title">
              <h3>{{ item.name }}</h3>
            </div>
          </div>
          <img :src="item.img" class="carousel-image" @click="router.push('/front/deliveryDetail?id='+item.deliveryId)">
        </el-carousel-item>
      </el-carousel>
    </div>

    <div class="content-section">
      <div class="section-header">
        <h2 class="section-title">{{ $tr('Article') }}</h2>
      </div>

      <div class="articles-grid">
        <div
            v-for="item in items"
            :key="item.id"
            class="article-card"
        >
          <div class="article-item">
            <div class="article-image">
              <img :src="item.img" :alt="item.name" />
            </div>
            <div class="article-content">
              <div
                  class="article-title"
                  @click="handleArticleClick(item.id)"
              >
                <span>{{ item.name }}</span>
              </div>
              <div class="article-info">
                <div class="info-item">
                  <el-icon><Cellphone /></el-icon>
                  <span>{{ item.info }}</span>
                </div>
                <div class="info-item">
                  <el-icon><Clock /></el-icon>
                  <span>{{ item.time }}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="divider"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home-container {
  width: 70%;
  margin: 10px auto;
  min-height: 100vh;
}

.carousel-section {
  width: 100%;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.carousel-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  padding: 2rem 1.5rem 1.5rem;
}

.carousel-title h3 {
  color: white;
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
  text-align: center;
}

.content-section {
  margin-top: 2rem;
}

.section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.section-title {
  font-size: 2rem;
  font-weight: bold;
  color: #1f2937;
  margin: 0;
}

.articles-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
}

.article-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.article-item {
  display: flex;
  align-items: center;
  padding: 1rem;
  min-height: 150px;
}

.article-image {
  flex-shrink: 0;
  width: 140px;
  height: 100px;
  margin-right: 1rem;
}

.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 6px;
}

.article-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100px;
}

.article-title {
  cursor: pointer;
  margin-bottom: 0.5rem;
}

.article-title span {
  font-size: 1rem;
  font-weight: bold;
  color: #1f2937;
}

.article-info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #6b7280;
}

.divider {
  height: 1px;
  background: #e5e7eb;
  margin: 0 1rem;
}
</style>