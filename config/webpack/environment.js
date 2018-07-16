const { environment } = require('@rails/webpacker')

const VueLoaderPlugin = require('vue-loader/lib/plugin')
const typescript =  require('./loaders/typescript')
const vue =  require('./loaders/vue')

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue)
environment.loaders.append('typescript', typescript)

module.exports = environment
