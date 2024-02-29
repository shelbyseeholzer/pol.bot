//1.creates a client that talks to server
//2. 
const {
    Client,
    PrivateKey,
    AccountCreateTransaction,
    AccountBalanceQuery,
    Hbar,
    TransferTransaction,
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

// Assume all necessary Hedera SDK imports and client initialization are done below
async function setLocation(gas, newContractId, deviceId, lat, long) {
    const contractExecTx = await new ContractExecuteTransaction()
        .setContractId(newContractId)
        .setGas(gas)
        .setFunction("updateLocationsBatch", new ContractFunctionParameters().addStringArray([deviceId]).addUint256Array([lat]).addUint256Array([long]));

    const submitExecTx = await contractExecTx.execute(client);
    const receipt = await submitExecTx.getReceipt(client);

    // Return a value, for example, the transaction status
    return receipt.status.toString();
} 