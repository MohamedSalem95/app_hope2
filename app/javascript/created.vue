<template>
  <div id="">
        <p class="text-success fw-bold text-end fs-5"> المواعيد المضافه حديثا </p>
      <table class="table table-sm table-bordered">
          <tbody>

                <tr v-for="user in users" :key="user.name" class="bg-light">
           <td> <b> -- </b> </td>
            <td> <b> {{  user.name  }} </b> </td>
            <td> <b class="text-uppercase">  {{ user.app_time | moment('hh:mm a') }} </b> </td>
            <td>
                <b v-if="user.description === '' ">
                    لا يوجد تفاصيل.
                </b>
                <b v-else>
                    {{ user.description }}
                </b>
            </td>
            <td>
                
                    <span v-if="user.status == 1" class="badge bg-info"> لم يدخل بعد </span>
                

                
                    <span v-if="user.status == 2" class="badge bg-primary"> تم الموافقه </span>
                

                
                    <span v-if="user.status == 3" class="badge bg-warning"> تم التاجيل </span>
                

                
                    <!-- <span class="badge bg-info"> لم يدخل بعد (مؤجل) </span> -->
                

                
                    <span v-if="user.status == 4" class="badge bg-danger"> تم الرفض </span>
                

                
                    <span v-if="user.status == 5" class="badge bg-success"> تم الدخول </span>
                
            </td>

            <td>
                <button v-if="user.visible" class="btn btn-outline-success btn-sm fw-bold" @click="approveUser(user.id)"> دخول </button>
            </td>

      </tr>
          </tbody>

      </table>
  </div>
</template>

<script>
import axios from 'axios'

import Approve from './approve.vue'

let devUrl = 'http://127.0.0.1:3000/appointments/'
let prodUrl = 'https://appmanager251.herokuapp.com/appointments/'

export default {
  components: {
      Approve
  },
  data: function () {
    return {
        count: 0,
        users: [],
        //visible: true
    }
  },
  channels: {
    AppointmentCreateChannel: {
      connected() {
        console.log('connected from create')
      },
      received(data) {
          console.log(data)
          this.id = data['id']
          axios.get(`${devUrl}${this.id}`).then(res => {
              console.log(res['data'])
              res['data'].visible = true
              this.users.splice(0, 0, res['data'])
          })
      },
      disconnected() {}
    },

     AppointmentChannel: {
      connected() {
      },
      received(data) {},
      disconnected() {}
    }
  },
  methods: {
      approveUser(id) {
          this.$cable.perform({
              channel: 'AppointmentChannel',
              action: 'approve',
              data: {
                  id: id
              }
          })
          this.users.find(user => user.id == id).visible = false
          //this.visible = false
      }
  },
  mounted () {
    /*
    if(this.status == 5 || this.status == 4 || this.status == 2 || this.status == 3) {
      this.visible = false
    }*/
    this.$cable.subscribe({
      channel: 'AppointmentCreateChannel'
    })
    this.$cable.subscribe({
      channel: 'AppointmentChannel'
    })
  }
}
</script>

<style scoped>

</style>
