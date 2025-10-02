function MobileTrack() {
  return (
    <div className="space-y-6">
      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h2 className="text-3xl font-bold mb-4 text-purple-400">📱 Mobile Track</h2>
        <p className="text-gray-300 text-lg mb-6">
          Mobile-first Progressive Web App with seamless wallet integration and offline support.
        </p>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">✨ Mobile Features</h3>
            <ul className="space-y-2 text-gray-300">
              <li>• Progressive Web App (PWA)</li>
              <li>• Touch-optimized interface</li>
              <li>• Argent X & Braavos mobile wallet support</li>
              <li>• Offline transaction queuing</li>
              <li>• Biometric authentication</li>
              <li>• QR code scanning for payments</li>
              <li>• Push notifications</li>
            </ul>
          </div>

          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">📱 Mobile Optimizations</h3>
            <div className="space-y-3 text-gray-300">
              <div className="flex items-center justify-between bg-black/50 p-3 rounded">
                <span>Load Time</span>
                <span className="text-green-400 font-bold">&lt; 2s</span>
              </div>
              <div className="flex items-center justify-between bg-black/50 p-3 rounded">
                <span>Bundle Size</span>
                <span className="text-green-400 font-bold">&lt; 100KB</span>
              </div>
              <div className="flex items-center justify-between bg-black/50 p-3 rounded">
                <span>Lighthouse Score</span>
                <span className="text-green-400 font-bold">95+</span>
              </div>
              <div className="flex items-center justify-between bg-black/50 p-3 rounded">
                <span>Offline Support</span>
                <span className="text-green-400 font-bold">✓ Yes</span>
              </div>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gradient-to-r from-blue-900/30 to-purple-900/30 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">📲 Install as App</h3>
          <p className="text-gray-300 mb-4">
            Add to your home screen for a native app experience with offline support and push notifications.
          </p>
          <div className="grid md:grid-cols-2 gap-4">
            <button className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition">
              📱 iOS Install Guide
            </button>
            <button className="bg-green-600 hover:bg-green-700 text-white font-bold py-3 rounded-lg transition">
              🤖 Android Install Guide
            </button>
          </div>
        </div>
      </div>

      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h3 className="text-2xl font-bold mb-4 text-purple-400">🎯 Mobile-First Design</h3>
        <div className="grid md:grid-cols-3 gap-4">
          <div className="bg-gray-900/50 rounded-lg p-4 text-center">
            <div className="text-4xl mb-2">👆</div>
            <h4 className="font-bold text-white mb-2">Touch Gestures</h4>
            <p className="text-gray-400 text-sm">
              Swipe, tap, and pinch interactions for intuitive navigation
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4 text-center">
            <div className="text-4xl mb-2">🔔</div>
            <h4 className="font-bold text-white mb-2">Notifications</h4>
            <p className="text-gray-400 text-sm">
              Real-time push notifications for transactions and updates
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4 text-center">
            <div className="text-4xl mb-2">📶</div>
            <h4 className="font-bold text-white mb-2">Offline Mode</h4>
            <p className="text-gray-400 text-sm">
              Queue transactions offline and sync when connected
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default MobileTrack
