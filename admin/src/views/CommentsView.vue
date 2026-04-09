<template>
  <div>
    <div class="page-header">
      <h2>评论管理</h2>
      <el-input
        v-model="search"
        placeholder="搜索评论内容..."
        prefix-icon="Search"
        style="width: 260px"
        clearable
        @input="handleSearch"
      />
    </div>

    <el-card>
      <el-table :data="comments" stripe v-loading="loading">
        <el-table-column prop="id" label="ID" width="60" />
        <el-table-column prop="authorName" label="评论人" width="100" />
        <el-table-column prop="content" label="内容" min-width="300" show-overflow-tooltip />
        <el-table-column prop="targetType" label="类型" width="80">
          <template #default="{ row }">
            <el-tag :type="typeTag[row.targetType]" size="small">
              {{ typeMap[row.targetType] || row.targetType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="targetId" label="目标ID" width="80" />
        <el-table-column prop="createdAt" label="时间" width="170">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="80" fixed="right">
          <template #default="{ row }">
            <el-button type="danger" size="small" plain @click="handleDelete(row)">删除</el-button>
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
          @size-change="fetchComments"
          @current-change="fetchComments"
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

const typeMap = { course: '课程', post: '帖子', question: '问答' }
const typeTag = { course: 'primary', post: 'success', question: 'warning' }

const comments = ref([])
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
    fetchComments()
  }, 300)
}

async function fetchComments() {
  loading.value = true
  try {
    const res = await api.get('/comments', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    comments.value = res.data.list || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取评论列表失败', err)
  } finally {
    loading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm('确定要删除这条评论吗？', '提示', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/comments/${row.id}`)
    ElMessage.success('删除成功')
    fetchComments()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(fetchComments)
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}
.page-header h2 { margin: 0; font-size: 20px; color: #303133; }
.pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
</style>
