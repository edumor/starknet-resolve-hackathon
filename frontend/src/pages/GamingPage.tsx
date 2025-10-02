function GamingPage() {
  return (
    <div className="container mx-auto px-4 py-12">
      <h1 className="text-5xl font-bold text-white mb-8">🎮 Gaming Track</h1>
      
      <div className="card mb-8">
        <h2 className="text-3xl font-bold text-white mb-4">Starknet Battles</h2>
        <p className="text-xl text-blue-100 mb-6">
          Fully on-chain strategy game built with Dojo ECS framework
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">NFT Characters</h3>
          <p className="text-blue-100 mb-4">
            Mint unique characters with upgradeable attributes
          </p>
          <ul className="space-y-2 text-blue-200">
            <li>• Health: 100 base</li>
            <li>• Attack: 10 base</li>
            <li>• Defense: 10 base</li>
            <li>• Speed: 10 base</li>
            <li>• Level up system</li>
            <li>• Experience points</li>
          </ul>
        </div>

        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Battle System</h3>
          <p className="text-blue-100 mb-4">
            Turn-based combat with provably fair mechanics
          </p>
          <ul className="space-y-2 text-blue-200">
            <li>• Create battles</li>
            <li>• Join battles</li>
            <li>• Execute combat</li>
            <li>• Win rewards</li>
            <li>• Leaderboards</li>
            <li>• Tournaments</li>
          </ul>
        </div>

        <div className="card">
          <h3 className="text-2xl font-bold text-white mb-4">Dojo Integration</h3>
          <p className="text-blue-100 mb-4">
            Entity Component System architecture
          </p>
          <ul className="space-y-2 text-blue-200">
            <li>• On-chain state</li>
            <li>• Optimistic updates</li>
            <li>• Torii indexer</li>
            <li>• Katana node</li>
            <li>• Fast gameplay</li>
            <li>• Verifiable logic</li>
          </ul>
        </div>
      </div>

      <div className="card">
        <h2 className="text-3xl font-bold text-white mb-6">Game Features</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-white bg-opacity-5 p-6 rounded-lg">
            <h4 className="text-xl font-bold text-white mb-3">Player vs Player</h4>
            <p className="text-blue-100">
              Challenge other players in real-time battles with skill-based matchmaking
            </p>
          </div>
          <div className="bg-white bg-opacity-5 p-6 rounded-lg">
            <h4 className="text-xl font-bold text-white mb-3">Character Progression</h4>
            <p className="text-blue-100">
              Earn experience through battles and level up your characters
            </p>
          </div>
          <div className="bg-white bg-opacity-5 p-6 rounded-lg">
            <h4 className="text-xl font-bold text-white mb-3">Tournament System</h4>
            <p className="text-blue-100">
              Participate in tournaments with prize pools and earn rewards
            </p>
          </div>
          <div className="bg-white bg-opacity-5 p-6 rounded-lg">
            <h4 className="text-xl font-bold text-white mb-3">NFT Marketplace</h4>
            <p className="text-blue-100">
              Trade characters and items with other players
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default GamingPage;
