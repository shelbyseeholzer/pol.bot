//1.creates a client that talks to server
//2. 
const {
    Client,
    PrivateKey,
    AccountCreateTransaction,
    AccountBalanceQuery,
    Hbar,
    TransferTransaction,
    ContractExecuteTransaction,
    ContractFunctionParameters,
} = require("@hashgraph/sdk");

require("dotenv").config();


//Grab your Hedera testnet account ID and private key from your .env file
const myAccountId = process.env.MY_ACCOUNT_ID;
const myPrivateKey = process.env.MY_PRIVATE_KEY;

if (!myAccountId || !myPrivateKey) {
    throw new Error(
        "Environment variables MY_ACCOUNT_ID and MY_PRIVATE_KEY must be present"
    );
}

//Create your Hedera Testnet client
const client = Client.forTestnet();

//Set your account as the client's operator
client.setOperator(myAccountId, myPrivateKey);

//Set the default maximum transaction fee (in Hbar)
client.setDefaultMaxTransactionFee(new Hbar(100));

//Set the maximum payment for queries (in Hbar)
// client.setMaxQueryPayment(new Hbar(50));

// Helper function to convert geographic coordinates to a scaled integer representation
function convertGeoCoordToInt(coord) {
    // Scale factor, e.g., 10^6 for 6 decimal places
    const scaleFactor = 1000000;
    return Math.round(coord * scaleFactor).toString();
}
// Assume all necessary Hedera SDK imports and client initialization are done below
async function setLocation(gas, newContractId, deviceId, lat, lng) {
    const contractExecTx = await new ContractExecuteTransaction()
        .setContractId(newContractId)
        .setGas(gas)
        // how to add deviceid if its a bunch of bytes
        .setFunction("updateLocationsBatch", new ContractFunctionParameters().addBytes32Array([deviceId]).addInt256Array([lat]).addInt256Array([lng]));

    const submitExecTx = await contractExecTx.execute(client);
    const receipt = await submitExecTx.getReceipt(client);

    // Return a value, for example, the transaction status
    return receipt.status.toString();
}

// Call the setLocation function
// setLocation(10000, '0.0.3643101', "device_1", "0.1", "0.2").catch(console.error);
