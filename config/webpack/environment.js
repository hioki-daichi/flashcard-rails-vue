const { environment } = require('@rails/webpacker')

const VueLoaderPlugin = require('vue-loader/lib/plugin')
const vue             = require('./loaders/vue')
const typescript      = require('./loaders/typescript')

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

environment.loaders.append('vue', vue)
environment.loaders.append('typescript', typescript)

module.exports = environment
