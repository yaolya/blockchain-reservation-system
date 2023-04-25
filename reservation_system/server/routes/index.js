const Router = require('express')
const router = new Router()
const userRouter = require('./userRouter')
const bookRouter = require('./itemRouter')

router.use('/user', userRouter)
router.use('/item', bookRouter)

module.exports = router