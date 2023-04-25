const Router = require('express')
const router = new Router()
const itemController = require('../controllers/itemController')
const authMiddleware = require('../middleware/authMiddleware')

router.get('/getAll', authMiddleware, itemController.getAll)
router.get('/getAvailable', authMiddleware, itemController.getAvailable)
router.get('/getAllByCreator/:id', authMiddleware, itemController.getAllByCreator)
router.get('/getAllByOwner/:id', authMiddleware, itemController.getAllByOwner)
router.get('/get/:id', authMiddleware, itemController.getById)
router.get('/getHistory/:id', authMiddleware, itemController.getHistoryById)
router.post('/create', authMiddleware, itemController.create)
router.put('/update', authMiddleware, itemController.update)
router.put('/reserve', authMiddleware, itemController.reserve)
router.put('/cancel', authMiddleware, itemController.cancel)
router.delete('/delete/:id', authMiddleware, itemController.delete)

module.exports = router