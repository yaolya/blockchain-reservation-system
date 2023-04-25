const express = require('express');
const router = require('./routes/index')
const cors = require('cors')
const db = require('./repository/db')


const app = express();
app.use(express.json())
app.use(cors())
app.use('/api', router)

db.setupDb();

app.listen(8081, () => {
  console.log('listening for requests on port 8081')
})