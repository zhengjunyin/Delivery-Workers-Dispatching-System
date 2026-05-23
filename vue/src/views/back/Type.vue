//区域
<script setup>
import { ref, reactive } from 'vue'
import { Search, Plus, Delete, Edit } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'
import { tr } from '@/i18n'


// 表格数据
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

// 搜索条件
const searchForm = reactive({
  keyword: '',
})

// 表单数据
const form = ref({})
const dialogFormVisible = ref(false)
const multipleSelection = ref([])

// 用户信息
const account = ref(localStorage.getItem('account') ? JSON.parse(localStorage.getItem('account')) : {})

// 加载数据
const load = () => {
  request.get("/type/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
    }
  }).then(res => {
    if (res.data) {
      tableData.value = res.data.records
      total.value = res.data.total
    }
  })
}
load()

// 保存
const save = () => {


  request.post("/type", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Save successful'))
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error(tr('Save failed'))
    }
  })
}

// 添加
const handleAdd = () => {


  form.value = {}
  dialogFormVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  form.value = JSON.parse(JSON.stringify(row))


  dialogFormVisible.value = true
}

// 删除
const del = (id) => {
  request.delete("/type/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Delete successful'))
      load()
    } else {
      ElMessage.error(tr('Delete failed'))
    }
  })
}

// 批量删除
const delBatch = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning(tr('Please select at least one record'))
    return
  }

  const ids = multipleSelection.value.map(v => v.id)
  request.post("/type/del/batch", ids).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Batch delete successful'))
      load()
    } else {
      ElMessage.error(tr('Batch delete failed'))
    }
  })
}

// 重置搜索
const reset = () => {
  searchForm.keyword = ""
  load()
}

// 表格选择变化
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}

// 分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  load()
}

// 页码变化
const handleCurrentChange = (current) => {
  pageNum.value = current
  load()
}

// 确认删除
const confirmDelete = (id) => {
  ElMessageBox.confirm(
      tr('Are you sure to delete this data?'),
      tr('Warning'),
      {
        confirmButtonText: tr('Confirm'),
        cancelButtonText: tr('Cancel'),
        type: 'warning',
      }
  )
      .then(() => {
        del(id)
      })
}

// 确认批量删除
const confirmBatchDelete = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning(tr('Please select at least one record'))
    return
  }

  ElMessageBox.confirm(
      tr('Are you sure to batch delete these data?'),
      tr('Warning'),
      {
        confirmButtonText: tr('Confirm'),
        cancelButtonText: tr('Cancel'),
        type: 'warning',
      }
  )
      .then(() => {
        delBatch()
      })
}





</script>

<template>
  <div class="content-container">

    <!-- 搜索区域 -->
    <div class="header-section">
      <el-input v-model="searchForm.keyword" :placeholder="$tr('Please enter area name')" class="filter-input" :prefix-icon="Search" clearable/>
      <el-button class="ml-10" plain type="primary" @click="load">{{ $tr('Search') }}</el-button>
      <el-button plain type="info" @click="reset">{{ $tr('Reset') }}</el-button>
    </div>

    <!-- 操作按钮区域 -->
    <div class="toolbar-section">
      <el-button plain type="primary" @click="handleAdd" :icon="Plus">{{ $tr('Add') }}</el-button>
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">{{ $tr('Batch Delete') }}</el-button>
    </div>

    <!-- 表格区域 -->
    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center"/>
        <el-table-column prop="id" label="ID" width="80" align="center"/>
        <el-table-column prop="name" :label="$tr('Area')"/>

        <el-table-column :label="$tr('Actions')" width="120" align="center" fixed="right">
          <template #default="scope">
            <el-tooltip :content="$tr('Edit')" placement="top" :effect="'light'">
              <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)"/>
            </el-tooltip>
            <el-tooltip :content="$tr('Delete')" placement="top" :effect="'light'">
              <el-button circle type="danger" :icon="Delete" @click="confirmDelete(scope.row.id)"/>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页区域 -->
      <div class="pagination-section">
        <el-pagination
            v-model:current-page="pageNum"
            v-model:page-size="pageSize"
            :page-sizes="[10, 20, 50, 100]"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 表单对话框 -->
    <el-dialog v-model="dialogFormVisible" :title="form.id ? $tr('Edit') : $tr('Add')" width="30%" center>
      <el-form :model="form" label-width="100px">
        <el-form-item :label="$tr('Area')" required>
          <el-input v-model="form.name" :placeholder="$tr('Please enter area name')"/>
        </el-form-item>

      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible = false">{{ $tr('Cancel') }}</el-button>
          <el-button type="primary" @click="save">{{ $tr('Confirm') }}</el-button>
        </div>
      </template>

    </el-dialog>


  </div>
</template>

<style scoped>


</style>



