function PrivacyPage() {
  return (
    <div className="container mx-auto px-4 py-12">
      <h1 className="text-5xl font-bold text-white mb-8">🔒 Privacy Track</h1>
      
      <div className="card mb-8">
        <h2 className="text-3xl font-bold text-white mb-4">Privacy-Preserving Protocol</h2>
        <p className="text-xl text-blue-100">
          Advanced cryptographic features for anonymous transactions and voting
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Private Pool</h3>
          <p className="text-blue-100 mb-6">
            Anonymous liquidity pools with zero-knowledge proofs
          </p>
          <div className="space-y-4">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Commitment Scheme</div>
              <p className="text-blue-200 text-sm">
                Deposit with cryptographic commitments to hide transaction details
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Nullifier Verification</div>
              <p className="text-blue-200 text-sm">
                Prevent double-spending while maintaining anonymity
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">ZK Proofs</div>
              <p className="text-blue-200 text-sm">
                Withdraw funds to any address without revealing the depositor
              </p>
            </div>
          </div>
        </div>

        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Privacy Features</h3>
          <p className="text-blue-100 mb-6">
            Comprehensive privacy tools for various use cases
          </p>
          <div className="space-y-4">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Private Transfers</div>
              <p className="text-blue-200 text-sm">
                Send tokens without revealing sender or recipient identity
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Anonymous Voting</div>
              <p className="text-blue-200 text-sm">
                Participate in governance without exposing voting choices
              </p>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold mb-2">Encrypted Messaging</div>
              <p className="text-blue-200 text-sm">
                Secure communication between wallet addresses
              </p>
            </div>
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="text-3xl font-bold text-white mb-6">Cryptographic Primitives</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="text-center">
            <div className="text-5xl mb-3">🔐</div>
            <h4 className="text-xl font-bold text-white mb-2">STARK Proofs</h4>
            <p className="text-blue-100">
              Native Starknet proofs for efficient verification
            </p>
          </div>
          <div className="text-center">
            <div className="text-5xl mb-3">🎲</div>
            <h4 className="text-xl font-bold text-white mb-2">Pedersen Hash</h4>
            <p className="text-blue-100">
              Collision-resistant cryptographic commitments
            </p>
          </div>
          <div className="text-center">
            <div className="text-5xl mb-3">💫</div>
            <h4 className="text-xl font-bold text-white mb-2">Ring Signatures</h4>
            <p className="text-blue-100">
              Group signatures for anonymity sets
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default PrivacyPage;
