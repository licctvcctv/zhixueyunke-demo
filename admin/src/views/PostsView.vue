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
            {{ row.authorName || '-' }}
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
        <el-table-column label="操作" width="140" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" plain @click="openDetail(row)">详情</el-button>
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
          @size-change="fetchPosts"
          @current-change="fetchPosts"
        />
      </div>
    </el-card>

    <!-- 帖子详情弹窗 -->
    <el-dialog v-model="showDetailDialog" title="帖子详情" width="650px">
      <div v-if="detailPost" class="post-detail">
        <div class="post-meta">
          <strong>{{ detailPost.authorName || '匿名' }}</strong>
          <span class="post-time">{{ formatDate(detailPost.createdAt) }}</span>
        </div>
        <div class="post-content">{{ detailPost.content }}</div>
        <el-divider />
        <h4>评论列表 ({{ comments.length }})</h4>
        <div v-if="commentsLoading" style="text-align: center; padding: 20px">
          <el-icon class="is-loading"><Loading /></el-icon> 加载中...
        </div>
        <div v-else-if="comments.length === 0" class="no-comments">暂无评论</div>
        <div v-else class="comment-list">
          <div v-for="c in comments" :key="c.id" class="comment-item">
            <div class="comment-header">
              <strong>{{ c.authorName || c.userName || '匿名' }}</strong>
              <span class="comment-time">{{ formatDate(c.createdAt) }}</span>
              <el-button
                type="danger"
                size="small"
                text
                @click="deleteComment(c)"
                style="margin-left: auto"
              >
                删除
              </el-button>
            </div>
            <div class="comment-content">{{ c.content }}</div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Loading } from '@element-plus/icons-vue'
import { api } from '../api'
import { formatDate } from '../utils/format'

const posts = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 详情
const showDetailDialog = ref(false)
const detailPost = ref(null)
const comments = ref([])
const commentsLoading = ref(false)

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
    posts.value = res.data.list || []
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
    await api.delete(`/posts/${row.id}`)
    ElMessage.success('删除成功')
    fetchPosts()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

async function openDetail(row) {
  detailPost.value = row
  showDetailDialog.value = true
  commentsLoading.value = true
  comments.value = []
  try {
    const res = await api.get(`/posts/${row.id}/comments`)
    comments.value = res.data.list || res.data || []
  } catch (err) {
    console.error('获取评论失败', err)
  } finally {
    commentsLoading.value = false
  }
}

async function deleteComment(comment) {
  try {
    await ElMessageBox.confirm('确定要删除这条评论吗？', '提示', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/posts/${detailPost.value.id}/comments/${comment.id}`)
    ElMessage.success('评论删除成功')
    comments.value = comments.value.filter(c => c.id !== comment.id)
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除评论失败')
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

.post-detail {
  max-height: 60vh;
  overflow-y: auto;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.post-time,
.comment-time {
  color: #909399;
  font-size: 13px;
}

.post-content {
  font-size: 15px;
  line-height: 1.6;
  color: #303133;
  white-space: pre-wrap;
}

.no-comments {
  color: #909399;
  text-align: center;
  padding: 20px 0;
}

.comment-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.comment-item {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 12px;
}

.comment-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
}

.comment-content {
  font-size: 14px;
  line-height: 1.5;
  color: #606266;
}
</style>
