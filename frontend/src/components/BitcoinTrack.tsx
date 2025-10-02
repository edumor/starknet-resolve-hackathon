function BitcoinTrack() {
  return (
    <div className="space-y-6">
      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h2 className="text-3xl font-bold mb-4 text-purple-400">₿ Bitcoin Track</h2>
        <p className="text-gray-300 text-lg mb-6">
          Trustless Bitcoin-Starknet bridge with multi-sig security and Lightning Network integration.
        </p>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">⚡ Bridge Features</h3>
            <ul className="space-y-2 text-gray-300">
              <li>• Trustless BTC deposits & withdrawals</li>
              <li>• Wrapped BTC on Starknet</li>
              <li>• Multi-sig guardian security</li>
              <li>• Lightning Network integration</li>
              <li>• Bitcoin price oracle</li>
              <li>• Cross-chain atomic swaps</li>
              <li>• Bitcoin script verification</li>
            </ul>
          </div>

          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">🔧 Smart Contract</h3>
            <div className="bg-black/50 p-4 rounded text-sm font-mono text-green-400">
              <p>Contract: BTCBridge</p>
              <p>Language: Cairo 2.0</p>
              <p>Location: contracts/bitcoin/</p>
              <p className="mt-2 text-gray-400">Functions:</p>
              <p>• report_deposit()</p>
              <p>• request_withdrawal()</p>
              <p>• approve_withdrawal()</p>
              <p>• add_guardian()</p>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gradient-to-r from-orange-900/30 to-yellow-900/30 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">🌉 Bridge Process</h3>
          <div className="grid md:grid-cols-2 gap-6">
            <div className="space-y-4">
              <h4 className="font-bold text-white">📥 Deposit BTC</h4>
              <div className="flex items-start">
                <div className="bg-orange-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  1
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Send BTC to multi-sig bridge address
                  </p>
                </div>
              </div>
              <div className="flex items-start">
                <div className="bg-orange-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  2
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Guardians verify and report deposit
                  </p>
                </div>
              </div>
              <div className="flex items-start">
                <div className="bg-orange-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  3
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Receive wrapped BTC on Starknet
                  </p>
                </div>
              </div>
            </div>
            <div className="space-y-4">
              <h4 className="font-bold text-white">📤 Withdraw BTC</h4>
              <div className="flex items-start">
                <div className="bg-yellow-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  1
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Request withdrawal with BTC address
                  </p>
                </div>
              </div>
              <div className="flex items-start">
                <div className="bg-yellow-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  2
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Guardians approve withdrawal request
                  </p>
                </div>
              </div>
              <div className="flex items-start">
                <div className="bg-yellow-600 rounded-full w-8 h-8 flex items-center justify-center font-bold mr-3 flex-shrink-0 text-sm">
                  3
                </div>
                <div>
                  <p className="text-gray-300 text-sm">
                    Receive BTC to your Bitcoin wallet
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gray-900/50 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">📊 Bridge Stats</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <p className="text-3xl font-bold text-orange-400">254</p>
              <p className="text-gray-400 text-sm">BTC Locked</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-orange-400">1,234</p>
              <p className="text-gray-400 text-sm">Total Deposits</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-orange-400">987</p>
              <p className="text-gray-400 text-sm">Withdrawals</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-orange-400">7</p>
              <p className="text-gray-400 text-sm">Active Guardians</p>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h3 className="text-2xl font-bold mb-4 text-purple-400">⚡ Security Features</h3>
        <div className="grid md:grid-cols-2 gap-4">
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">🔐 Multi-Sig Security</h4>
            <p className="text-gray-400 text-sm">
              Multiple guardians must approve all bridge operations, preventing single point of failure.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">✓ Bitcoin Verification</h4>
            <p className="text-gray-400 text-sm">
              On-chain verification of Bitcoin transactions and script execution.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">⏱️ Time Locks</h4>
            <p className="text-gray-400 text-sm">
              Time-locked withdrawals provide security against unauthorized access.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">📊 Transparent Reserves</h4>
            <p className="text-gray-400 text-sm">
              All BTC reserves are publicly verifiable on both Bitcoin and Starknet.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default BitcoinTrack
