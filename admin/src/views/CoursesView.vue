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

    <el-dialog v-model="showCreateDialog" title="新增课程" width="500px">
      <el-form :model="courseForm" label-width="80px">
        <el-form-item label="课程名称">
          <el-input v-model="courseForm.title" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="courseForm.description" type="textarea" :rows="3" placeholder="请输入课程描述" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="courseForm.category" placeholder="请选择分类" style="width: 100%">
            <el-option label="编程" value="编程" />
            <el-option label="数学" value="数学" />
            <el-option label="英语" value="英语" />
            <el-option label="物理" value="物理" />
            <el-option label="设计" value="设计" />
          </el-select>
        </el-form-item>
        <el-form-item label="讲师">
          <el-input v-model="courseForm.teacherName" placeholder="请输入讲师名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" :loading="creating" @click="handleCreate">确定</el-button>
      </template>
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

const showCreateDialog = ref(false)
const creating = ref(false)
const courseForm = reactive({
  title: '',
  description: '',
  category: '',
  teacherName: ''
})

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
  if (!courseForm.title) {
    ElMessage.warning('请输入课程名称')
    return
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
