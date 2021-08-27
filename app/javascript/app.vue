<template>
  <div id="">
    <p>{{ message }}</p>
    <button class="btn btn-outline-info" @click="sendId"> Send </button>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  },
  channels: {
    AppointmentChannel: {
      connected() {
        console.log('connected to channel LOL')
      },
      received(data) {
        console.log(data['id'])
        this.message = data['id']
      },
      disconnected() {}
    }
  },
  methods: {
    sendId() {
      this.$cable.perform({
        channel: 'AppointmentChannel',
        action: 'approve',
        data: {
          id: 10
        }
      })
    }
  },
  mounted () {
    this.$cable.subscribe({
      channel: 'AppointmentChannel'
    })
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
