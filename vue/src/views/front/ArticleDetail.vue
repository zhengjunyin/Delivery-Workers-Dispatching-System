//公告
<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from "@/utils/request.js";
import { tr } from '@/i18n'

const route = useRoute();
const router = useRouter();
const id = route.query.id;
const item = ref({});

const load = () => {
  request.get("/article/" + id).then(res => {
    item.value = res.data;
  });
};

onMounted(() => {
  load();
});
</script>

<template>
  <div class="article-detail-container">
    <div class="article-header">
      <el-button type="info" plain @click="router.go(-1)">{{ $tr('Return') }}</el-button>

      <div class="article-title">
        <h1>{{ item.name }}</h1>
      </div>
      <div class="article-meta">
        <span>Release Time: {{ item.time }}</span>
      </div>
    </div>

    <div class="article-content">
      <div class="rich-content" v-html="item.content"></div>
    </div>
  </div>
</template>

<style scoped>
.article-detail-container {
  color: #666;
  width: 70%;
  margin: 0 auto;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, "Hiragino Sans GB", "Microsoft YaHei", Arial, sans-serif;
}

.article-header {
  margin: 20px 0;
}

.article-title {
  text-align: center;
  margin: 20px 0;
}

.article-title h1 {
  font-size: 28px;
  color: #333;
  margin: 0;
}

.article-meta {
  font-size: 16px;
  margin-top: 5px;
  display: flex;
  justify-content: space-around;
  color: #888;
}

.article-content {
  margin: 30px 0;
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  word-wrap: break-word;
}

.rich-content {
  line-height: 1.8;
  font-size: 16px;
  color: #333;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

</style>