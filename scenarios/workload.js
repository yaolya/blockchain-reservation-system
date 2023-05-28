'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class MyWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.txIndex = -1;
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
    }
    async submitTransaction() {
        this.txIndex++;

        const itemID = "0_0_24_1684882156905";

        const request = {
            contractId: this.roundArguments.contractId,
            contractFunction: 'ReadItem',
            invokerIdentity: 'User1',
            contractArguments: [itemID],
            readOnly: true
        };

        await this.sutAdapter.sendRequests(request);
    }

}

function createWorkloadModule() {
    return new MyWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
