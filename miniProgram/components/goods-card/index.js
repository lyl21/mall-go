
const __config = require('../../config/env')

Component({
  properties: {
    goodsList: {
      type: Array,
      value: []
    }
  },
  data: {
    imgBasePath: __config.imgBasePath
  },
  methods: {

  }
})