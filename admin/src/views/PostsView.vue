<template>
  <div>
    <div class="page-header">
      <h2>帖子管理</h2>
      <el-input
        v-model="search"
        placeholder="搜索帖子..."
        prefix-icon="Search"
        style="width: 260px"
        clearable
        @input="handleSearch"
      />
    </div>

    <el-card>
      <el-table :data="posts" stripe v-loading="loading">
        <el-table-column prop="author" label="作者" width="120">
          <template #default="{ row }">
            {{ row.author?.name || row.authorName || row.author || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="content" label="内容" min-width="300" show-overflow-tooltip />
        <el-table-column prop="likes" label="点赞数" width="100">
          <template #default="{ row }">
            {{ row.likes || row.likeCount || 0 }}
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
          @size-change="fetchPosts"
          @current-change="fetchPosts"
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

const posts = ref([])
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
    fetchPosts()
  }, 300)
}

async function fetchPosts() {
  loading.value = true
  try {
    const res = await api.get('/posts', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    posts.value = res.data.list || res.data.posts || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取帖子列表失败', err)
  } finally {
    loading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm('确定要删除这条帖子吗？此操作不可撤销。', '警告', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/posts/${row._id || row.id}`)
    ElMessage.success('删除成功')
    fetchPosts()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(fetchPosts)
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
