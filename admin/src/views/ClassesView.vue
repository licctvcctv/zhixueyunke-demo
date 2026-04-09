<template>
  <div>
    <div class="page-header">
      <h2>班级管理</h2>
      <el-input
        v-model="search"
        placeholder="搜索班级..."
        prefix-icon="Search"
        style="width: 260px"
        clearable
        @input="handleSearch"
      />
    </div>

    <el-card>
      <el-table :data="classes" stripe v-loading="loading">
        <el-table-column prop="name" label="班级名称" min-width="180" />
        <el-table-column prop="teacherName" label="教师" width="120" />
        <el-table-column prop="studentCount" label="学生数" width="100" />
        <el-table-column prop="createdAt" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" plain @click="openEdit(row)">编辑</el-button>
            <el-button type="success" size="small" plain @click="openDetail(row)">详情</el-button>
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
          @size-change="fetchClasses"
          @current-change="fetchClasses"
        />
      </div>
    </el-card>

    <!-- 编辑班级弹窗 -->
    <el-dialog v-model="showEditDialog" title="编辑班级" width="500px">
      <el-form :model="editForm" :rules="editRules" ref="editFormRef" label-width="80px">
        <el-form-item label="班级名称" prop="name">
          <el-input v-model="editForm.name" placeholder="请输入班级名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="editForm.description" type="textarea" :rows="3" placeholder="请输入班级描述" />
        </el-form-item>
        <el-form-item label="教师" prop="teacherName">
          <el-input v-model="editForm.teacherName" placeholder="请输入教师名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEditDialog = false">取消</el-button>
        <el-button type="primary" :loading="editLoading" @click="handleEditSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 班级详情弹窗 -->
    <el-dialog v-model="showDetailDialog" :title="`班级详情 - ${detailClassName}`" width="700px">
      <div v-loading="detailLoading">
        <h4 style="margin: 0 0 12px 0">成员列表</h4>
        <el-table :data="members" stripe size="small" max-height="250">
          <el-table-column prop="name" label="姓名" width="120" />
          <el-table-column prop="role" label="角色" width="100">
            <template #default="{ row }">
              <el-tag :type="row.role === 'teacher' ? 'warning' : 'primary'" size="small">
                {{ roleMap[row.role] || row.role }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="email" label="邮箱" min-width="180" />
          <el-table-column prop="joinedAt" label="加入时间" width="160">
            <template #default="{ row }">
              {{ formatDate(row.joinedAt || row.createdAt) }}
            </template>
          </el-table-column>
        </el-table>

        <h4 style="margin: 20px 0 12px 0">关联课程</h4>
        <el-table :data="classCourses" stripe size="small" max-height="250">
          <el-table-column prop="title" label="课程名称" min-width="180" />
          <el-table-column prop="category" label="分类" width="100" />
          <el-table-column prop="studentCount" label="学生数" width="100" />
          <el-table-column prop="createdAt" label="创建时间" width="160">
            <template #default="{ row }">
              {{ formatDate(row.createdAt) }}
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { api } from '../api'
import { formatDate } from '../utils/format'

const roleMap = { admin: '管理员', teacher: '教师', user: '学生' }

const classes = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 编辑
const showEditDialog = ref(false)
const editLoading = ref(false)
const editFormRef = ref(null)
const editingClassId = ref(null)
const editForm = reactive({
  name: '',
  description: '',
  teacherName: ''
})
const editRules = {
  name: [{ required: true, message: '请输入班级名称', trigger: 'blur' }]
}

// 详情
const showDetailDialog = ref(false)
const detailLoading = ref(false)
const detailClassName = ref('')
const members = ref([])
const classCourses = ref([])

let searchTimer = null

function handleSearch() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    page.value = 1
    fetchClasses()
  }, 300)
}

async function fetchClasses() {
  loading.value = true
  try {
    const res = await api.get('/classes', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    classes.value = res.data.list || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取班级列表失败', err)
  } finally {
    loading.value = false
  }
}

function openEdit(row) {
  editingClassId.value = row.id
  editForm.name = row.name || ''
  editForm.description = row.description || ''
  editForm.teacherName = row.teacherName || ''
  showEditDialog.value = true
}

async function handleEditSubmit() {
  if (editFormRef.value) {
    try { await editFormRef.value.validate() } catch { return }
  }
  editLoading.value = true
  try {
    await api.put(`/classes/${editingClassId.value}`, {
      name: editForm.name,
      description: editForm.description,
      teacherName: editForm.teacherName
    })
    ElMessage.success('编辑成功')
    showEditDialog.value = false
    fetchClasses()
  } catch (err) {
    ElMessage.error('编辑失败')
  } finally {
    editLoading.value = false
  }
}

async function openDetail(row) {
  detailClassName.value = row.name
  showDetailDialog.value = true
  detailLoading.value = true
  members.value = []
  classCourses.value = []
  try {
    const [membersRes, coursesRes] = await Promise.all([
      api.get(`/classes/${row.id}/members`),
      api.get(`/classes/${row.id}/courses`)
    ])
    members.value = membersRes.data.list || membersRes.data || []
    classCourses.value = coursesRes.data.list || coursesRes.data || []
  } catch (err) {
    console.error('获取班级详情失败', err)
  } finally {
    detailLoading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确定要删除班级 "${row.name}" 吗？此操作不可撤销。`, '警告', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/classes/${row.id}`)
    ElMessage.success('删除成功')
    fetchClasses()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(fetchClasses)
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
