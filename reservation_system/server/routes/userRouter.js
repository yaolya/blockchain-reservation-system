const Router = require('express')
const userController = require('../controllers/userController')
const router = new Router()
const authMiddleware = require('../middleware/authMiddleware')

router.get('/get/:id', authMiddleware, userController.getById)
router.post('/getByEmail', authMiddleware, userController.getByEmail)
router.post('/login', userController.login)
router.post('/register', userController.register)
router.put('/update', authMiddleware, userController.update)
router.delete('/delete', authMiddleware, userController.delete)

module.exports = router