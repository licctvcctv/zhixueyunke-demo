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
            <el-tag :type="roleTagType(row.role)" size="small">
              {{ roleMap[row.role] || row.role }}
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
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" plain @click="openEdit(row)">编辑</el-button>
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

    <!-- 编辑用户弹窗 -->
    <el-dialog v-model="showEditDialog" title="编辑用户" width="500px">
      <el-form :model="editForm" :rules="editRules" ref="editFormRef" label-width="80px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="editForm.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="editForm.role" placeholder="请选择角色" style="width: 100%">
            <el-option label="管理员" value="admin" />
            <el-option label="教师" value="teacher" />
            <el-option label="学生" value="user" />
          </el-select>
        </el-form-item>
        <el-form-item label="简介" prop="bio">
          <el-input v-model="editForm.bio" type="textarea" :rows="3" placeholder="请输入个人简介" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEditDialog = false">取消</el-button>
        <el-button type="primary" :loading="editLoading" @click="handleEditSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { api } from '../api'
import { formatDate } from '../utils/format'

const roleMap = { admin: '管理员', teacher: '教师', user: '学生' }

function roleTagType(role) {
  if (role === 'admin') return 'danger'
  if (role === 'teacher') return 'warning'
  return 'primary'
}

const users = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 编辑相关
const showEditDialog = ref(false)
const editLoading = ref(false)
const editFormRef = ref(null)
const editingUserId = ref(null)
const editForm = reactive({
  name: '',
  email: '',
  role: '',
  bio: ''
})
const editRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  role: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

function openEdit(row) {
  editingUserId.value = row.id
  editForm.name = row.name || ''
  editForm.email = row.email || ''
  editForm.role = row.role || 'user'
  editForm.bio = row.bio || ''
  showEditDialog.value = true
}

async function handleEditSubmit() {
  if (!editFormRef.value) return
  try {
    await editFormRef.value.validate()
  } catch {
    return
  }
  editLoading.value = true
  try {
    await api.patch(`/users/${editingUserId.value}`, {
      name: editForm.name,
      email: editForm.email,
      role: editForm.role,
      bio: editForm.bio
    })
    ElMessage.success('编辑成功')
    showEditDialog.value = false
    fetchUsers()
  } catch (err) {
    ElMessage.error('编辑失败')
  } finally {
    editLoading.value = false
  }
}

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
    await api.put(`/users/${row.id}/status`, { status: newStatus })
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
