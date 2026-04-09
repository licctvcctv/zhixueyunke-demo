<template>
  <div>
    <el-row :gutter="20" class="stat-row">
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" style="background: #409eff">
            <el-icon :size="28"><User /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.totalUsers || 0 }}</div>
            <div class="stat-label">总用户</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" style="background: #67c23a">
            <el-icon :size="28"><Reading /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.totalCourses || 0 }}</div>
            <div class="stat-label">总课程</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" style="background: #e6a23c">
            <el-icon :size="28"><ChatDotRound /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.totalPosts || 0 }}</div>
            <div class="stat-label">总帖子</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" style="background: #f56c6c">
            <el-icon :size="28"><TrendCharts /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.newUsersThisWeek || 0 }}</div>
            <div class="stat-label">本周新增用户</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span style="font-weight: 600">最近注册用户</span>
          </template>
          <el-table :data="stats.recentUsers || []" stripe size="small">
            <el-table-column prop="name" label="姓名" />
            <el-table-column prop="email" label="邮箱" />
            <el-table-column prop="createdAt" label="注册时间">
              <template #default="{ row }">
                {{ formatDate(row.createdAt) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span style="font-weight: 600">最近课程</span>
          </template>
          <el-table :data="stats.recentCourses || []" stripe size="small">
            <el-table-column prop="title" label="课程名称" />
            <el-table-column prop="instructor" label="讲师" />
            <el-table-column prop="createdAt" label="创建时间">
              <template #default="{ row }">
                {{ formatDate(row.createdAt) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { api } from '../api'
import { formatDate } from '../utils/format'

const stats = ref({})

async function fetchStats() {
  try {
    const res = await api.get('/stats')
    stats.value = res.data
  } catch (err) {
    console.error('获取统计数据失败', err)
  }
}

onMounted(fetchStats)
</script>

<style scoped>
.stat-row {
  margin-bottom: 0;
}

.stat-card :deep(.el-card__body) {
  display: flex;
  align-items: center;
  padding: 20px;
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-info {
  margin-left: 16px;
}

.stat-number {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 4px;
}
</style>
