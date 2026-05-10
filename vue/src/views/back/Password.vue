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
        ElMessage.error(tr('两次输入的新密码不相同'))
        return false
      }

      // 发送请求
      request.post('/web/password', form).then(res => {
        if (res.code === '200') {
          ElMessage.success(tr('密码修改成功'))
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
        <el-form-item :label="$tr('原密码')" prop="password">
          <el-input
              v-model="form.password"
              :placeholder="$tr('请输入当前密码')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item :label="$tr('新密码')" prop="newPassword">
          <el-input
              v-model="form.newPassword"
              :placeholder="$tr('请输入新密码')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item :label="$tr('确认新密码')" prop="confirmPassword">
          <el-input
              v-model="form.confirmPassword"
              :placeholder="$tr('请再次输入新密码')"
              autocomplete="off"
              show-password
          ></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="save">{{ $tr('确认修改') }}</el-button>
          <el-button @click="passFormRef.resetFields()">{{ $tr('重置') }}</el-button>
        </el-form-item>
      </el-form>

      <div class="password-tips">
        <p> {{ $tr('密码安全提示：') }}</p>
        <ul>
          <li>{{ $tr('密码长度至少3位字符') }}</li>
          <li>{{ $tr('建议使用字母、数字和特殊字符的组合') }}</li>
          <li>{{ $tr('定期更换密码可以提高账户安全性') }}</li>
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
