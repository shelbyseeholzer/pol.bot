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

// If we weren't able to grab it, we should throw a new error
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
client.setMaxQueryPayment(new Hbar(50));

//Import the compiled contract from the HederaSmartContract.json file
let hederaSmartContract = require("./smart_contracts/HederaSmartContract.json");
const bytecode = hederaSmartContract.data.bytecode.object;

//Create the transaction
const contractCreate = new ContractCreateFlow()
    .setGas(100000)
    .setBytecode(bytecode);

//Sign the transaction with the client operator key and submit to a Hedera network
const txResponse = contractCreate.execute(client);

//Get the receipt of the transaction
const receipt = (await txResponse).getReceipt(client);

//Get the new contract ID
const newContractId = (await receipt).contractId;

console.log("The new contract ID is " + newContractId);
//SDK Version: v2.11.0-beta.1

