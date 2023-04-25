const { Gateway, Wallets } = require('fabric-network');
const helper = require('./helper')
const walletPath = './wallet';

const channelName = 'channel1';

exports.createConnection = async function (userId, usedContract) {
	const gateway = new Gateway();
    const ccp = helper.buildCCPOrg1();
    const wallet = await helper.buildWallet(Wallets, walletPath);
    await gateway.connect(ccp, {
        wallet,
        identity: userId,
        discovery: { enabled: true, asLocalhost: true }
    });
    const network = await gateway.getNetwork(channelName);
    const contract = network.getContract('basic', usedContract);

    return {
        gateway: gateway,
        contract: contract
    }
};