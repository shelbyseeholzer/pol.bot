package main

import (
    "C"
    "github.com/hashgraph/hedera-sdk-go/v2"
    "encoding/hex"
    "math/big"
)

// Helper function to convert string to bytes32 for Hedera SDK
func stringToBytes32(str string) ([]byte, error) {
    // Assuming str is already a hex representation of the hash
    return hex.DecodeString(str)
}

// Helper function to convert an int64 to a [32]byte array for int256 compatibility
func int64ToInt256Bytes(value int64) [32]byte {
    var b [32]byte
    bi := big.NewInt(value)
    // Fill the bytes slice from the big.Int representation
    absBytes := bi.Bytes()
    copy(b[32-len(absBytes):], absBytes)
    return b
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

    // Convert lat and lng from int64 to [32]byte
    latBytes := int64ToInt256Bytes(int64(lat))
    lngBytes := int64ToInt256Bytes(int64(lng))

    // Create slices of [32]byte arrays for latitudes and longitudes
    latArr := [][32]byte{latBytes}
    lngArr := [][32]byte{lngBytes}

    deviceArr := [][]byte{deviceBytes}

    if len(deviceArr) != len(latArr) {
        return C.CString("Array lengths do not match: len(deviceArr) != len(latArr)")
    }
    if len(deviceArr) != len(lngArr) {
        return C.CString("Array lengths do not match: len(deviceArr) != len(lngArr)")
    }

    // Prepare the parameters for the smart contract function
    params := hedera.NewContractFunctionParameters().
        AddBytes32Array(deviceArr).
        AddInt256Array(latArr).
        AddInt256Array(lngArr)

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
