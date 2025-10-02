function BitcoinPage() {
  return (
    <div className="container mx-auto px-4 py-12">
      <h1 className="text-5xl font-bold text-white mb-8">₿ Bitcoin Track</h1>
      
      <div className="card mb-8">
        <h2 className="text-3xl font-bold text-white mb-4">Bitcoin-Starknet Bridge</h2>
        <p className="text-xl text-blue-100">
          Trustless bidirectional bridge connecting Bitcoin and Starknet ecosystems
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Bridge Mechanism</h3>
          <p className="text-blue-100 mb-6">
            Secure Bitcoin deposits and withdrawals with cryptographic proofs
          </p>
          <div className="space-y-4">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">1. Deposit BTC</div>
              <p className="text-blue-200 text-sm">
                Lock Bitcoin on the Bitcoin network with SPV proofs
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">2. Verify Proof</div>
              <p className="text-blue-200 text-sm">
                Submit Merkle proofs to Starknet for verification
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">3. Mint wBTC</div>
              <p className="text-blue-200 text-sm">
                Receive wrapped BTC tokens on Starknet (1:1 ratio)
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">4. Withdraw</div>
              <p className="text-blue-200 text-sm">
                Burn wBTC to unlock and withdraw original Bitcoin
              </p>
            </div>
          </div>
        </div>

        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Security Features</h3>
          <p className="text-blue-100 mb-6">
            Multi-layered security for safe cross-chain operations
          </p>
          <div className="space-y-4">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">SPV Verification</div>
              <p className="text-blue-200 text-sm">
                Simplified Payment Verification for Bitcoin transactions
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Multi-Sig Security</div>
              <p className="text-blue-200 text-sm">
                Multiple validators for transaction approval
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Time Locks</div>
              <p className="text-blue-200 text-sm">
                Delayed withdrawals for fraud prevention
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Emergency Pause</div>
              <p className="text-blue-200 text-sm">
                Circuit breaker for security incidents
              </p>
            </div>
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="text-3xl font-bold text-white mb-6">Bridge Benefits</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="text-center">
            <div className="text-5xl mb-3">💰</div>
            <h4 className="text-xl font-bold text-white mb-2">DeFi Access</h4>
            <p className="text-blue-100">
              Use Bitcoin in Starknet DeFi protocols
            </p>
          </div>
          <div className="text-center">
            <div className="text-5xl mb-3">⚡</div>
            <h4 className="text-xl font-bold text-white mb-2">Fast Settlement</h4>
            <p className="text-blue-100">
              L2 speed for Bitcoin transactions
            </p>
          </div>
          <div className="text-center">
            <div className="text-5xl mb-3">💸</div>
            <h4 className="text-xl font-bold text-white mb-2">Low Fees</h4>
            <p className="text-blue-100">
              Reduced transaction costs on L2
            </p>
          </div>
          <div className="text-center">
            <div className="text-5xl mb-3">🔒</div>
            <h4 className="text-xl font-bold text-white mb-2">Trustless</h4>
            <p className="text-blue-100">
              No centralized custody required
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default BitcoinPage;
