const axios = require('axios');
axios.post('http://localhost:3000/send-message', {
  phone: 'TEST',
  message: 'test'
}).then(console.log).catch(console.error);
