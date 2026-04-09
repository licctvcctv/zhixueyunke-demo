<template>
  <div>
    <div class="page-header">
      <h2>课程管理</h2>
      <el-input
        v-model="search"
        placeholder="搜索课程..."
        prefix-icon="Search"
        style="width: 260px"
        clearable
        @input="handleSearch"
      />
    </div>

    <el-card>
      <el-table :data="courses" stripe v-loading="loading">
        <el-table-column prop="title" label="课程名称" min-width="180" />
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="instructor" label="讲师" width="120" />
        <el-table-column prop="studentCount" label="学生数" width="100" />
        <el-table-column prop="rating" label="评分" width="100">
          <template #default="{ row }">
            <el-rate
              :model-value="row.rating || 0"
              disabled
              show-score
              text-color="#ff9900"
              score-template="{value}"
              size="small"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button
              type="danger"
              size="small"
              plain
              @click="handleDelete(row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="page"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @size-change="fetchCourses"
          @current-change="fetchCourses"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { api } from '../api'
import { formatDate } from '../utils/format'

const courses = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

let searchTimer = null

function handleSearch() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    page.value = 1
    fetchCourses()
  }, 300)
}

async function fetchCourses() {
  loading.value = true
  try {
    const res = await api.get('/courses', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    courses.value = res.data.list || res.data.courses || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取课程列表失败', err)
  } finally {
    loading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确定要删除课程 "${row.title}" 吗？此操作不可撤销。`, '警告', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/courses/${row._id || row.id}`)
    ElMessage.success('删除成功')
    fetchCourses()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(fetchCourses)
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
