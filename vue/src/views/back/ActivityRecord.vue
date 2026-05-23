
//Activity Record 活动记录
<script setup>
import { ref, reactive } from 'vue'
import { Search, Plus, Delete, Edit } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'
import { t, tr } from '@/i18n'
import { normalizeRequiredBelarusPhone } from '@/utils/phone'


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
  request.get("/activityRecord/page", {
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

const join = (id) => {
  request.get('/activityRecord/join/'+id).then(res=>{
    if (res.code==='200'){
      ElMessage.success(tr('Activity Checked In'))
      load()
    }
  })
}


// 保存
const save = () => {

  try {
    form.value.phone = normalizeRequiredBelarusPhone(form.value.phone)
  } catch (error) {
    ElMessage.error(error.message)
    return
  }

  request.post("/activityRecord", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success(t('common.saveSuccess'))
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error(res.msg || t('common.saveFailed'))
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
  request.delete("/activityRecord/" + id).then(res => {
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
  request.post("/activityRecord/del/batch", ids).then(res => {
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



const activitys = ref([]);
const loadActivity = () => {
  request.get('/activity').then(res => {
    activitys.value = res.data;
  });
};
loadActivity();

const users = ref([]);
const loadUser = () => {
  request.get('/user').then(res => {
    users.value = res.data;
  });
};
loadUser();


</script>

<template>
  <div class="content-container">

    <!-- 搜索区域 -->
    <div class="header-section">
      <el-input v-model="searchForm.keyword" :placeholder="$tr('Please enter activity ID')" class="filter-input" :prefix-icon="Search" clearable/>
      <el-button class="ml-10" plain type="primary" @click="load">{{ $tr('Search') }}</el-button>
      <el-button plain type="info" @click="reset">{{ $tr('Reset') }}</el-button>
    </div>

    <!-- 操作按钮区域 -->
    <div class="toolbar-section">
      <!--      <el-button plain type="primary" @click="handleAdd" :icon="Plus">{{ $tr('Add') }}</el-button>-->
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">{{ $tr('Batch Delete') }}</el-button>
    </div>

    <!-- 表格区域 -->
    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center"/>
        <el-table-column prop="id" label="ID" width="80" align="center"/>
        <el-table-column :label="$tr('Activity')" width="120" align="center">
          <template #default="scope">
            <span v-if="scope.row.itemId">{{ activitys.find(item => item.id === scope.row.itemId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="$tr('User')" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.userId">{{ users.find(item => item.id === scope.row.userId)?.nickname }}</span>
          </template>
        </el-table-column>
        <!--        <el-table-column prop="time" :label="$tr('Check-in Time')" width="140" align="center"/>-->
        <!--        <el-table-column :label="$tr('Status')" width="100" align="center">
                  <template #default="scope">
                    <el-tag>{{scope.row.status}}</el-tag>
                  </template>
                </el-table-column>-->
        <el-table-column prop="name" :label="$tr('Registrant Name')"/>
        <el-table-column prop="phone" :label="$tr('Registrant Phone')"/>
        <!--        <el-table-column label="Check-in"  width="240" align="center">-->
        <!--          <template v-slot:="scope"  width="280">-->
        <!--            <el-button type="primary" v-if="scope.row.status==='Not Cheaked In'" @click="join(scope.row.id)">Check In</el-button>-->
        <!--          </template>-->
<!--        </el-table-column>-->
        <el-table-column :label="$tr('Actions')" width="120" align="center" fixed="right">
          <template #default="scope">
            <!--            <el-tooltip :content="$tr('Edit')" placement="top" :effect="'light'">-->
            <!--              <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)"/>-->
            <!--            </el-tooltip>-->
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
        <el-form-item :label="$tr('Activity')">
          <el-select v-model="form.itemId" :placeholder="$tr('Please select activity')" style="width: 220px">
            <el-option v-for="item in activitys" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('User')">
          <el-select v-model="form.userId" :placeholder="$tr('Please select user')" style="width: 220px">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('Activity Start Date')">
          <el-date-picker v-model="form.startDate" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('Select date')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('Check-in Time')">
          <el-date-picker v-model="form.time" type="datetime" value-format="YYYY-MM-DD hh:mm:ss" :placeholder="$tr('Select date and time')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('Status')">
          <el-radio-group v-model="form.status">
            <el-radio :value="'Not checked in'">{{ $tr('Not checked in') }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="$tr('Registrant Name')" required>
          <el-input v-model="form.name" :placeholder="$tr('Please enter registrant name')"/>
        </el-form-item>
        <el-form-item :label="$tr('Registrant Phone')">
          <el-input v-model="form.phone" :placeholder="$tr('Please enter registrant phone')"/>
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







