import Vue from 'vue'
import BookIndex from '../../src/components/BookIndex.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue(BookIndex).$mount('#app')
})
