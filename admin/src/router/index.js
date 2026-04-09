import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/LoginView.vue')
  },
  {
    path: '/',
    component: () => import('../components/AdminLayout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('../views/DashboardView.vue')
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('../views/UsersView.vue')
      },
      {
        path: 'courses',
        name: 'Courses',
        component: () => import('../views/CoursesView.vue')
      },
      {
        path: 'posts',
        name: 'Posts',
        component: () => import('../views/PostsView.vue')
      },
      {
        path: 'classes',
        name: 'Classes',
        component: () => import('../views/ClassesView.vue')
      },
      {
        path: 'questions',
        name: 'Questions',
        component: () => import('../views/QuestionsView.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('admin_token')
  if (to.path !== '/login' && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
