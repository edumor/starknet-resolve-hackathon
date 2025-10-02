function PaymentsTrack() {
  return (
    <div className="space-y-6">
      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h2 className="text-3xl font-bold mb-4 text-purple-400">💰 Payments Track</h2>
        <p className="text-gray-300 text-lg mb-6">
          Decentralized payment gateway with multi-token support, instant settlements, and merchant tools.
        </p>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">✨ Key Features</h3>
            <ul className="space-y-2 text-gray-300">
              <li>• Multi-token support (ETH, STRK, USDC, USDT)</li>
              <li>• Invoice generation and management</li>
              <li>• Automatic payment splitting</li>
              <li>• Escrow service with dispute resolution</li>
              <li>• Real-time payment tracking</li>
              <li>• Low-fee L2 transactions</li>
            </ul>
          </div>

          <div className="bg-gray-900/50 rounded-lg p-6">
            <h3 className="text-xl font-bold mb-3 text-white">🔧 Smart Contract</h3>
            <div className="bg-black/50 p-4 rounded text-sm font-mono text-green-400">
              <p>Contract: PaymentGateway</p>
              <p>Language: Cairo 2.0</p>
              <p>Location: contracts/payments/</p>
              <p className="mt-2 text-gray-400">Functions:</p>
              <p>• create_invoice()</p>
              <p>• pay_invoice()</p>
              <p>• withdraw()</p>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-gradient-to-r from-green-900/30 to-blue-900/30 rounded-lg p-6">
          <h3 className="text-xl font-bold mb-3 text-white">📊 Demo Interface</h3>
          <div className="grid md:grid-cols-3 gap-4 mb-4">
            <div className="bg-black/50 p-4 rounded">
              <p className="text-gray-400 text-sm">Total Invoices</p>
              <p className="text-2xl font-bold text-white">1,234</p>
            </div>
            <div className="bg-black/50 p-4 rounded">
              <p className="text-gray-400 text-sm">Volume Processed</p>
              <p className="text-2xl font-bold text-white">$2.5M</p>
            </div>
            <div className="bg-black/50 p-4 rounded">
              <p className="text-gray-400 text-sm">Active Merchants</p>
              <p className="text-2xl font-bold text-white">567</p>
            </div>
          </div>
          <button className="w-full bg-purple-600 hover:bg-purple-700 text-white font-bold py-3 rounded-lg transition">
            Create Invoice
          </button>
        </div>
      </div>

      <div className="bg-gray-800/50 backdrop-blur rounded-xl p-8 border border-purple-500/20">
        <h3 className="text-2xl font-bold mb-4 text-purple-400">💡 Use Cases</h3>
        <div className="grid md:grid-cols-2 gap-4">
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">E-commerce Integration</h4>
            <p className="text-gray-400 text-sm">
              Accept crypto payments on your online store with automatic token conversion and settlement.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">Freelance Payments</h4>
            <p className="text-gray-400 text-sm">
              Invoice clients and receive payments with built-in escrow for milestone-based projects.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">Subscription Services</h4>
            <p className="text-gray-400 text-sm">
              Set up recurring payments for SaaS platforms with automated billing cycles.
            </p>
          </div>
          <div className="bg-gray-900/50 rounded-lg p-4">
            <h4 className="font-bold text-white mb-2">Team Payroll</h4>
            <p className="text-gray-400 text-sm">
              Distribute payments to multiple recipients with automatic splitting and conversion.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default PaymentsTrack
