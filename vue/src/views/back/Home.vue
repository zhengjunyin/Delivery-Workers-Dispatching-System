<script setup>
import {onMounted, ref} from 'vue'
import request from '../../utils/request'
import * as echarts from 'echarts';

onMounted(()=>{

  const main1Dom = document.getElementById('main1');
  const myChart1 = echarts.init(main1Dom);
  const option1 = {
    title: {
      text: 'Count of Delivery Staff in Different Areas',
      subtext: 'Pie Chart',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: 'Access From',
        type: 'pie',
        radius: '50%',
        data: [],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  };

  request.get('/echarts/count1').then(res=>{
    option1.series[0].data = res.data
    option1 && myChart1.setOption(option1);
  })

  const main2Dom = document.getElementById('main2');
  const myChart2 = echarts.init(main2Dom);
  const option2 = {
    title: {
      text: 'Work Records',
      subtext: 'Bar Chart',
      left: 'center'
    },
    xAxis: {
      type: 'category',
      data: []
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        data: [],
        type: 'bar'
      }
    ]
  };

  request.get('/echarts/count2').then(res=>{
    res.data.forEach(item=>{
      option2.xAxis.data.push(item.name)
      option2.series[0].data.push(item.value)
    })
    option2 && myChart2.setOption(option2);
  })

})

</script>

<template>

  <div style="width: 100%;height: 400px;margin-top: 20px" id="main1">

  </div>

  <div style="width: 100%;height: 400px;margin-top: 20px" id="main2">

  </div>
</template>

<style scoped>
</style>





<!--
<script setup>
import {onMounted, ref} from 'vue'
import request from '../../utils/request'
import * as echarts from 'echarts';

onMounted(()=>{

  const main1Dom = document.getElementById('main1');
  const myChart1 = echarts.init(main1Dom);
  const option1 = {
    title: {
      text: '统计不同区域的配送员数量',
      subtext: '饼图',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: 'Access From',
        type: 'pie',
        radius: '50%',
        data: [],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  };

  request.get('/echarts/count1').then(res=>{
    option1.series[0].data = res.data
    option1 && myChart1.setOption(option1);
  })

  const main2Dom = document.getElementById('main2');
  const myChart2 = echarts.init(main2Dom);
  const option2 = {
    title: {
      text: '工作记录',
      subtext: '柱状图',
      left: 'center'
    },
    xAxis: {
      type: 'category',
      data: []
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        data: [],
        type: 'bar'
      }
    ]
  };

  request.get('/echarts/count2').then(res=>{
    res.data.forEach(item=>{
      option2.xAxis.data.push(item.name)
      option2.series[0].data.push(item.value)
    })
    option2 && myChart2.setOption(option2);
  })

})

</script>

<template>

  <div style="width: 100%;height: 400px;margin-top: 20px" id="main1">

  </div>

  <div style="width: 100%;height: 400px;margin-top: 20px" id="main2">

  </div>
</template>

<style scoped>
</style>-->
