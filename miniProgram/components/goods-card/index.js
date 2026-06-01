
const __config = require('../../config/env')

Component({
  properties: {
    goodsList: {
      type: Object,
      value: []
    }
  },
  data: {
    imgBasePath: __config.imgBasePath
  },
  methods: {

  }
})