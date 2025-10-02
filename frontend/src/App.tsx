import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { StarknetConfig } from '@starknet-react/core';
import HomePage from './pages/HomePage';
import PaymentsPage from './pages/PaymentsPage';
import GamingPage from './pages/GamingPage';
import PrivacyPage from './pages/PrivacyPage';
import BitcoinPage from './pages/BitcoinPage';
import InnovationPage from './pages/InnovationPage';

function App() {
  return (
    <StarknetConfig autoConnect>
      <Router>
        <div className="min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900">
          <nav className="bg-black bg-opacity-50 backdrop-blur-lg border-b border-white border-opacity-20">
            <div className="container mx-auto px-4 py-4">
              <div className="flex items-center justify-between">
                <Link to="/" className="text-2xl font-bold text-white">
                  Starknet Re{'{Solve}'}
                </Link>
                <div className="flex space-x-6">
                  <Link to="/payments" className="text-white hover:text-blue-400 transition">
                    💰 Payments
                  </Link>
                  <Link to="/gaming" className="text-white hover:text-blue-400 transition">
                    🎮 Gaming
                  </Link>
                  <Link to="/privacy" className="text-white hover:text-blue-400 transition">
                    🔒 Privacy
                  </Link>
                  <Link to="/bitcoin" className="text-white hover:text-blue-400 transition">
                    ₿ Bitcoin
                  </Link>
                  <Link to="/innovation" className="text-white hover:text-blue-400 transition">
                    💡 Innovation
                  </Link>
                </div>
              </div>
            </div>
          </nav>

          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/payments" element={<PaymentsPage />} />
            <Route path="/gaming" element={<GamingPage />} />
            <Route path="/privacy" element={<PrivacyPage />} />
            <Route path="/bitcoin" element={<BitcoinPage />} />
            <Route path="/innovation" element={<InnovationPage />} />
          </Routes>
        </div>
      </Router>
    </StarknetConfig>
  );
}

export default App;
