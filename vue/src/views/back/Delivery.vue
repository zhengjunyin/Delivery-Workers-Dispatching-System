//配送员信息
<script setup>
import { ref, reactive, shallowRef } from 'vue'
import { Search, Plus, Delete, Edit, UploadFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'
import { serverHost } from '../../../config/config.default'
import '@wangeditor/editor/dist/css/style.css'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import axios from "axios"
import { t, tr } from '@/i18n'
import { normalizeOptionalBelarusPhone } from '@/utils/phone'


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
const uploadHeaders = { token: account.value.token || '' }

// 加载数据
const load = () => {
  request.get("/delivery/page", {
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

  form.value.content = htmlContent.value;
  try {
    form.value.isbn = normalizeOptionalBelarusPhone(form.value.isbn)
  } catch (error) {
    ElMessage.error(error.message)
    return
  }

  request.post("/delivery", form.value).then(res => {
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

  htmlContent.value = '';

  form.value = {}
  dialogFormVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  form.value = JSON.parse(JSON.stringify(row))

  htmlContent.value = form.value.content || '';

  dialogFormVisible.value = true
}

// 删除
const del = (id) => {
  request.delete("/delivery/" + id).then(res => {
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
  request.post("/delivery/del/batch", ids).then(res => {
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

// 封面上传
const handleImgUploadSuccess = (res) => {
  form.value.img = res;
};

// 详情描述富文本
const htmlContent = ref('');
const editorRefContent = shallowRef();

// 改变状态
const changeState = (row) => {
  form.value = JSON.parse(JSON.stringify(row))
  try {
    form.value.isbn = normalizeOptionalBelarusPhone(form.value.isbn)
  } catch (error) {
    ElMessage.error(error.message)
    return
  }
  request.post("/delivery", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success(tr('Saved successfully'))
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error(tr('Save failed'))
    }
  })
}

// 查看
const contentViewVisible = ref(false)
const currentViewContent = ref('')

const viewContent = (content) => {
  currentViewContent.value = content || ''
  contentViewVisible.value = true
}

// 自定义上传方法
const customUpload = (file, insertFn) => {
  const formData = new FormData()
  formData.append('file', file)
  axios({
    url: `${serverHost}/web/upload`,
    method: 'post',
    data: formData,
    headers: {'Content-Type': 'multipart/form-data', token: account.value.token || ''},
  }).then(res => {
    insertFn(res.data)
  }).catch((error) => {
    console.error('Error:', error)
    ElMessage.error(tr('Upload failed'))
  })
}

// wangEditor 配置
const editorConfig = {
  placeholder: 'Please enter content...',
  MENU_CONF: {
    uploadImage: {
      customUpload: async (file, insertFn) => {
        customUpload(file, insertFn)
      },
    },
    uploadVideo: {
      customUpload: async (file, insertFn) => {
        customUpload(file, insertFn)
      },
    },
  }
}

const types = ref([]);
const loadType = () => {
  request.get('/type').then(res => {
    types.value = res.data;
  });
};
loadType();



</script>

<template>
  <div class="content-container">

    <!-- 搜索区域 -->
    <div class="header-section">
      <el-input v-model="searchForm.keyword" :placeholder="$tr('Please enter name')" class="filter-input" :prefix-icon="Search" clearable/>
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
        <el-table-column prop="name" :label="$tr('Name')"/>


        <el-table-column prop="isbn" :label="$tr('Phone')"/>
        <el-table-column :label="$tr('Type')" width="100" align="center">
          <template #default="scope">
            <span v-if="scope.row.typeId">{{ types.find(item => item.id === scope.row.typeId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="$tr('Image')" width="120" align="center">
          <template #default="scope">
            <el-image style="width: 80px; height: 80px" :src="scope.row.img" :preview-src-list="[scope.row.img]" :preview-teleported=true></el-image>
          </template>
        </el-table-column>
        <el-table-column prop="info" :label="$tr('Rating')"/>
        <el-table-column prop="date" :label="$tr('Join Date')" width="100" align="center"/>
        <el-table-column :label="$tr('On Duty')" width="100" align="center">
          <template #default="scope">
            <el-switch v-model="scope.row.status" @change="changeState(scope.row)"/>
          </template>
        </el-table-column>
<!--        <el-table-column prop="num" :label="$tr('Task Count')"/>-->
        <el-table-column :label="$tr('Details')" width="100" align="center">
          <template #default="scope">
            <el-button type="primary" @click="viewContent(scope.row.content)">{{ $tr('View') }}</el-button>
          </template>
        </el-table-column>

        <el-table-column :label="$tr('Operations')" width="120" align="center" fixed="right">
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
    <el-dialog v-model="dialogFormVisible" :title="form.id ? $tr('Edit') : $tr('Add')" width="40%" center>
      <el-form :model="form" label-width="100px">
        <el-form-item :label="$tr('Name')">
          <el-input v-model="form.name" :placeholder="$tr('Please enter name')"/>
        </el-form-item>

        <el-form-item :label="$tr('Phone')">
          <el-input v-model="form.isbn" :placeholder="$tr('Phone number')"/>
        </el-form-item>
        <el-form-item :label="$tr('Type')">
          <el-select v-model="form.typeId" :placeholder="$tr('Please select type')" style="width: 220px">
            <el-option v-for="item in types" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$tr('Image')">
          <div class="upload-container">
            <el-avatar v-if="form.img" :src="form.img" :size="80" />
              <el-upload :action="`${serverHost}/web/upload`" :headers="uploadHeaders" :on-success="handleImgUploadSuccess" :show-file-list="false">
              <el-button type="primary" :icon="UploadFilled">{{ form.img ? $tr('Change Image') : $tr('Upload Image') }}</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item :label="$tr('Rating')">
          <el-input v-model="form.info" type="textarea" :placeholder="$tr('Please enter rating')"/>
        </el-form-item>
        <el-form-item :label="$tr('Join Date')">
          <el-date-picker v-model="form.date" type="date" value-format="YYYY-MM-DD" :placeholder="$tr('Select date')"></el-date-picker>
        </el-form-item>
        <el-form-item :label="$tr('On Duty')">
          <el-switch v-model="form.status"/>
        </el-form-item>
        <el-form-item :label="$tr('Task Count')">
          <el-input v-model="form.num" type="number" :placeholder="$tr('Please enter')"/>
        </el-form-item>
        <el-form-item :label="$tr('Details')">
          <div style="border: 1px solid #ccc; z-index: 100;">
            <Toolbar style="border-bottom: 1px solid #ccc" :editor="editorRefContent" :defaultConfig="editorConfig" mode="default" />
            <Editor style="height: 300px; overflow-y: hidden;" v-model="htmlContent" :defaultConfig="editorConfig" mode="default" @onCreated="editorRefContent = $event" />
          </div>
        </el-form-item>

      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible = false">{{ $tr('Cancel') }}</el-button>
          <el-button type="primary" @click="save">{{ $tr('Confirm') }}</el-button>
        </div>
      </template>

    </el-dialog>

    <el-dialog v-model="contentViewVisible" :title="$tr('Details')" width="40%" center>
      <div v-html="currentViewContent"></div>
    </el-dialog>

  </div>
</template>

<style scoped>


</style>






