<template>
  <div>
    <div class="page-header">
      <h2>教师管理</h2>
      <div class="page-header-right">
        <el-button type="primary" @click="showCreateDialog = true">新增教师</el-button>
        <el-input
          v-model="search"
          placeholder="搜索教师..."
          prefix-icon="Search"
          style="width: 260px; margin-left: 12px"
          clearable
          @input="handleSearch"
        />
      </div>
    </div>

    <el-card>
      <el-table :data="teachers" stripe v-loading="loading">
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="email" label="邮箱" min-width="180" />
        <el-table-column prop="bio" label="简介" min-width="200" show-overflow-tooltip />
        <el-table-column prop="courseCount" label="课程数" width="90" />
        <el-table-column prop="createdAt" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" plain @click="openEdit(row)">编辑</el-button>
            <el-button type="success" size="small" plain @click="openCourses(row)">课程</el-button>
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
          @size-change="fetchTeachers"
          @current-change="fetchTeachers"
        />
      </div>
    </el-card>

    <!-- 新增教师弹窗 -->
    <el-dialog v-model="showCreateDialog" title="新增教师" width="500px">
      <el-form :model="createForm" :rules="createRules" ref="createFormRef" label-width="80px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="createForm.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="createForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="createForm.password" type="password" placeholder="请输入密码" show-password />
        </el-form-item>
        <el-form-item label="简介" prop="bio">
          <el-input v-model="createForm.bio" type="textarea" :rows="3" placeholder="请输入个人简介" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" :loading="creating" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>

    <!-- 编辑教师弹窗 -->
    <el-dialog v-model="showEditDialog" title="编辑教师" width="500px">
      <el-form :model="editForm" :rules="editRules" ref="editFormRef" label-width="80px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="editForm.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" />
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

    <!-- 查看课程弹窗 -->
    <el-dialog v-model="showCoursesDialog" :title="`${coursesTeacherName} 的课程`" width="650px">
      <el-table :data="teacherCourses" stripe size="small" v-loading="coursesLoading">
        <el-table-column prop="title" label="课程名称" min-width="180" />
        <el-table-column prop="category" label="分类" width="100" />
        <el-table-column prop="studentCount" label="学生数" width="90" />
        <el-table-column prop="createdAt" label="创建时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { api } from '../api'
import { formatDate } from '../utils/format'

const teachers = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 新增
const showCreateDialog = ref(false)
const creating = ref(false)
const createFormRef = ref(null)
const createForm = reactive({
  name: '',
  email: '',
  password: '',
  bio: ''
})
const createRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码不少于6位', trigger: 'blur' }
  ]
}

// 编辑
const showEditDialog = ref(false)
const editLoading = ref(false)
const editFormRef = ref(null)
const editingTeacherId = ref(null)
const editForm = reactive({
  name: '',
  email: '',
  bio: ''
})
const editRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ]
}

// 查看课程
const showCoursesDialog = ref(false)
const coursesLoading = ref(false)
const coursesTeacherName = ref('')
const teacherCourses = ref([])

let searchTimer = null

function handleSearch() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    page.value = 1
    fetchTeachers()
  }, 300)
}

async function fetchTeachers() {
  loading.value = true
  try {
    const res = await api.get('/teachers', {
      params: { page: page.value, pageSize: pageSize.value, search: search.value }
    })
    teachers.value = res.data.list || res.data.teachers || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取教师列表失败', err)
  } finally {
    loading.value = false
  }
}

async function handleCreate() {
  if (createFormRef.value) {
    try { await createFormRef.value.validate() } catch { return }
  }
  creating.value = true
  try {
    await api.post('/teachers', {
      name: createForm.name,
      email: createForm.email,
      password: createForm.password,
      bio: createForm.bio
    })
    ElMessage.success('新增教师成功')
    showCreateDialog.value = false
    createForm.name = ''
    createForm.email = ''
    createForm.password = ''
    createForm.bio = ''
    fetchTeachers()
  } catch (err) {
    ElMessage.error('新增教师失败')
  } finally {
    creating.value = false
  }
}

function openEdit(row) {
  editingTeacherId.value = row.id
  editForm.name = row.name || ''
  editForm.email = row.email || ''
  editForm.bio = row.bio || ''
  showEditDialog.value = true
}

async function handleEditSubmit() {
  if (editFormRef.value) {
    try { await editFormRef.value.validate() } catch { return }
  }
  editLoading.value = true
  try {
    await api.patch(`/teachers/${editingTeacherId.value}`, {
      name: editForm.name,
      email: editForm.email,
      bio: editForm.bio
    })
    ElMessage.success('编辑成功')
    showEditDialog.value = false
    fetchTeachers()
  } catch (err) {
    ElMessage.error('编辑失败')
  } finally {
    editLoading.value = false
  }
}

async function openCourses(row) {
  coursesTeacherName.value = row.name
  showCoursesDialog.value = true
  coursesLoading.value = true
  teacherCourses.value = []
  try {
    const res = await api.get(`/teachers/${row.id}/courses`)
    teacherCourses.value = res.data.list || res.data || []
  } catch (err) {
    console.error('获取教师课程失败', err)
  } finally {
    coursesLoading.value = false
  }
}

onMounted(fetchTeachers)
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

.page-header-right {
  display: flex;
  align-items: center;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
