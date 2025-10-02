import { useState } from 'react'
import PaymentsTrack from './components/PaymentsTrack'
import MobileTrack from './mobile/MobileTrack'
import GamingTrack from './gaming/GamingTrack'
import PrivacyTrack from './components/PrivacyTrack'
import BitcoinTrack from './components/BitcoinTrack'
import InnovationTrack from './components/InnovationTrack'

function App() {
  const [activeTrack, setActiveTrack] = useState('overview')

  const tracks = [
    { id: 'payments', name: '💰 Payments', component: PaymentsTrack },
    { id: 'mobile', name: '📱 Mobile', component: MobileTrack },
    { id: 'gaming', name: '🎮 Gaming', component: GamingTrack },
    { id: 'privacy', name: '🔒 Privacy', component: PrivacyTrack },
    { id: 'bitcoin', name: '₿ Bitcoin', component: BitcoinTrack },
    { id: 'innovation', name: '💡 Innovation', component: InnovationTrack },
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-purple-900 to-gray-900">
      <header className="bg-black/30 backdrop-blur-md border-b border-purple-500/20">
        <div className="container mx-auto px-4 py-6">
          <h1 className="text-4xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-600">
            🚀 Starknet Re{'{Solve}'} Hackathon
          </h1>
          <p className="text-gray-400 mt-2">Complete Multi-Track Implementation | Prize Pool: $43,500+</p>
        </div>
      </header>

      <nav className="sticky top-0 z-50 bg-black/50 backdrop-blur-md border-b border-purple-500/20">
        <div className="container mx-auto px-4">
          <div className="flex overflow-x-auto py-4 space-x-4">
            <button
              onClick={() => setActiveTrack('overview')}
              className={`px-6 py-2 rounded-lg font-semibold transition whitespace-nowrap ${
                activeTrack === 'overview'
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
              }`}
            >
              📋 Overview
            </button>
            {tracks.map((track) => (
              <button
                key={track.id}
                onClick={() => setActiveTrack(track.id)}
                className={`px-6 py-2 rounded-lg font-semibold transition whitespace-nowrap ${
                  activeTrack === track.id
                    ? 'bg-purple-600 text-white'
                    : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
                }`}
              >
                {track.name}
              </button>
            ))}
          </div>
        </div>
      </nav>

      <main className="container mx-auto px-4 py-8">
        {activeTrack === 'overview' && (
          <div className="space-y-6">
            <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
              <h2 className="text-3xl font-bold mb-4 text-purple-400">Project Overview</h2>
              <p className="text-gray-300 text-lg leading-relaxed">
                This comprehensive project demonstrates mastery across all 6 Starknet Re{'{Solve}'} Hackathon tracks.
                Each track features production-ready implementations using Cairo 2.0, React, and Dojo.
              </p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {tracks.map((track) => (
                <div
                  key={track.id}
                  onClick={() => setActiveTrack(track.id)}
                  className="bg-gray-800/50 backdrop-blur rounded-xl p-6 border border-purple-500/20 cursor-pointer hover:border-purple-500/50 transition"
                >
                  <h3 className="text-2xl font-bold mb-3 text-white">{track.name}</h3>
                  <p className="text-gray-400 text-sm">
                    Click to explore the {track.id} track implementation
                  </p>
                </div>
              ))}
            </div>

            <div className="bg-gradient-to-r from-purple-900/50 to-pink-900/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
              <h2 className="text-2xl font-bold mb-4 text-purple-300">🏆 Technical Achievements</h2>
              <ul className="space-y-3 text-gray-300">
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>Complete Cairo 2.0 smart contracts for all tracks</span>
                </li>
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>Mobile-first responsive design with PWA support</span>
                </li>
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>On-chain gaming with Dojo engine integration</span>
                </li>
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>Zero-knowledge privacy implementations</span>
                </li>
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>Bitcoin-Starknet bridge with guardian security</span>
                </li>
                <li className="flex items-start">
                  <span className="text-purple-400 mr-2">✓</span>
                  <span>Innovative DeFi primitives with flash loans</span>
                </li>
              </ul>
            </div>
          </div>
        )}

        {tracks.map((track) => {
          const TrackComponent = track.component
          return activeTrack === track.id ? <TrackComponent key={track.id} /> : null
        })}
      </main>

      <footer className="bg-black/30 backdrop-blur-md border-t border-purple-500/20 mt-12">
        <div className="container mx-auto px-4 py-6 text-center text-gray-400">
          <p>Built with ❤️ for the Starknet Re{'{Solve}'} Hackathon</p>
          <p className="mt-2">Prize Pool: $43,500+ | All 6 Tracks Completed</p>
        </div>
      </footer>
    </div>
  )
}

export default App
