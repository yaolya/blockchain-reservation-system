const Router = require('express')
const router = new Router()
const userRouter = require('./userRouter')
const itemRouter = require('./itemRouter')
const groupRouter = require('./groupRouter')

router.use('/user', userRouter)
router.use('/item', itemRouter)
router.use('/group', groupRouter)

module.exports = router