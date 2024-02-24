// app/javascript/packs/index.js
// To rebuild the bundle: `npx webpack --config webpack.config.js`
import { HashConnect, HashConnectConnectionState } from 'hashconnect';
import { LedgerId } from "@hashgraph/sdk"
window.HashConnect = HashConnect;
window.HashConnectConnectionState = HashConnectConnectionState;
window.LedgerId = LedgerId;

// Add any additional setup you need here
console.log("HashConnect is loaded", HashConnect);
console.log("HashConnectConnectionState is loaded", HashConnectConnectionState);
console.log("LedgerId is loaded", LedgerId);