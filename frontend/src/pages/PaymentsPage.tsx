function PaymentsPage() {
  return (
    <div className="container mx-auto px-4 py-12">
      <h1 className="text-5xl font-bold text-white mb-8">💰 Payments Track</h1>
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div className="card">
          <h2 className="text-2xl font-bold text-white mb-4">Payment Gateway</h2>
          <p className="text-blue-100 mb-6">
            Process payments with multiple tokens, create invoices, and manage merchant accounts.
          </p>
          <div className="space-y-3">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Multi-Token Support</div>
              <div className="text-blue-200 text-sm">ETH, STRK, USDC, USDT</div>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Instant Settlement</div>
              <div className="text-blue-200 text-sm">Fast L2 confirmations</div>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Low Fees</div>
              <div className="text-blue-200 text-sm">Gas-optimized transactions</div>
            </div>
          </div>
        </div>

        <div className="card">
          <h2 className="text-2xl font-bold text-white mb-4">Escrow Service</h2>
          <p className="text-blue-100 mb-6">
            Secure transactions with arbiter-based dispute resolution.
          </p>
          <div className="space-y-3">
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Secure Holding</div>
              <div className="text-blue-200 text-sm">Funds locked until conditions met</div>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Dispute Resolution</div>
              <div className="text-blue-200 text-sm">Third-party arbiter support</div>
            </div>
            <div className="bg-white bg-opacity-5 p-4 rounded">
              <div className="text-white font-semibold">Time Locks</div>
              <div className="text-blue-200 text-sm">Automatic refunds on expiry</div>
            </div>
          </div>
        </div>
      </div>

      <div className="card mt-8">
        <h2 className="text-3xl font-bold text-white mb-6">Contract Features</h2>
        <ul className="grid grid-cols-1 md:grid-cols-2 gap-4 text-blue-100">
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Merchant registration and verification
          </li>
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Payment creation and tracking
          </li>
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Refund and dispute mechanisms
          </li>
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Balance management per token
          </li>
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Event-driven architecture
          </li>
          <li className="flex items-start">
            <span className="text-green-400 mr-2">✓</span>
            Gas-optimized operations
          </li>
        </ul>
      </div>
    </div>
  );
}

export default PaymentsPage;
