<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRoute,useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Back, CirclePlus } from '@element-plus/icons-vue'
import request from '../../utils/request'
import { tr } from '@/i18n'

const account = ref(localStorage.getItem('account') ? JSON.parse(localStorage.getItem('account')) : {})
const route = useRoute()
const router = useRouter()
const id = route.query.id
const item = ref({})
const form = ref({})
const dialog = ref(false)
const ruleFormRef = ref(null)
const commentItemId = route.query.id
const replyVisible = ref(false)
const comments = ref([])
const commentForm = ref({})

const rules = computed(() => ({
  endDate: [
    { required: true, message: tr('Please select expected completion time'), trigger: 'blur' }
  ]
}))

const load = () => {
  request.get('/delivery/' + id).then(res => {
    item.value = res.data
  }).catch(error => {
    console.error('加载详情失败:', error)
  })
}

const loadComment = () => {
  request.get("/comment/tree/" + commentItemId).then(res => {
    comments.value = res.data
  })
}

const saveComment = () => {
  if (!account.value.id) {
    ElMessage.warning(tr('Please log in to perform this operation'))
    return
  }
  commentForm.value.itemId = commentItemId
  if (commentForm.value.contentReply) {
    commentForm.value.content = commentForm.value.contentReply
  }
  request.post("/comment", commentForm.value).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Remark added successfully'))
      commentForm.value = {}
      loadComment()
    } else {
      ElMessage.error(tr('Failed to add remark'))
    }
  })
}

const delComment = (id) => {
  request.delete("/comment/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Delete successful'))
      loadComment()
    } else {
      ElMessage.error(tr('Delete failed'))
    }
  })
}

const handleReply = (pid) => {
  commentForm.value = { pid: pid }
  replyVisible.value = true
}

const cancelReply = () => {
  commentForm.value = { pid: '' }
  replyVisible.value = false
}

const send = () => {
  form.value.deliveryId = id

  ruleFormRef.value.validate((valid) => {
    if (valid) {
      request.post("/workRecord", form.value).then(res => {
        if (res.code === '200') {
          ElMessage.success(tr('Successful'))
          dialog.value = false
          load()
        } else {
          ElMessage.error(res.msg)
        }
      }).catch(error => {
        console.error('失败:', error)
        ElMessage.error(tr('Failed, please try again later'))
      })
    }
  })
}

onMounted(() => {
  load()
  loadComment()
})
</script>

<template>
  <div class="detail-container">
    <div class="back-section">
      <el-button type="info" @click="router.go(-1)">
        <el-icon>
          <Back />
        </el-icon>
        {{ $tr('Back') }}
      </el-button>
    </div>

    <div class="delivery-detail-card">
      <div class="delivery-header">
        <h1 class="delivery-title">{{ item.name }}</h1>
      </div>

      <div class="delivery-content">
        <div class="delivery-image-section">
          <div class="image-wrapper">
            <img :src="item.img" :alt="item.name" class="delivery-image" />
          </div>
        </div>

        <div class="delivery-info-section">
          <div class="info-grid">
            <div class="info-item">
              <span class="info-value">{{ item.author }}</span>
            </div>
            <!--            <div class="info-item">-->
            <!--              <span class="info-label">所属区域:</span>-->
            <!--              <span class="info-value">{{ item.press }}</span>-->
            <!--            </div>-->
            <div class="info-item">
              <span class="info-label">{{ $tr('Phone:') }}</span>
              <span class="info-value">{{ item.isbn }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">{{ $tr('Join Date:') }}</span>
              <span class="info-value">{{ item.date }}</span>
            </div>
<!--            <div class="info-item">-->
<!--              <span class="info-label">Task Count:</span>-->
<!--              <span class="info-value">{{ item.num }}</span>-->
<!--            </div>-->
            <div class="info-item full-width">
              <span class="info-label">{{ $tr('Rating:') }}</span>
              <span class="info-value description">{{ item.info }}</span>
            </div>
          </div>

          <div class="action-buttons">
            <el-button
                v-if="item.num > 0"
                type="primary"
                @click="dialog = true"
            >
              <el-icon>
                <CirclePlus />
              </el-icon>
              {{ $tr('At work') }}
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!--    <div class="bottom-section">-->
    <!--      <div class="bottom-left">-->
    <!--        <h2>内容概述</h2>-->
    <!--        <div class="rich-content" v-html="item.content"></div>-->
    <!--      </div>-->

    <div class="bottom-right">
      <div class="comment-container">
        <div class="comment-header">
          <div class="comment-title">
            {{ $tr('Remarks') }}({{ comments.length }})
          </div>
          <div class="comment-send-warp">
            <el-input
                type="textarea"
                :rows="4"
                v-model="commentForm.content"
                :placeholder="$tr('Please enter remark information')"
            />
            <el-button
                :disabled="!commentForm.content"
                type="primary"
                @click="saveComment"
                class="comment-send-btn"
            >
              {{ $tr('Add Remark') }}
            </el-button>
          </div>
        </div>
        <div class="comment-warp">
          <div v-for="item in comments" :key="item.id">
            <div class="comment-item">
              <div class="comment-avatar">
                <el-image :src="item.avatarUrl"></el-image>
              </div>
              <div class="comment-info">
                <div class="comment-name">{{ item.nickname }}</div>
                <div class="comment-content">{{ item.content }}</div>
                <div class="comment-other">
                  <div class="comment-time">
                    <i class="el-icon-time"></i><span>{{ item.time }}</span>
                  </div>
                  <div>
                    <el-button link @click="handleReply(item.id)">{{ $tr('Reply') }}</el-button>
                    <el-button
                        link
                        @click="delComment(item.id)"
                        v-if="account.id === item.userId || account.role === 'ROLE_ADMIN'"
                    >
                      {{ $tr('Delete') }}
                    </el-button>
                  </div>
                </div>
                <div class="comment-reply" v-if="commentForm.pid === item.id && replyVisible">
                  <div>
                    <el-input v-model="commentForm.contentReply" autocomplete="off"></el-input>
                  </div>
                  <div class="comment-reply-button">
                    <el-button size="small" type="primary" @click="saveComment">{{ $tr('Confirm') }}</el-button>
                    <el-button size="small" type="danger" @click="cancelReply">{{ $tr('Cancel') }}</el-button>
                  </div>
                </div>
              </div>
            </div>
            <template v-if="item.children.length">
              <div v-for="subItem in item.children" class="comment-item comment-item-reply" :key="subItem.id">
                <div class="comment-avatar">
                  <el-image :src="subItem.avatarUrl" />
                </div>
                <div class="comment-info">
                  <div class="comment-name">{{ subItem.nickname }} <span v-if="subItem.pid">{{ $tr('Reply') }} @ {{ subItem.pnickname }}</span></div>
                  <div class="comment-content">{{ subItem.content }}</div>
                  <div class="comment-other">
                    <div class="comment-time">
                      <i class="el-icon-time"></i><span>{{ subItem.time }}</span>
                    </div>
                    <div>
                      <el-button link @click="handleReply(subItem.id)">{{ $tr('Reply') }}</el-button>
                      <el-button
                          link
                          @click="delComment(subItem.id)"
                          v-if="account.id === subItem.userId || account.role === 'ROLE_ADMIN'"
                      >
                        {{ $tr('Delete') }}
                      </el-button>
                    </div>
                  </div>
                  <div class="comment-reply" v-if="commentForm.pid === subItem.id && replyVisible">
                    <div>
                      <el-input v-model="commentForm.contentReply" autocomplete="off"></el-input>
                    </div>
                    <div class="comment-reply-button">
                      <el-button size="small" type="primary" @click="saveComment">{{ $tr('Confirm') }}</el-button>
                      <el-button size="small" type="danger" @click="cancelReply">{{ $tr('Cancel') }}</el-button>
                    </div>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>

  <el-dialog
      v-model="dialog"
      :title="$tr('Delivery Information')"
      width="30%"
      :close-on-click-modal="false"
  >
    <el-form
        :model="form"
        :rules="rules"
        ref="ruleFormRef"
        label-width="140px"
    >
      <el-form-item prop="endDate" :label="$tr('Expected Completion Time')">
        <el-date-picker
            v-model="form.endDate"
            type="date"
            value-format="YYYY-MM-DD"
            :placeholder="$tr('Select date')"
            style="width: 100%"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="dialog = false">{{ $tr('Cancel') }}</el-button>
        <el-button type="primary" @click="send">{{ $tr('Confirm') }}</el-button>
      </div>
    </template>
  </el-dialog>

</template>

<style scoped>
.detail-container {
  width: 70%;
  margin: 0 auto;
  padding: 20px 0;
  background: #f8f9fa;
  min-height: 100vh;
}

.back-section {
  margin-bottom: 20px;
  text-align: right;
}

.delivery-detail-card {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
}

.delivery-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f0f0f0;
}

.delivery-title {
  font-size: 2rem;
  font-weight: 700;
  color: #303133;
  margin: 0;
}

.delivery-content {
  display: flex;
  gap: 30px;
}

.delivery-image-section {
  width: 30%;
}

.image-wrapper {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.delivery-image {
  width: 100%;
  height: 350px;
  object-fit: cover;
}

.delivery-info-section {
  flex: 1;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 20px;
  margin-bottom: 30px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 15px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-label {
  font-weight: 600;
  color: #606266;
  min-width: 100px;
  flex-shrink: 0;
}

.info-value {
  color: #303133;
  line-height: 1.6;
}

.info-value.description {
  text-align: justify;
}

.action-buttons {
  display: flex;
  gap: 15px;
}

.bottom-section {
  display: flex;
  gap: 30px;
  margin-bottom: 30px;
  align-items: flex-start;
}

.bottom-left {
  width: 35%;
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.rich-content {
  line-height: 1.8;
  font-size: 16px;
  color: #333;
}

.bottom-right {
  flex: 1;
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.comment-container {
  margin-top: 30px;
}

.comment-header {
  margin: 10px 0;
}

.comment-title {
  border-bottom: 2px solid #ccc;
  padding: 10px 0;
  font-size: 20px;
  margin-bottom: 10px;
  font-weight: 600;
}

.comment-send-warp {
  position: relative;
}

.comment-send-btn {
  position: absolute;
  bottom: 15px;
  right: 30px;
}

.comment-reply {
  display: flex;
  margin-top: 10px;
}

.comment-reply-button {
  margin-left: 10px;
}

.comment-item {
  display: flex;
  width: 100%;
  border-bottom: 1px solid #eee;
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.comment-item-reply {
  margin-left: 22px;
  margin-right: -30px;
  transform: scale(0.9);
  padding-left: 10px;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.comment-item .comment-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 20px;
}

.comment-info {
  flex: 1;
}

.comment-info .comment-name {
  color: #8c939d;
  font-size: 14px;
}

.comment-info .comment-content {
  margin-top: 4px;
  font-size: 16px;
  color: #666;
  text-align: justify;
}

.comment-info .comment-other {
  display: flex;
  align-items: center;
  font-size: 14px;
  margin-top: 2px;
  color: #9499A0;
}

.comment-info .comment-other .comment-time {
  margin-right: 20px;
  min-width: 170px;
}

.comment-info .comment-other .comment-time i {
  margin-right: 4px;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}
</style>





<!--

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute,useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Back, Star, CirclePlus } from '@element-plus/icons-vue'
import request from '../../utils/request'

const account = ref(localStorage.getItem('account') ? JSON.parse(localStorage.getItem('account')) : {})
const route = useRoute()
const router = useRouter()
const id = route.query.id
const item = ref({})
const form = ref({})
const dialog = ref(false)
const ruleFormRef = ref(null)
const commentItemId = route.query.id
const replyVisible = ref(false)
const comments = ref([])
const commentForm = ref({})

const rules = {
  endDate: [
    { required: true, message: '请选择预计完成时间', trigger: 'blur' }
  ]
}

const load = () => {
  request.get('/delivery/' + id).then(res => {
    item.value = res.data
  }).catch(error => {
    console.error('加载详情失败:', error)
  })
}

const loadComment = () => {
  request.get("/comment/tree/" + commentItemId).then(res => {
    comments.value = res.data
  })
}

const saveComment = () => {
  if (!account.value.id) {
    ElMessage.warning("请登录后操作")
    return
  }
  commentForm.value.itemId = commentItemId
  if (commentForm.value.contentReply) {
    commentForm.value.content = commentForm.value.contentReply
  }
  request.post("/comment", commentForm.value).then(res => {
    if (res.code === '200') {
      ElMessage.success('评论成功')
      commentForm.value = {}
      loadComment()
    } else {
      ElMessage.error('评论失败')
    }
  })
}

const delComment = (id) => {
  request.delete("/comment/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success("删除成功")
      loadComment()
    } else {
      ElMessage.error("删除失败")
    }
  })
}

const handleReply = (pid) => {
  commentForm.value = { pid: pid }
  replyVisible.value = true
}

const cancelReply = () => {
  commentForm.value = { pid: '' }
  replyVisible.value = false
}

const collect = () => {
  const data = {
    itemId: id
  }
  request.post('/collect', data).then(res => {
    if (res.code === '200') {
      ElMessage.success('收藏成功')
    } else {
      ElMessage.error(res.msg)
    }
  }).catch(error => {
    console.error('收藏失败:', error)
    ElMessage.error('收藏失败，请稍后重试')
  })
}

const send = () => {
  form.value.deliveryId = id

  ruleFormRef.value.validate((valid) => {
    if (valid) {
      request.post("/workRecord", form.value).then(res => {
        if (res.code === '200') {
          ElMessage.success("成功")
          dialog.value = false
          load()
        } else {
          ElMessage.error(res.msg)
        }
      }).catch(error => {
        console.error('失败:', error)
        ElMessage.error('失败，请稍后重试')
      })
    }
  })
}

onMounted(() => {
  load()
  loadComment()
})
</script>

<template>
  <div class="detail-container">
    <div class="back-section">
      <el-button type="info" @click="router.go(-1)">
        <el-icon>
          <Back />
        </el-icon>
        返回
      </el-button>
    </div>

    <div class="delivery-detail-card">
      <div class="delivery-header">
        <h1 class="delivery-title">{{ item.name }}</h1>
      </div>

      <div class="delivery-content">
        <div class="delivery-image-section">
          <div class="image-wrapper">
            <img :src="item.img" :alt="item.name" class="delivery-image" />
          </div>
        </div>

        <div class="delivery-info-section">
          <div class="info-grid">
            <div class="info-item">

              <span class="info-value">{{ item.author }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">所属区域:</span>
              <span class="info-value">{{ item.press }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">电话:</span>
              <span class="info-value">{{ item.isbn }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">入职日期:</span>
              <span class="info-value">{{ item.date }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">任务量:</span>
              <span class="info-value">{{ item.num }}</span>
            </div>
            <div class="info-item full-width">
              <span class="info-label">评分:</span>
              <span class="info-value description">{{ item.info }}</span>
            </div>
          </div>

          <div class="action-buttons">
            <el-button
                v-if="item.num > 0"
                type="primary"
                @click="dialog = true"
            >
              <el-icon>
                <CirclePlus />
              </el-icon>
              点击外出
            </el-button>
            <el-button
                type="warning"
                @click="collect"
            >
              <el-icon>
                <Star />
              </el-icon>
              加入收藏夹
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <div class="bottom-section">
      <div class="bottom-left">
        <h2>内容概述</h2>
        <div class="rich-content" v-html="item.content"></div>
      </div>

      <div class="bottom-right">
        <div class="comment-container">
          <div class="comment-header">
            <div class="comment-title">
              评论({{ comments.length }})
            </div>
            <div class="comment-send-warp">
              <el-input
                  type="textarea"
                  :rows="4"
                  v-model="commentForm.content"
                  placeholder="善语结善缘，恶语伤人心"
              />
              <el-button
                  :disabled="!commentForm.content"
                  type="primary"
                  @click="saveComment"
                  class="comment-send-btn"
              >
                评论
              </el-button>
            </div>
          </div>
          <div class="comment-warp">
            <div v-for="item in comments" :key="item.id">
              <div class="comment-item">
                <div class="comment-avatar">
                  <el-image :src="item.avatarUrl"></el-image>
                </div>
                <div class="comment-info">
                  <div class="comment-name">{{ item.nickname }}</div>
                  <div class="comment-content">{{ item.content }}</div>
                  <div class="comment-other">
                    <div class="comment-time">
                      <i class="el-icon-time"></i><span>{{ item.time }}</span>
                    </div>
                    <div>
                      <el-button link @click="handleReply(item.id)">回复</el-button>
                      <el-button
                          link
                          @click="delComment(item.id)"
                          v-if="account.id === item.userId || account.role === 'ROLE_ADMIN'"
                      >
                        删除
                      </el-button>
                    </div>
                  </div>
                  <div class="comment-reply" v-if="commentForm.pid === item.id && replyVisible">
                    <div>
                      <el-input v-model="commentForm.contentReply" autocomplete="off"></el-input>
                    </div>
                    <div class="comment-reply-button">
                      <el-button size="small" type="primary" @click="saveComment">确 定</el-button>
                      <el-button size="small" type="danger" @click="cancelReply">取 消</el-button>
                    </div>
                  </div>
                </div>
              </div>
              <template v-if="item.children.length">
                <div v-for="subItem in item.children" class="comment-item comment-item-reply" :key="subItem.id">
                  <div class="comment-avatar">
                    <el-image :src="subItem.avatarUrl" />
                  </div>
                  <div class="comment-info">
                    <div class="comment-name">{{ subItem.nickname }} <span v-if="subItem.pid">回复 @ {{ subItem.pnickname }}</span></div>
                    <div class="comment-content">{{ subItem.content }}</div>
                    <div class="comment-other">
                      <div class="comment-time">
                        <i class="el-icon-time"></i><span>{{ subItem.time }}</span>
                      </div>
                      <div>
                        <el-button link @click="handleReply(subItem.id)">回复</el-button>
                        <el-button
                            link
                            @click="delComment(subItem.id)"
                            v-if="account.id === subItem.userId || account.role === 'ROLE_ADMIN'"
                        >
                          删除
                        </el-button>
                      </div>
                    </div>
                    <div class="comment-reply" v-if="commentForm.pid === subItem.id && replyVisible">
                      <div>
                        <el-input v-model="commentForm.contentReply" autocomplete="off"></el-input>
                      </div>
                      <div class="comment-reply-button">
                        <el-button size="small" type="primary" @click="saveComment">确 定</el-button>
                        <el-button size="small" type="danger" @click="cancelReply">取 消</el-button>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
      </div>
    </div>

    <el-dialog
        v-model="dialog"
        title="借阅信息"
        width="30%"
        :close-on-click-modal="false"
    >
      <el-form
          :model="form"
          :rules="rules"
          ref="ruleFormRef"
          label-width="140px"
      >
        <el-form-item prop="endDate" label="预计归还时间">
          <el-date-picker
              v-model="form.endDate"
              type="date"
              value-format="YYYY-MM-DD"
              placeholder="选择日期"
              style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialog = false">取消</el-button>
          <el-button type="primary" @click="send">确定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.detail-container {
  width: 70%;
  margin: 0 auto;
  padding: 20px 0;
  background: #f8f9fa;
  min-height: 100vh;
}

.back-section {
  margin-bottom: 20px;
  text-align: right;
}

.delivery-detail-card {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
}

.delivery-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f0f0f0;
}

.delivery-title {
  font-size: 2rem;
  font-weight: 700;
  color: #303133;
  margin: 0;
}

.delivery-content {
  display: flex;
  gap: 30px;
}

.delivery-image-section {
  width: 30%;
}

.image-wrapper {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.delivery-image {
  width: 100%;
  height: 350px;
  object-fit: cover;
}

.delivery-info-section {
  flex: 1;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 20px;
  margin-bottom: 30px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 15px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-label {
  font-weight: 600;
  color: #606266;
  min-width: 100px;
  flex-shrink: 0;
}

.info-value {
  color: #303133;
  line-height: 1.6;
}

.info-value.description {
  text-align: justify;
}

.action-buttons {
  display: flex;
  gap: 15px;
}

.bottom-section {
  display: flex;
  gap: 30px;
  margin-bottom: 30px;
  align-items: flex-start;
}

.bottom-left {
  width: 35%;
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.rich-content {
  line-height: 1.8;
  font-size: 16px;
  color: #333;
}

.bottom-right {
  flex: 1;
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.comment-container {
  margin-top: 30px;
}

.comment-header {
  margin: 10px 0;
}

.comment-title {
  border-bottom: 2px solid #ccc;
  padding: 10px 0;
  font-size: 20px;
  margin-bottom: 10px;
  font-weight: 600;
}

.comment-send-warp {
  position: relative;
}

.comment-send-btn {
  position: absolute;
  bottom: 15px;
  right: 30px;
}

.comment-reply {
  display: flex;
  margin-top: 10px;
}

.comment-reply-button {
  margin-left: 10px;
}

.comment-item {
  display: flex;
  width: 100%;
  border-bottom: 1px solid #eee;
  padding-bottom: 10px;
  margin-bottom: 20px;
}

.comment-item-reply {
  margin-left: 22px;
  margin-right: -30px;
  transform: scale(0.9);
  padding-left: 10px;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.comment-item .comment-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 20px;
}

.comment-info {
  flex: 1;
}

.comment-info .comment-name {
  color: #8c939d;
  font-size: 14px;
}

.comment-info .comment-content {
  margin-top: 4px;
  font-size: 16px;
  color: #666;
  text-align: justify;
}

.comment-info .comment-other {
  display: flex;
  align-items: center;
  font-size: 14px;
  margin-top: 2px;
  color: #9499A0;
}

.comment-info .comment-other .comment-time {
  margin-right: 20px;
  min-width: 170px;
}

.comment-info .comment-other .comment-time i {
  margin-right: 4px;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  padding: 20px 0;
}
</style>-->
