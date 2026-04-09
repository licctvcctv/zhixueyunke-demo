<template>
  <div>
    <div class="page-header">
      <h2>课程管理</h2>
      <div class="page-header-right">
        <el-button type="primary" @click="showCreateDialog = true">新增课程</el-button>
        <el-input
          v-model="search"
          placeholder="搜索课程..."
          prefix-icon="Search"
          style="width: 260px; margin-left: 12px"
          clearable
          @input="handleSearch"
        />
      </div>
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
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" plain @click="openEdit(row)">编辑</el-button>
            <el-button type="success" size="small" plain @click="openLessons(row)">课时</el-button>
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
          @size-change="fetchCourses"
          @current-change="fetchCourses"
        />
      </div>
    </el-card>

    <!-- 新增课程弹窗 -->
    <el-dialog v-model="showCreateDialog" title="新增课程" width="500px">
      <el-form :model="courseForm" :rules="courseRules" ref="createFormRef" label-width="80px">
        <el-form-item label="课程名称" prop="title">
          <el-input v-model="courseForm.title" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="courseForm.description" type="textarea" :rows="3" placeholder="请输入课程描述" />
        </el-form-item>
        <el-form-item label="分类" prop="category">
          <el-select v-model="courseForm.category" placeholder="请选择分类" style="width: 100%">
            <el-option label="编程" value="编程" />
            <el-option label="数学" value="数学" />
            <el-option label="英语" value="英语" />
            <el-option label="物理" value="物理" />
            <el-option label="设计" value="设计" />
          </el-select>
        </el-form-item>
        <el-form-item label="讲师" prop="teacherName">
          <el-input v-model="courseForm.teacherName" placeholder="请输入讲师名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" :loading="creating" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>

    <!-- 编辑课程弹窗 -->
    <el-dialog v-model="showEditDialog" title="编辑课程" width="500px">
      <el-form :model="editForm" :rules="courseRules" ref="editFormRef" label-width="80px">
        <el-form-item label="课程名称" prop="title">
          <el-input v-model="editForm.title" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="editForm.description" type="textarea" :rows="3" placeholder="请输入课程描述" />
        </el-form-item>
        <el-form-item label="分类" prop="category">
          <el-select v-model="editForm.category" placeholder="请选择分类" style="width: 100%">
            <el-option label="编程" value="编程" />
            <el-option label="数学" value="数学" />
            <el-option label="英语" value="英语" />
            <el-option label="物理" value="物理" />
            <el-option label="设计" value="设计" />
          </el-select>
        </el-form-item>
        <el-form-item label="讲师" prop="teacherName">
          <el-input v-model="editForm.teacherName" placeholder="请输入讲师名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEditDialog = false">取消</el-button>
        <el-button type="primary" :loading="editLoading" @click="handleEditSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 课时管理弹窗 -->
    <el-dialog v-model="showLessonsDialog" :title="`课时管理 - ${currentCourseName}`" width="750px">
      <el-table :data="lessons" stripe v-loading="lessonsLoading" size="small">
        <el-table-column prop="orderNum" label="序号" width="60">
          <template #default="{ row }">
            <el-input-number v-if="row._editing" v-model="row.orderNum" :min="1" size="small" controls-position="right" style="width: 60px" />
            <span v-else>{{ row.orderNum }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="150">
          <template #default="{ row }">
            <el-input v-if="row._editing" v-model="row.title" size="small" />
            <span v-else>{{ row.title }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="duration" label="时长(分)" width="90">
          <template #default="{ row }">
            <el-input-number v-if="row._editing" v-model="row.duration" :min="0" size="small" controls-position="right" style="width: 80px" />
            <span v-else>{{ row.duration || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="videoUrl" label="视频URL" min-width="150" show-overflow-tooltip>
          <template #default="{ row }">
            <el-input v-if="row._editing" v-model="row.videoUrl" size="small" placeholder="视频地址" />
            <span v-else>{{ row.videoUrl || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="140" fixed="right">
          <template #default="{ row, $index }">
            <template v-if="row._editing">
              <el-button type="success" size="small" plain @click="saveLesson(row, $index)">保存</el-button>
              <el-button size="small" plain @click="cancelEditLesson(row, $index)">取消</el-button>
            </template>
            <template v-else>
              <el-button type="primary" size="small" plain @click="startEditLesson(row)">编辑</el-button>
              <el-button type="danger" size="small" plain @click="deleteLesson(row, $index)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 12px">
        <el-button type="primary" plain @click="addNewLesson">添加课时</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { api, baseApi } from '../api'
import { formatDate } from '../utils/format'

const courses = ref([])
const loading = ref(false)
const search = ref('')
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 新增
const showCreateDialog = ref(false)
const creating = ref(false)
const createFormRef = ref(null)
const courseForm = reactive({
  title: '',
  description: '',
  category: '',
  teacherName: ''
})

// 编辑
const showEditDialog = ref(false)
const editLoading = ref(false)
const editFormRef = ref(null)
const editingCourseId = ref(null)
const editForm = reactive({
  title: '',
  description: '',
  category: '',
  teacherName: ''
})

const courseRules = {
  title: [{ required: true, message: '请输入课程名称', trigger: 'blur' }],
  category: [{ required: true, message: '请选择分类', trigger: 'change' }]
}

// 课时管理
const showLessonsDialog = ref(false)
const lessonsLoading = ref(false)
const lessons = ref([])
const currentCourseId = ref(null)
const currentCourseName = ref('')

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
    courses.value = res.data.list || []
    total.value = res.data.total || 0
  } catch (err) {
    console.error('获取课程列表失败', err)
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
    await baseApi.post('/courses', {
      title: courseForm.title,
      description: courseForm.description,
      category: courseForm.category,
      teacherName: courseForm.teacherName
    })
    ElMessage.success('创建成功')
    showCreateDialog.value = false
    courseForm.title = ''
    courseForm.description = ''
    courseForm.category = ''
    courseForm.teacherName = ''
    fetchCourses()
  } catch (err) {
    ElMessage.error('创建失败')
  } finally {
    creating.value = false
  }
}

function openEdit(row) {
  editingCourseId.value = row.id
  editForm.title = row.title || ''
  editForm.description = row.description || ''
  editForm.category = row.category || ''
  editForm.teacherName = row.instructor || row.teacherName || ''
  showEditDialog.value = true
}

async function handleEditSubmit() {
  if (editFormRef.value) {
    try { await editFormRef.value.validate() } catch { return }
  }
  editLoading.value = true
  try {
    await api.put(`/courses/${editingCourseId.value}`, {
      title: editForm.title,
      description: editForm.description,
      category: editForm.category,
      teacherName: editForm.teacherName
    })
    ElMessage.success('编辑成功')
    showEditDialog.value = false
    fetchCourses()
  } catch (err) {
    ElMessage.error('编辑失败')
  } finally {
    editLoading.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确定要删除课程 "${row.title}" 吗？此操作不可撤销。`, '警告', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/courses/${row.id}`)
    ElMessage.success('删除成功')
    fetchCourses()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// ===== 课时管理 =====
async function openLessons(row) {
  currentCourseId.value = row.id
  currentCourseName.value = row.title
  showLessonsDialog.value = true
  await fetchLessons()
}

async function fetchLessons() {
  lessonsLoading.value = true
  try {
    const res = await api.get(`/courses/${currentCourseId.value}/lessons`)
    lessons.value = (res.data.list || res.data || []).map(l => ({ ...l, _editing: false, _backup: null }))
  } catch (err) {
    console.error('获取课时列表失败', err)
    lessons.value = []
  } finally {
    lessonsLoading.value = false
  }
}

function startEditLesson(row) {
  row._backup = { title: row.title, orderNum: row.orderNum, duration: row.duration, videoUrl: row.videoUrl }
  row._editing = true
}

function cancelEditLesson(row, index) {
  if (row._isNew) {
    lessons.value.splice(index, 1)
    return
  }
  if (row._backup) {
    Object.assign(row, row._backup)
  }
  row._editing = false
  row._backup = null
}

async function saveLesson(row, index) {
  if (!row.title) {
    ElMessage.warning('请输入课时标题')
    return
  }
  try {
    if (row._isNew) {
      await api.post(`/courses/${currentCourseId.value}/lessons`, {
        title: row.title,
        orderNum: row.orderNum,
        duration: row.duration,
        videoUrl: row.videoUrl
      })
      ElMessage.success('添加课时成功')
    } else {
      await api.put(`/courses/${currentCourseId.value}/lessons/${row.id}`, {
        title: row.title,
        orderNum: row.orderNum,
        duration: row.duration,
        videoUrl: row.videoUrl
      })
      ElMessage.success('更新课时成功')
    }
    await fetchLessons()
  } catch (err) {
    ElMessage.error('保存课时失败')
  }
}

async function deleteLesson(row, index) {
  try {
    await ElMessageBox.confirm(`确定要删除课时 "${row.title}" 吗？`, '警告', {
      type: 'warning',
      confirmButtonText: '确定删除',
      cancelButtonText: '取消'
    })
    await api.delete(`/courses/${currentCourseId.value}/lessons/${row.id}`)
    ElMessage.success('删除课时成功')
    await fetchLessons()
  } catch (err) {
    if (err !== 'cancel') {
      ElMessage.error('删除课时失败')
    }
  }
}

function addNewLesson() {
  lessons.value.push({
    _editing: true,
    _isNew: true,
    _backup: null,
    title: '',
    orderNum: lessons.value.length + 1,
    duration: 0,
    videoUrl: ''
  })
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
