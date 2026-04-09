<template>
  <div>
    <div class="page-header">
      <h2>用户管理</h2>
      <el-input
        v-model="search"
        placeholder="搜索用户..."
        prefix-icon="Search"
        style="width: 260px"
        clearable
        @input="handleSearch"
      />
    </div>

    <el-card>
      <el-table :data="users" stripe v-loading="loading">
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="email" label="邮箱" min-width="180" />
        <el-table-column prop="role" label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="row.role === 'admin' ? 'danger' : 'primary'" size="small">
              {{ row.role === 'admin' ? '管理员' : '用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'info'" size="small">
              {{ row.status === 'active' ? '正常' : '已禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button
              v-if="row.status === 'active'"
              type="warning"
              size="small"
              plain
              @click="toggleStatus(row)"
            >
              禁用
            </el-button>
            <el-button
              v-else
              type="success"
              size="small"
              plain
              @click="toggleStatus(row)"
            >
              启用
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
          @size-change="fetchUsers"
          @current-change="fetchUsers"
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

const users = ref([])
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
    fetchUsers()
  }, 300)
}

async function fetchUsers() {
  loading.value = true
  try {
    const res = await api.get('/users', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    users.value = res.data.list || res.data.users || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取用户列表失败', err)
  } finally {
    loading.value = false
  }
}

async function toggleStatus(row) {
  const action = row.status === 'active' ? '禁用' : '启用'
  try {
    await ElMessageBox.confirm(`确定要${action}用户 "${row.name}" 吗？`, '提示', {
      type: 'warning'
    })
    const newStatus = row.status === 'active' ? 'disabled' : 'active'
    await api.put(`/users/${row._id || row.id}/status`, { status: newStatus })
    ElMessage.success(`${action}成功`)
    fetchUsers()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error(`${action}失败`)
    }
  }
}

onMounted(fetchUsers)
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
