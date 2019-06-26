<template>
  <div>
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col s2 m1">
        <div @click="createTask" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>

    <!-- タスク一覧 -->
    <div>
      <ul class="collection">
        <template v-for="task in tasks">
          <li 
            v-if="!task.is_done"
            :key="task.id"
            :id="'row_task_' + task.id"
            class="collection-item">
            <label :for="'task_' + task.id">
              <input 
                type="checkbox" 
                :id="'task_' + task.id" 
                @change="doneTask(task.id)"/>
              <span>{{ task.name }}</span>
            </label>
          </li>
        </template>
      </ul>
    </div>

    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" @click="displayFinishedTasks">Display finished tasks</div>

    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <template v-for="task in tasks">
          <li 
            v-if="task.is_done"
            :key="task.id"
            :id="'row_task_' + task.id"
            class="collection-item">
            <label :for="'task_' + task.id" class="linethrough">
              <input type="checkbox" :id="'task_' + task.id" checked/>
              <span>{{ task.name }}</span>
            </label>
          </li>
        </template>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
import { request } from 'http';

  export default {
    data: function () {
      return {
        tasks: [],
        newTask: ''
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks').then(
          (response) => {
            for (var i = 0; i < response.data.tasks.length; i++) {
              this.tasks.push(response.data.tasks[i]);
            }
          },
          (error) => {
            console.warn(error);
          }
        );
      },
      displayFinishedTasks: function () {
        document.querySelector('#finished-tasks').classList.toggle('display_none')
      },
      createTask: function () {
        if (!this.newTask) return;

        const params = {
          task: {
            name: this.newTask
          }
        };

        axios.post('/api/tasks', params).then(
          (response) => {
            this.tasks.unshift(response.data.task);
          },
          (error) => {
            console.log(error);
          }
        );
      },
      doneTask: function (task_id) {
        const params = {
          task: {
            is_done: 1
          }
        }

        axios.put('/api/tasks/' + task_id, params).then(
          (response) => {
            this.moveFinishedTask(task_id);
          },
          (error) => {
            console.log(error);
          }
        )
      },
      moveFinishedTask: function (task_id) {

        for (let task of this.tasks) {
          if (task.id == task_id) {
            task.is_done = 1
          }
        }
      }
    }
  }
</script>

<style scoped>
  [v-cloak] {
    display: none;
  }
  .display_none {
    display: none;
  }
  /* 打ち消し線を引く */
  .line-through {
    text-decoration: line-through;
  }
</style>

