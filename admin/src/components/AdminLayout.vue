<template>
  <el-container style="height: 100vh">
    <el-aside width="220px" class="sidebar">
      <div class="logo">
        <h2>智学云课</h2>
      </div>
      <el-menu
        :default-active="activeMenu"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409eff"
        router
      >
        <el-menu-item index="/dashboard">
          <el-icon><DataAnalysis /></el-icon>
          <span>仪表盘</span>
        </el-menu-item>
        <el-menu-item index="/users">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="/courses">
          <el-icon><Reading /></el-icon>
          <span>课程管理</span>
        </el-menu-item>
        <el-menu-item index="/posts">
          <el-icon><ChatDotRound /></el-icon>
          <span>帖子管理</span>
        </el-menu-item>
        <el-menu-item index="/classes">
          <el-icon><OfficeBuilding /></el-icon>
          <span>班级管理</span>
        </el-menu-item>
        <el-menu-item index="/teachers">
          <el-icon><Avatar /></el-icon>
          <span>教师管理</span>
        </el-menu-item>
        <el-menu-item index="/questions">
          <el-icon><QuestionFilled /></el-icon>
          <span>问答管理</span>
        </el-menu-item>
        <el-menu-item index="/comments">
          <el-icon><Comment /></el-icon>
          <span>评论管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div class="header-right">
          <el-button type="danger" plain size="small" @click="handleLogout">
            <el-icon><SwitchButton /></el-icon>
            退出登录
          </el-button>
        </div>
      </el-header>
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const authStore = useAuthStore()

const activeMenu = computed(() => route.path)

function handleLogout() {
  authStore.logout()
}
</script>

<style scoped>
.sidebar {
  background-color: #304156;
  overflow-y: auto;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #263445;
}

.logo h2 {
  color: #fff;
  font-size: 20px;
  margin: 0;
  letter-spacing: 2px;
}

.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.header-right {
  display: flex;
  align-items: center;
}

.main-content {
  background-color: #f0f2f5;
  overflow-y: auto;
}
</style>
