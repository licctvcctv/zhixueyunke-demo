import axios from 'axios'
import router from '../router'

const api = axios.create({
  baseURL: '/api/admin',
  timeout: 10000
})

const authApi = axios.create({
  baseURL: '/api/auth',
  timeout: 10000
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('admin_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

api.interceptors.response.use(
  response => response,
  error => {
    if (error.response && (error.response.status === 401 || error.response.status === 403)) {
      localStorage.removeItem('admin_token')
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export { api, authApi }
