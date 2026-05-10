import axios from 'axios'
import router from '@/router'
import { ElMessage } from 'element-plus'
import { serverHost } from '../../config/config.default'
import { t } from '@/i18n'

const request = axios.create({
  baseURL: serverHost,
  timeout: 5000
})

request.interceptors.request.use(
  (config) => {
    config.headers['Content-Type'] = 'application/json;charset=utf-8'
    const account = localStorage.getItem('account') ? JSON.parse(localStorage.getItem('account')) : null
    if (account) {
      config.headers.token = account.token
    }
    return config
  },
  (error) => Promise.reject(error)
)

request.interceptors.response.use(
  (response) => {
    let res = response.data
    if (response.config.responseType === 'blob') {
      return res
    }
    if (typeof res === 'string') {
      res = res ? JSON.parse(res) : res
    }
    if (res.code === '401') {
      ElMessage.error(res.msg || t('login.failed'))
      router.push('/login')
    }
    return res
  },
  (error) => {
    console.log('error' + error)
    return Promise.reject(error)
  }
)

export default request
