const Router = require('express')
const router = new Router()
const groupController = require('../controllers/groupController')
const authMiddleware = require('../middleware/authMiddleware')

router.get('/getAll', authMiddleware, groupController.getAll)
router.get('/getAllByCreator/:id', authMiddleware, groupController.getAllByCreator)
router.get('/get/:id', authMiddleware, groupController.getById)
router.post('/create', authMiddleware, groupController.create)
router.put('/update', authMiddleware, groupController.update)
router.delete('/delete/:id', authMiddleware, groupController.delete)

module.exports = router