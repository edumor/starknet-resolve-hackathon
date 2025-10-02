function GamingTrack() {
  return (
    <div className="space-y-6">
      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h2 className="text-3xl font-bold mb-4 text-purple-400">🎮 Gaming Track</h2>
        <p className="text-gray-300 text-lg mb-6">
          Fully on-chain strategy game powered by Dojo engine with NFT characters and provably fair gameplay.
        </p>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">⚔️ Game Features</h3>
            <ul className="space-y-2 text-gray-300">
              <li>• 100% on-chain game logic</li>
              <li>• NFT characters (Warrior, Mage, Archer)</li>
              <li>• PvP battle system</li>
              <li>• Character progression & leveling</li>
              <li>• Tradeable items and equipment</li>
              <li>• Leaderboards and tournaments</li>
              <li>• Provably fair outcomes</li>
            </ul>
          </div>

          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">🏗️ Dojo Architecture</h3>
            <div className="bg-black/50 p-4 rounded text-sm font-mono text-green-400">
              <p>Engine: Dojo ECS</p>
              <p>Language: Cairo 2.0</p>
              <p>Location: dojo/src/</p>
              <p className="mt-2 text-gray-400">Components:</p>
              <p>• Player Model</p>
              <p>• Character Model</p>
              <p>• Battle System</p>
              <p>• Item System</p>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gradient-to-r from-purple-900/30 to-pink-900/30 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">🎯 Character Classes</h3>
          <div className="grid md:grid-cols-3 gap-4">
            <div className="bg-black/50 p-6 rounded-lg text-center">
              <div className="text-5xl mb-3">⚔️</div>
              <h4 className="text-xl font-bold text-white mb-2">Warrior</h4>
              <div className="space-y-1 text-sm text-gray-300">
                <p>Attack: 120</p>
                <p>Defense: 80</p>
                <p>Health: 1000</p>
              </div>
              <button className="mt-4 w-full bg-red-600 hover:bg-red-700 text-white font-bold py-2 rounded transition">
                Create Warrior
              </button>
            </div>
            <div className="bg-black/50 p-6 rounded-lg text-center">
              <div className="text-5xl mb-3">🧙</div>
              <h4 className="text-xl font-bold text-white mb-2">Mage</h4>
              <div className="space-y-1 text-sm text-gray-300">
                <p>Attack: 150</p>
                <p>Defense: 50</p>
                <p>Health: 800</p>
              </div>
              <button className="mt-4 w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 rounded transition">
                Create Mage
              </button>
            </div>
            <div className="bg-black/50 p-6 rounded-lg text-center">
              <div className="text-5xl mb-3">🏹</div>
              <h4 className="text-xl font-bold text-white mb-2">Archer</h4>
              <div className="space-y-1 text-sm text-gray-300">
                <p>Attack: 100</p>
                <p>Defense: 70</p>
                <p>Health: 900</p>
              </div>
              <button className="mt-4 w-full bg-green-600 hover:bg-green-700 text-white font-bold py-2 rounded transition">
                Create Archer
              </button>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gray-900/50 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">🏆 Game Stats</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center">
              <p className="text-3xl font-bold text-purple-400">2,547</p>
              <p className="text-gray-400 text-sm">Active Players</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-purple-400">8,921</p>
              <p className="text-gray-400 text-sm">Characters Created</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-purple-400">15,432</p>
              <p className="text-gray-400 text-sm">Battles Fought</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-purple-400">3,876</p>
              <p className="text-gray-400 text-sm">Items Traded</p>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h3 className="text-2xl font-bold mb-4 text-purple-400">🎮 Why On-Chain Gaming?</h3>
        <div className="grid md:grid-cols-2 gap-4">
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">🔒 True Ownership</h4>
            <p className="text-gray-400 text-sm">
              All characters and items are NFTs that you truly own and can trade freely.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">✓ Provably Fair</h4>
            <p className="text-gray-400 text-sm">
              All game logic runs on-chain, ensuring transparent and verifiable outcomes.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">🌐 Composability</h4>
            <p className="text-gray-400 text-sm">
              Game assets can be used across multiple games and platforms.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">💰 Player Economy</h4>
            <p className="text-gray-400 text-sm">
              Players earn real value through gameplay and can trade assets on open markets.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default GamingTrack
