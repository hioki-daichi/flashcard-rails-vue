<template>
  <div>
    <h2>Books</h2>
    <ul v-for="book in books">
      <li>{{ book.title }}</li>
    </ul>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      books: [{ title: 'foo' }, { title: 'bar' }]
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
