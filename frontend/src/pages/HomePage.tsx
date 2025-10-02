function HomePage() {
  return (
    <div className="container mx-auto px-4 py-12">
      <div className="text-center mb-16">
        <h1 className="text-6xl font-bold text-white mb-6">
          Starknet Re{'{Solve}'} Hackathon
        </h1>
        <p className="text-2xl text-blue-200 mb-8">
          Complete Solution Covering All 6 Tracks
        </p>
        <div className="inline-block bg-gradient-to-r from-yellow-400 to-orange-500 text-black px-8 py-3 rounded-full font-bold text-xl">
          Prize Pool: $43,500+
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
        <div className="card">
          <div className="text-5xl mb-4">💰</div>
          <h3 className="text-2xl font-bold text-white mb-3">Payments</h3>
          <p className="text-blue-100">
            Decentralized payment gateway with multi-currency support, escrow, and merchant tools.
          </p>
        </div>

        <div className="card">
          <div className="text-5xl mb-4">📱</div>
          <h3 className="text-2xl font-bold text-white mb-3">Mobile</h3>
          <p className="text-blue-100">
            Cross-platform mobile wallet with account abstraction and biometric security.
          </p>
        </div>

        <div className="card">
          <div className="text-5xl mb-4">🎮</div>
          <h3 className="text-2xl font-bold text-white mb-3">Gaming</h3>
          <p className="text-blue-100">
            On-chain gaming with Dojo framework, NFT characters, and PvP battles.
          </p>
        </div>

        <div className="card">
          <div className="text-5xl mb-4">🔒</div>
          <h3 className="text-2xl font-bold text-white mb-3">Privacy</h3>
          <p className="text-blue-100">
            Zero-knowledge proofs for private transactions and anonymous voting.
          </p>
        </div>

        <div className="card">
          <div className="text-5xl mb-4">₿</div>
          <h3 className="text-2xl font-bold text-white mb-3">Bitcoin</h3>
          <p className="text-blue-100">
            Trustless Bitcoin-Starknet bridge with SPV proofs and wrapped BTC.
          </p>
        </div>

        <div className="card">
          <div className="text-5xl mb-4">💡</div>
          <h3 className="text-2xl font-bold text-white mb-3">Innovation</h3>
          <p className="text-blue-100">
            Dynamic AMM, prediction markets, yield aggregation, and DAO governance.
          </p>
        </div>
      </div>

      <div className="card max-w-4xl mx-auto">
        <h2 className="text-3xl font-bold text-white mb-6 text-center">
          Tech Stack
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
          <div>
            <div className="text-4xl mb-2">⚡</div>
            <div className="text-white font-semibold">Cairo 2.0</div>
          </div>
          <div>
            <div className="text-4xl mb-2">⚛️</div>
            <div className="text-white font-semibold">React 18</div>
          </div>
          <div>
            <div className="text-4xl mb-2">🎲</div>
            <div className="text-white font-semibold">Dojo</div>
          </div>
          <div>
            <div className="text-4xl mb-2">🔗</div>
            <div className="text-white font-semibold">Starknet</div>
          </div>
        </div>
      </div>

      <div className="text-center mt-16">
        <a
          href="https://github.com/edumor/starknet-resolve-hackathon"
          target="_blank"
          rel="noopener noreferrer"
          className="btn-primary inline-block"
        >
          View on GitHub
        </a>
      </div>
    </div>
  );
}

export default HomePage;
