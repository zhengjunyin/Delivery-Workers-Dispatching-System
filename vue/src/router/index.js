
import { createRouter, createWebHistory } from 'vue-router'
import { projectName } from '../../config/config.default'
import { currentLocale, translateLiteral } from '@/i18n'
import { watch } from 'vue'

const routes = [
  //通用路由
  {
    path: '/',
    name: '/',
    component: () => import('../views/Login.vue'),
    meta: {
      title: 'Login'
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: {
      title: 'Login'
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue'),
    meta: {
      title: 'Register'
    }
  },
  {
    path: '/404',
    name: '404',
    component: () => import('../views/404.vue'),
    meta: {
      title: '404'
    }
  },
  //下面都是前台路由
  {
    path: '/front',
    name: 'Front',
    component: () => import('../views/Front.vue'),
    children: [
      // 前台子路由
      {
        path: 'home',
        name: 'FrontHome',
        component: () => import('../views/front/Home.vue'),
        meta: {
          title: 'Home'
        }
      },
      {
        path: 'password',
        name: 'FrontPassword',
        component: () => import('../views/front/Password.vue'),
        meta: {
          title: 'Change Password'
        }
      },
      {
        path: 'person',
        name: 'FrontPerson',
        component: () => import('../views/front/Person.vue'),
        meta: {
          title: 'Personal Information'
        }
      },
      {
        path: 'articleDetail',
        name: 'FrontArticleDetail',
        component: () => import('../views/front/ArticleDetail.vue'),
        meta: {
          title: 'Announcement Details'
        }
      },
      {
        path: 'delivery',
        name: 'FrontDelivery',
        component: () => import('../views/front/Delivery.vue'),
        meta: {
          title: 'Delivery Staff Information'
        }
      },
      {
        path: 'activity',
        name: 'FrontActivity',
        component: () => import('../views/front/Activity.vue'),
        meta: {
          title: 'Activities'
        }
      },
      {
        path: 'deliveryDetail',
        name: 'FrontDeliveryDetail',
        component: () => import('../views/front/DeliveryDetail.vue'),
        meta: {
          title: 'View Details'
        }
      },
      {
        path: 'myWorkRecord',
        name: 'FrontMyWorkRecord',
        component: () => import('../views/front/MyWorkRecord.vue'),
        meta: {
          title: 'Work Records'
        }
      },
      {
        path: 'myJoin',
        name: 'FrontMyJoin',
        component: () => import('../views/front/MyJoin.vue'),
        meta: {
          title: 'Activity Records'
        }
      },
      // {
      //   path: 'collect',
      //   name: 'FrontCollect',
      //   component: () => import('../views/front/Collect.vue'),
      //   meta: {
      //     title: '我的收藏'
      //   }
      // },
      // 前台子路由
    ]
  },
  //下面都是后台路由
  {
    path: '/back',
    name: 'back',
    component: () => import('../views/Back.vue'),
    children: [
      // 后台子路由
      {
        path: 'home',
        name: 'BackHome',
        component: () => import('../views/back/Home.vue'),
        meta: {
          title: 'Dispatch Dashboard'
        }
      },
      {
        path: 'password',
        name: 'BackPassword',
        component: () => import('../views/back/Password.vue'),
        meta: {
          title: 'Change Password'
        }
      },
      {
        path: 'adminPerson',
        name: 'BackAdminPerson',
        component: () => import('../views/back/AdminPerson.vue'),
        meta: {
          title: 'Profile'
        }
      },
      {
        path: 'user',
        name: 'BackUser',
        component: () => import('../views/back/User.vue'),
        meta: {
          title: 'User'
        }
      },
      {
        path: 'admin',
        name: 'BackAdmin',
        component: () => import('../views/back/Admin.vue'),
        meta: {
          title: 'Admin'
        }
      },
      // {
      //   path: 'comment',
      //   name: 'BackComment',
      //   component: () => import('../views/back/Comment.vue'),
      //   meta: {
      //     title: '评论管理'
      //   }
      // },
      {
        path: 'banner',
        name: 'BackBanner',
        component: () => import('../views/back/Banner.vue'),
        meta: {
          title: 'Carousel Management'
        }
      },
      // {
      //   path: 'collect',
      //   name: 'BackCollect',
      //   component: () => import('../views/back/Collect.vue'),
      //   meta: {
      //     title: '收藏管理'
      //   }
      // },
      {
        path: 'article',
        name: 'BackArticle',
        component: () => import('../views/back/Article.vue'),
        meta: {
          title: 'Article'
        }
      },
      {
        path: 'type',
        name: 'BackType',
        component: () => import('../views/back/Type.vue'),
        meta: {
          title: 'Type'
        }
      },
      {
        path: 'delivery',
        name: 'BackDelivery',
        component: () => import('../views/back/Delivery.vue'),
        meta: {
          title: 'Delivery Staff '
        }
      },
      {
        path: 'workRecord',
        name: 'BackWorkRecord',
        component: () => import('../views/back/WorkRecord.vue'),
        meta: {
          title: 'Work Record'
        }
      },
      {
        path: 'activity',
        name: 'BackActivity',
        component: () => import('../views/back/Activity.vue'),
        meta: {
          title: 'Activity'
        }
      },
      {
        path: 'activityRecord',
        name: 'BackActivityRecord',
        component: () => import('../views/back/ActivityRecord.vue'),
        meta: {
          title: 'Activity Record'
        }
      },
      // 后台子路由
    ]
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 全局前置守卫
router.beforeEach((to, from, next) => {
  const account = JSON.parse(localStorage.getItem("account") || '{}')
  if (to.matched.length === 0) {
    next('/404')
    return
  }
  if (to.path === '/') {
    if (account.role) {
      // 现在是只有角色为管理员才访问后台
      // 如果想设置其他角色登录后也默认访问后台，可以用下面的判断条件
      // account.role === 'ROLE_ADMIN' || account.role === 'ROLE_UNIT'
      if (account.role === 'ROLE_ADMIN') {
        next('/back/home')
      } else {
        next('/front/home')
      }
    } else {
      // 现在是只有登录以后才可以访问首页
      next('/login')
      // 如果想不登录就可以直接访问首页的话，直接用下面的跳转/front/home即可
      // next('/front/home')
    }
  } else {
    next()
  }
})

// 全局后置守卫
router.afterEach((to) => {
  setDocumentTitle(to)
})

watch(currentLocale, () => {
  setDocumentTitle(router.currentRoute.value)
})

function setDocumentTitle(route) {
  const title = route.meta.title ? translateLiteral(route.meta.title) : ''
  document.title = title ? `${title} - ${projectName}` : projectName
}

export default router









/*

import { createRouter, createWebHistory } from 'vue-router'
import { projectName } from '../../config/config.default'

const routes = [
  //通用路由
  {
    path: '/',
    name: '/',
    component: () => import('../views/Login.vue'),
    meta: {
      title: '登录'
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: {
      title: '登录'
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue'),
    meta: {
      title: '注册'
    }
  },
  {
    path: '/404',
    name: '404',
    component: () => import('../views/404.vue'),
    meta: {
      title: '404'
    }
  },
  //下面都是前台路由
  {
    path: '/front',
    name: 'Front',
    component: () => import('../views/Front.vue'),
    children: [
      // 前台子路由
      {
        path: 'home',
        name: 'FrontHome',
        component: () => import('../views/front/Home.vue'),
        meta: {
          title: '前台首页'
        }
      },
      {
        path: 'password',
        name: 'FrontPassword',
        component: () => import('../views/front/Password.vue'),
        meta: {
          title: '修改密码'
        }
      },
      {
        path: 'person',
        name: 'FrontPerson',
        component: () => import('../views/front/Person.vue'),
        meta: {
          title: '个人信息'
        }
      },
      {
        path: 'articleDetail',
        name: 'FrontArticleDetail',
        component: () => import('../views/front/ArticleDetail.vue'),
        meta: {
          title: '公告详情'
        }
      },
      {
        path: 'delivery',
        name: 'FrontDelivery',
        component: () => import('../views/front/Delivery.vue'),
        meta: {
          title: '图书大厅'
        }
      },
      {
        path: 'activity',
        name: 'FrontActivity',
        component: () => import('../views/front/Activity.vue'),
        meta: {
          title: '活动中心'
        }
      },
      {
        path: 'deliveryDetail',
        name: 'FrontDeliveryDetail',
        component: () => import('../views/front/DeliveryDetail.vue'),
        meta: {
          title: '查看详情'
        }
      },
      {
        path: 'myWorkRecord',
        name: 'FrontMyWorkRecord',
        component: () => import('../views/front/MyWorkRecord.vue'),
        meta: {
          title: '我的借阅'
        }
      },
      {
        path: 'myJoin',
        name: 'FrontMyJoin',
        component: () => import('../views/front/MyJoin.vue'),
        meta: {
          title: '我的活动'
        }
      },
      {
        path: 'collect',
        name: 'FrontCollect',
        component: () => import('../views/front/Collect.vue'),
        meta: {
          title: '我的收藏'
        }
      },
      // 前台子路由
    ]
  },
  //下面都是后台路由
  {
    path: '/back',
    name: 'back',
    component: () => import('../views/Back.vue'),
    children: [
      // 后台子路由
      {
        path: 'home',
        name: 'BackHome',
        component: () => import('../views/back/Home.vue'),
        meta: {
          title: '后台首页'
        }
      },
      {
        path: 'password',
        name: 'BackPassword',
        component: () => import('../views/back/Password.vue'),
        meta: {
          title: '修改密码'
        }
      },
      {
        path: 'adminPerson',
        name: 'BackAdminPerson',
        component: () => import('../views/back/AdminPerson.vue'),
        meta: {
          title: '个人信息'
        }
      },
      {
        path: 'user',
        name: 'BackUser',
        component: () => import('../views/back/User.vue'),
        meta: {
          title: '用户管理'
        }
      },
      {
        path: 'admin',
        name: 'BackAdmin',
        component: () => import('../views/back/Admin.vue'),
        meta: {
          title: '管理员管理'
        }
      },
      {
        path: 'comment',
        name: 'BackComment',
        component: () => import('../views/back/Comment.vue'),
        meta: {
          title: '评论管理'
        }
      },
      {
        path: 'banner',
        name: 'BackBanner',
        component: () => import('../views/back/Banner.vue'),
        meta: {
          title: '轮播图管理'
        }
      },
      {
        path: 'collect',
        name: 'BackCollect',
        component: () => import('../views/back/Collect.vue'),
        meta: {
          title: '收藏管理'
        }
      },
      {
        path: 'article',
        name: 'BackArticle',
        component: () => import('../views/back/Article.vue'),
        meta: {
          title: '文章管理'
        }
      },
      {
        path: 'type',
        name: 'BackType',
        component: () => import('../views/back/Type.vue'),
        meta: {
          title: '分类管理'
        }
      },
      {
        path: 'delivery',
        name: 'BackDelivery',
        component: () => import('../views/back/Delivery.vue'),
        meta: {
          title: '图书管理'
        }
      },
      {
        path: 'workRecord',
        name: 'BackWorkRecord',
        component: () => import('../views/back/MyWorkRecord.vue'),
        meta: {
          title: '借阅管理'
        }
      },
      {
        path: 'activity',
        name: 'BackActivity',
        component: () => import('../views/back/Activity.vue'),
        meta: {
          title: '活动管理'
        }
      },
      {
        path: 'activityRecord',
        name: 'BackActivityRecord',
        component: () => import('../views/back/ActivityRecord.vue'),
        meta: {
          title: '活动参与管理'
        }
      },
      // 后台子路由
    ]
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 全局前置守卫
router.beforeEach((to, from, next) => {
  const account = JSON.parse(localStorage.getItem("account") || '{}')
  if (to.matched.length === 0) {
    next('/404')
    return
  }
  if (to.path === '/') {
    if (account.role) {
      // 现在是只有角色为管理员才访问后台
      // 如果想设置其他角色登录后也默认访问后台，可以用下面的判断条件
      // account.role === 'ROLE_ADMIN' || account.role === 'ROLE_UNIT'
      if (account.role === 'ROLE_ADMIN') {
        next('/back/home')
      } else {
        next('/front/home')
      }
    } else {
      // 现在是只有登录以后才可以访问首页
      next('/login')
      // 如果想不登录就可以直接访问首页的话，直接用下面的跳转/front/home即可
      // next('/front/home')
    }
  } else {
    next()
  }
})

// 全局后置守卫
router.afterEach((to) => {
  document.title = to.meta.title ? `${to.meta.title} - ${projectName}` : projectName // 设置页面标题
})

export default router



*/
