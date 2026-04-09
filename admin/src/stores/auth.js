import { defineStore } from 'pinia'
import { ref } from 'vue'
import { authApi } from '../api'
import router from '../router'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('admin_token') || '')

  async function login(username, password) {
    const res = await authApi.post('/login', { email: username, password })
    const t = res.data.token
    token.value = t
    localStorage.setItem('admin_token', t)
    router.push('/')
  }

  function logout() {
    token.value = ''
    localStorage.removeItem('admin_token')
    router.push('/login')
  }

  return { token, login, logout }
})
