<script setup>
import { computed, ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'
import { t, tr } from '@/i18n'

// 路由实例
const router = useRouter()

// 表单引用
const passFormRef = ref(null)

// 表单数据
const form = reactive({
  password: '',
  newPassword: '',
  confirmPassword: ''
})

// 表单验证规则
const rules = computed(() => ({
  password: [
    {required: true, message: t('validation.currentPasswordRequired'), trigger: 'blur'},
    {min: 3, max: 10, message: t('validation.length3to10'), trigger: 'blur'}
  ],
  newPassword: [
    {required: true, message: t('validation.newPasswordRequired'), trigger: 'blur'},
    {min: 3, max: 10, message: t('validation.length3to10'), trigger: 'blur'}
  ],
  confirmPassword: [
    {required: true, message: t('validation.confirmNewPasswordRequired'), trigger: 'blur'},
    {min: 3, max: 10, message: t('validation.length3to10'), trigger: 'blur'}
  ]
}))

// 保存方法
const save = () => {
  // 表单校验合法
  passFormRef.value.validate((valid) => {
    // 如果合法
    if (valid) {
      // 检查两次密码是否一致
      if (form.newPassword !== form.confirmPassword) {
        ElMessage.error(tr('The two new passwords do not match'))
        return false
      }

      // 发送请求
      request.post('/web/password', form).then(res => {
        if (res.code === '200') {
          ElMessage.success(tr('Password changed successfully'))
          localStorage.removeItem('account')
          router.push('/login')
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}
</script>

<template>
  <div class="password-container">

    <el-card class="password-card">
      <el-form
          ref="passFormRef"
          :model="form"
          :rules="rules"
          label-width="120px"
      >
        <el-form-item :label="$tr('Old Password')" prop="password">
          <el-input
              v-model="form.password"
              :placeholder="$tr('Please enter current password')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item :label="$tr('New Password')" prop="newPassword">
          <el-input
              v-model="form.newPassword"
              :placeholder="$tr('Please enter new password')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item :label="$tr('Confirm Again')" prop="confirmPassword">
          <el-input
              v-model="form.confirmPassword"
              :placeholder="$tr('Please confirm new password')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="save">{{ $tr('Confirm Change') }}</el-button>
          <el-button @click="passFormRef.resetFields()">{{ $tr('Reset') }}</el-button>
        </el-form-item>
      </el-form>

      <div class="password-tips">
        <p>{{ $tr('Password Security Tips:') }}</p>
        <ul>
          <li>{{ $tr('Password must be at least 3 characters long') }}</li>
          <li>{{ $tr('It is recommended to use a combination of letters, numbers and special characters') }}</li>
          <li>{{ $tr('Changing your password regularly can improve account security') }}</li>
        </ul>
      </div>
    </el-card>
  </div>
</template>

<style lang="scss" scoped>
.password-container {
  padding: 20px;

  .password-card {
    max-width: 600px;
    margin: 0 auto;

    .el-form {
      margin-top: 20px;
    }

    .password-tips {
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px dashed #eee;

      p {
        font-size: 14px;
        color: #606266;
        margin-bottom: 10px;
        display: flex;
        align-items: center;

      }

      ul {
        padding-left: 20px;
        margin: 0;

        li {
          font-size: 13px;
          color: #909399;
          line-height: 1.8;
        }
      }
    }
  }
}
</style>






