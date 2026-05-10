//工作记录
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
  request.get("/workRecord/page", {
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


const back = (id) => {
  request.get('/workRecord/back/'+id).then(res=>{
    if (res.code==='200'){
      ElMessage.success(tr('Completed successfully'))
      load()
    }
  })
}



// 保存
const save = () => {


  request.post("/workRecord", form.value).then(res => {
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
  request.delete("/workRecord/" + id).then(res => {
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
  request.post("/workRecord/del/batch", ids).then(res => {
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
      tr('Are you sure you want to delete this data?'),
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
      tr('Are you sure you want to batch delete these data?'),
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



const deliverys = ref([]);
const loadDelivery = () => {
  request.get('/delivery').then(res => {
    deliverys.value = res.data;
  });
};
loadDelivery();

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
      <el-input v-model="searchForm.keyword" :placeholder="$tr('Please enter delivery person name')" class="filter-input" :prefix-icon="Search" clearable/>
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
        <el-table-column :label="$tr('Delivery Person Name')" align="center">
          <template #default="scope">
            <span v-if="scope.row.deliveryId">{{ deliverys.find(item => item.id === scope.row.deliveryId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="$tr('Dispatcher')" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.userId">{{ users.find(item => item.id === scope.row.userId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="date" :label="$tr('Outing Date')" width="100" align="center"/>
        <el-table-column prop="endDate" :label="$tr('Estimated Completion Time')" width="100" align="center"/>
        <el-table-column prop="backTime" :label="$tr('Actual Completion Time')" width="140" align="center"/>
        <!--
                <el-table-column :label="$tr('Status')" width="100" align="center">
                  <template #default="scope">
                    <el-tag>{{scope.row.status}}</el-tag>
                  </template>
                </el-table-column>
        -->
        <el-table-column :label="$tr('Status')" width="100" align="center">
          <template #default="scope">
            <!-- 将状态显示文字进行转换：'借阅中'→'外出中'，'已归还'→'已完成' -->
            <el-tag>{{ scope.row.status === 'At work' ? $tr('At work') : $tr('Finished') }}</el-tag>
          </template>
        </el-table-column>

        <!--        <el-table-column label="是否完成"  width="180" align="center">
                  <template v-slot:="scope">
                    <el-button type="success" @click="back(scope.row.id)" v-if="scope.row.status ==='借阅中'" >{{ $tr('Complete') }}</el-button>
                  </template>
                </el-table-column>-->

        <el-table-column :label="$tr('Completion Status')"  width="180" align="center">
          <template #default="scope">
            <!-- 修改按钮文字：'归还'→'完成'，同时修改判断条件：'借阅中'→'外出中' -->
            <el-button type="success" @click="back(scope.row.id)" v-if="scope.row.status ==='At work'" >{{ $tr('Complete') }}</el-button>
          </template>
        </el-table-column>

        <el-table-column :label="$tr('Operation')" width="120" align="center" fixed="right">
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
        <el-form-item :label="$tr('Delivery Person')">
          <el-select v-model="form.deliveryId" :placeholder="$tr('Please select delivery person')" style="width: 220px">
            <el-option v-for="item in deliverys" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('Dispatcher')">
          <el-select v-model="form.userId" :placeholder="$tr('Please select dispatcher')" style="width: 220px">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('Outing Date')">
          <el-date-picker v-model="form.date" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('Select date')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('Estimated Completion Time')">
          <el-date-picker v-model="form.endDate" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('Select date')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('Actual Completion Time')">
          <el-date-picker v-model="form.backTime" type="datetime" value-format="YYYY-MM-DD hh:mm:ss" :placeholder="$tr('Select date and time')"></el-date-picker>
        </el-form-item>
        <!--        <el-form-item :label="$tr('Status')">
                  <el-radio-group v-model="form.status">
                    <el-radio :value="'Completed'">{{ $tr('Completed') }}</el-radio>
                  </el-radio-group>
                </el-form-item>-->

        <el-form-item :label="$tr('Status')">
          <el-radio-group v-model="form.status">
            <!-- 注意：这里需要根据实际业务逻辑决定 -->
            <!-- 如果是新增，默认设置为'外出中'；如果是编辑，保持原值 -->
            <el-radio :value="'At work'">{{ $tr('At work') }}</el-radio>
            <el-radio :value="'Finished'">{{ $tr('Finished') }}</el-radio>
          </el-radio-group>
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





//中文
<!--<script setup>
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
  request.get("/workRecord/page", {
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


const back = (id) => {
  request.get('/workRecord/back/'+id).then(res=>{
    if (res.code==='200'){
      ElMessage.success("归还成功")
      load()
    }
  })
}



// 保存
const save = () => {


  request.post("/workRecord", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('保存成功'))
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error(tr('保存失败'))
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
  request.delete("/workRecord/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('删除成功'))
      load()
    } else {
      ElMessage.error(tr('删除失败'))
    }
  })
}

// 批量删除
const delBatch = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning(tr('请至少选择一条记录'))
    return
  }

  const ids = multipleSelection.value.map(v => v.id)
  request.post("/workRecord/del/batch", ids).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('批量删除成功'))
      load()
    } else {
      ElMessage.error(tr('批量删除失败'))
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
      tr('确定要删除这条数据吗？'),
      tr('警告'),
      {
        confirmButtonText: tr('确定'),
        cancelButtonText: tr('取消'),
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
    ElMessage.warning(tr('请至少选择一条记录'))
    return
  }

  ElMessageBox.confirm(
      tr('确定要批量删除这些数据吗？'),
      tr('警告'),
      {
        confirmButtonText: tr('确定'),
        cancelButtonText: tr('取消'),
        type: 'warning',
      }
  )
      .then(() => {
        delBatch()
      })
}



const deliverys = ref([]);
const loadDelivery = () => {
  request.get('/delivery').then(res => {
    deliverys.value = res.data;
  });
};
loadDelivery();

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

    &lt;!&ndash; 搜索区域 &ndash;&gt;
    <div class="header-section">
      <el-input v-model="searchForm.keyword" placeholder="请输入配送员名字称" class="filter-input" :prefix-icon="Search" clearable/>
      <el-button class="ml-10" plain type="primary" @click="load">{{ $tr('搜索') }}</el-button>
      <el-button plain type="info" @click="reset">{{ $tr('重置') }}</el-button>
    </div>

    &lt;!&ndash; 操作按钮区域 &ndash;&gt;
    <div class="toolbar-section">
      &lt;!&ndash;      <el-button plain type="primary" @click="handleAdd" :icon="Plus">{{ $tr('新增') }}</el-button>&ndash;&gt;
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">{{ $tr('批量删除') }}</el-button>
    </div>

    &lt;!&ndash; 表格区域 &ndash;&gt;
    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center"/>
        <el-table-column prop="id" label="ID" width="80" align="center"/>
        <el-table-column label="配送员名字" align="center">
          <template #default="scope">
            <span v-if="scope.row.deliveryId">{{ deliverys.find(item => item.id === scope.row.deliveryId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="$tr('调度员')" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.userId">{{ users.find(item => item.id === scope.row.userId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="date" :label="$tr('外出日期')" width="100" align="center"/>
        <el-table-column prop="endDate" :label="$tr('预计完成时间')" width="100" align="center"/>
        <el-table-column prop="backTime" :label="$tr('实际完成时间')" width="140" align="center"/>
&lt;!&ndash;
        <el-table-column :label="$tr('状态')" width="100" align="center">
          <template #default="scope">
            <el-tag>{{scope.row.status}}</el-tag>
          </template>
        </el-table-column>
&ndash;&gt;
        <el-table-column :label="$tr('状态')" width="100" align="center">
          <template #default="scope">
            &lt;!&ndash; 将状态显示文字进行转换：'借阅中'→'外出中'，'已归还'→'已完成' &ndash;&gt;
            <el-tag>{{scope.row.status === '借阅中' ? '外出中' : '已完成'}}</el-tag>
          </template>
        </el-table-column>

&lt;!&ndash;        <el-table-column label="是否完成"  width="180" align="center">
          <template v-slot:="scope">
            <el-button type="success" @click="back(scope.row.id)" v-if="scope.row.status ==='借阅中'" >归还</el-button>
          </template>
        </el-table-column>&ndash;&gt;

        <el-table-column label="是否完成"  width="180" align="center">
          <template #default="scope">
            &lt;!&ndash; 修改按钮文字：'归还'→'完成'，同时修改判断条件：'借阅中'→'外出中' &ndash;&gt;
            <el-button type="success" @click="back(scope.row.id)" v-if="scope.row.status ==='借阅中'" >{{ $tr('完成') }}</el-button>
          </template>
        </el-table-column>

        <el-table-column :label="$tr('操作')" width="120" align="center" fixed="right">
          <template #default="scope">
            &lt;!&ndash;            <el-tooltip :content="$tr('编辑')" placement="top" :effect="'light'">&ndash;&gt;
            &lt;!&ndash;              <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)"/>&ndash;&gt;
            &lt;!&ndash;            </el-tooltip>&ndash;&gt;
            <el-tooltip :content="$tr('删除')" placement="top" :effect="'light'">
              <el-button circle type="danger" :icon="Delete" @click="confirmDelete(scope.row.id)"/>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      &lt;!&ndash; 分页区域 &ndash;&gt;
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

    &lt;!&ndash; 表单对话框 &ndash;&gt;
    <el-dialog v-model="dialogFormVisible" :title="form.id ? '编辑' : '新增'" width="30%" center>
      <el-form :model="form" label-width="100px">
        <el-form-item :label="$tr('配送员')">
          <el-select v-model="form.deliveryId" placeholder="请选择配送员" style="width: 220px">
            <el-option v-for="item in deliverys" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('配送员')">
          <el-select v-model="form.userId" placeholder="请选择配送员" style="width: 220px">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('外出日期')">
          <el-date-picker v-model="form.date" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('选择日期')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('预计完成时间')">
          <el-date-picker v-model="form.endDate" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('选择日期')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('实际完成时间')">
          <el-date-picker v-model="form.backTime" type="datetime" value-format="YYYY-MM-DD hh:mm:ss" placeholder="选择日期时间"></el-date-picker>
        </el-form-item>
&lt;!&ndash;        <el-form-item :label="$tr('状态')">
          <el-radio-group v-model="form.status">
            <el-radio :value="'已完成'">{{ $tr('已完成') }}</el-radio>
          </el-radio-group>
        </el-form-item>&ndash;&gt;

        <el-form-item :label="$tr('状态')">
          <el-radio-group v-model="form.status">
            &lt;!&ndash; 注意：这里需要根据实际业务逻辑决定 &ndash;&gt;
            &lt;!&ndash; 如果是新增，默认设置为'外出中'；如果是编辑，保持原值 &ndash;&gt;
            <el-radio :value="'外出中'">{{ $tr('外出中') }}</el-radio>
            <el-radio :value="'已完成'">{{ $tr('已完成') }}</el-radio>
          </el-radio-group>
        </el-form-item>

      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible = false">{{ $tr('取消') }}</el-button>
          <el-button type="primary" @click="save">{{ $tr('确定') }}</el-button>
        </div>
      </template>

    </el-dialog>


  </div>
</template>

<style scoped>


</style>-->
//原版
<!--

<script setup>
import { ref, reactive } from 'vue'
import { Search, Plus, Delete, Edit } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'


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
  request.get("/workRecord/page", {
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


const back = (id) => {
  request.get('/workRecord/back/'+id).then(res=>{
    if (res.code==='200'){
      ElMessage.success("归还成功")
      load()
    }
  })
}



// 保存
const save = () => {


  request.post("/workRecord", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success("保存成功")
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error("保存失败")
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
  request.delete("/workRecord/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success("删除成功")
      load()
    } else {
      ElMessage.error("删除失败")
    }
  })
}

// 批量删除
const delBatch = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning("请至少选择一条记录")
    return
  }

  const ids = multipleSelection.value.map(v => v.id)
  request.post("/workRecord/del/batch", ids).then(res => {
    if (res.code === '200') {
      ElMessage.success("批量删除成功")
      load()
    } else {
      ElMessage.error("批量删除失败")
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
      '确定要删除这条数据吗？',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
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
    ElMessage.warning("请至少选择一条记录")
    return
  }

  ElMessageBox.confirm(
      '确定要批量删除这些数据吗？',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  )
      .then(() => {
        delBatch()
      })
}



const deliverys = ref([]);
const loadDelivery = () => {
  request.get('/delivery').then(res => {
    deliverys.value = res.data;
  });
};
loadDelivery();

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

    &lt;!&ndash; 搜索区域 &ndash;&gt;
    <div class="header-section">
      <el-input v-model="searchForm.keyword" placeholder="请输入借阅图书名称" class="filter-input" :prefix-icon="Search" clearable/>
      <el-button class="ml-10" plain type="primary" @click="load">搜索</el-button>
      <el-button plain type="info" @click="reset">重置</el-button>
    </div>

    &lt;!&ndash; 操作按钮区域 &ndash;&gt;
    <div class="toolbar-section">
&lt;!&ndash;      <el-button plain type="primary" @click="handleAdd" :icon="Plus">新增</el-button>&ndash;&gt;
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">批量删除</el-button>
    </div>

    &lt;!&ndash; 表格区域 &ndash;&gt;
    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center"/>
        <el-table-column prop="id" label="ID" width="80" align="center"/>
        <el-table-column label="图书名称" align="center">
          <template #default="scope">
            <span v-if="scope.row.deliveryId">{{ deliverys.find(item => item.id === scope.row.deliveryId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column label="借阅人" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.userId">{{ users.find(item => item.id === scope.row.userId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="date" label="借阅日期" width="100" align="center"/>
        <el-table-column prop="endDate" label="预计归还时间" width="100" align="center"/>
        <el-table-column prop="backTime" label="实际归还时间" width="140" align="center"/>
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag>{{scope.row.status}}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="还书"  width="180" align="center">
          <template v-slot:="scope">
            <el-button type="success" @click="back(scope.row.id)" v-if="scope.row.status ==='借阅中'" >归还</el-button>
          </template>
        </el-table-column>


        <el-table-column label="操作" width="120" align="center" fixed="right">
          <template #default="scope">
&lt;!&ndash;            <el-tooltip content="编辑" placement="top" :effect="'light'">&ndash;&gt;
&lt;!&ndash;              <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)"/>&ndash;&gt;
&lt;!&ndash;            </el-tooltip>&ndash;&gt;
            <el-tooltip content="删除" placement="top" :effect="'light'">
              <el-button circle type="danger" :icon="Delete" @click="confirmDelete(scope.row.id)"/>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      &lt;!&ndash; 分页区域 &ndash;&gt;
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

    &lt;!&ndash; 表单对话框 &ndash;&gt;
    <el-dialog v-model="dialogFormVisible" :title="form.id ? '编辑' : '新增'" width="30%" center>
      <el-form :model="form" label-width="100px">
        <el-form-item label="图书">
          <el-select v-model="form.deliveryId" placeholder="请选择图书" style="width: 220px">
            <el-option v-for="item in deliverys" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="借阅人">
          <el-select v-model="form.userId" placeholder="请选择借阅人" style="width: 220px">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="借阅日期">
          <el-date-picker v-model="form.date" type="date" value-format="YYYY-MM-DD" placeholder="选择日期"></el-date-picker>
        </el-form-item>
        <el-form-item label="预计归还时间">
          <el-date-picker v-model="form.endDate" type="date" value-format="YYYY-MM-DD" placeholder="选择日期"></el-date-picker>
        </el-form-item>
        <el-form-item label="实际归还时间">
          <el-date-picker v-model="form.backTime" type="datetime" value-format="YYYY-MM-DD hh:mm:ss" placeholder="选择日期时间"></el-date-picker>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="'已归还'">已归还</el-radio>
          </el-radio-group>
        </el-form-item>

      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取消</el-button>
          <el-button type="primary" @click="save">确定</el-button>
        </div>
      </template>

    </el-dialog>


  </div>
</template>

<style scoped>


</style>-->
