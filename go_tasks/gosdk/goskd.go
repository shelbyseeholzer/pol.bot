package main

import (
    "C"
    "github.com/hashgraph/hedera-sdk-go/v2"
    "encoding/hex"
)

// Helper function to convert string to bytes32 for Hedera SDK
func stringToBytes32(str string) ([]byte, error) {
    // Assuming str is already a hex representation of the hash
    return hex.DecodeString(str)
}

//export setLocation
func setLocation(gas C.long, newContractId *C.char, deviceHash *C.char, lat C.long, lng C.long, accountId *C.char, privateKeyC *C.char) *C.char {
    // Convert C strings to Go strings
    accountIdStr := C.GoString(accountId)
    privateKeyStr := C.GoString(privateKeyC)

    // Convert accountIdStr to hedera.AccountID
    accountID, err := hedera.AccountIDFromString(accountIdStr)
    if err != nil {
        return C.CString("Invalid account ID format: " + err.Error() + " GOT=[" + accountIdStr + "]")
    }

    // Convert privateKeyStr to hedera.PrivateKey
    privateKey, err := hedera.PrivateKeyFromString(privateKeyStr)
    if err != nil {
        return C.CString("Invalid private key format: " + err.Error() + " GOT=[" + privateKeyStr + "]")
    }

    client := hedera.ClientForTestnet()
    client.SetOperator(accountID, privateKey)

    contractID, err := hedera.ContractIDFromString(C.GoString(newContractId))
    if err != nil {
        return C.CString("Error parsing ContractID: " + err.Error())
    }

    // Convert the deviceHash from hex string to bytes
    deviceBytes, err := stringToBytes32(C.GoString(deviceHash))
    if err != nil {
        return C.CString("Error converting deviceHash to bytes: " + err.Error())
    }

    deviceArr := [][]byte{deviceBytes}
    latArr := []int64{int64(lat)}
    lngArr := []int64{int64(lng)}
    if len(deviceArr) != len(latArr) {
        return C.CString("Array lengths do not match: len(deviceArr) != len(latArr)")
    }
    if len(deviceArr) != len(lngArr) {
        return C.CString("Array lengths do not match: len(deviceArr) != len(lngArr)")
    }

    // Prepare the parameters for the smart contract function
    params := hedera.NewContractFunctionParameters().
        AddBytes32Array(deviceArr).
        AddInt64Array(latArr).
        AddInt64Array(lngArr)

    // Execute the contract function
    tx, err := hedera.NewContractExecuteTransaction().
        SetContractID(contractID).
        SetGas(uint64(gas)).
        SetFunction("updateLocationsBatch", params).
        Execute(client)
    if err != nil {
        return C.CString("Execution error: " + err.Error())
    }

    receipt, err := tx.GetReceipt(client)
    if err != nil {
        return C.CString("Receipt fetch error: " + err.Error())
    }

    return C.CString(receipt.Status.String())
}

func main() {}
