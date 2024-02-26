import { Controller } from "@hotwired/stimulus"
// import { HashConnect, HashConnectConnectionState } from "hashconnect"
// import { LedgerId } from "@hashgraph/sdk"

export default class extends Controller {
    static values = {
        appName: String,
        appDescription: String,
        appIcon: String,
        appUrl: String,
        projectId: String
    }

    async initHashConnect() {
        const HashConnect = window.HashConnect; // Access from global scope
        const HashConnectConnectionState = window.HashConnectConnectionState; // Assume this is globally available, adjust accordingly
        const LedgerId = window.LedgerId; // Assume this is also globally available, adjust accordingly

        const appMetadata = {
            name: this.appNameValue,
            description: this.appDescriptionValue,
            icons: [this.appIconValue],
            url: this.appUrlValue
        }

        this.hashconnect = new HashConnect(LedgerId.TESTNET, this.projectIdValue, appMetadata, true)
        this.state = HashConnectConnectionState.Disconnected;
        this.pairingData = null;

        this.setUpHashConnectEvents()

        // Initialize HashConnect with your LedgerId and app metadata
        await this.hashconnect.init();

        this.hashconnect.openPairingModal();
    }

    setUpHashConnectEvents() {
        this.hashconnect.pairingEvent.on((newPairing) => {
            this.pairingData = newPairing;
            console.log("Pairing complete", pairingData);

        })

        this.hashconnect.disconnectionEvent.on((data) => {
            this.pairingData = null;
            console.log("Disconnected");
        });

        this.hashconnect.connectionStatusChangeEvent.on((connectionStatus) => {
            this.state = connectionStatus;
            console.log("Connection status changed", this.state);
        })
    }

    // Example function to send a transaction
    async sendTransaction(accountId, transaction) {
        try {
            const response = await this.hashconnect.sendTransaction(accountId, transaction);
            console.log("Transaction success", response);
        } catch (err) {
            console.error("Transaction error", err);
            // in order to use this application, the user must be connected
        }
    }
}
// Register events and initialize as in the provided example
// setUpHashConnectEvents()
// await hashconnect.init()
// hashconnect.openPairingModal()
