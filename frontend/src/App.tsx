import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { StarknetConfig, publicProvider, useInjectedConnectors } from '@starknet-react/core';
import { sepolia, mainnet } from '@starknet-react/chains';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';

// Components
import Navigation from './components/Navigation';
import WalletConnection from './components/WalletConnection';
import HomePage from './pages/HomePage';
import PaymentsPage from './pages/PaymentsPage';
import GamingPage from './pages/GamingPage';
import PrivacyPage from './pages/PrivacyPage';
import BitcoinPage from './pages/BitcoinPage';
import MobilePage from './pages/MobilePage';

// Theme configuration
const theme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#FF6B35', // Starknet orange
    },
    secondary: {
      main: '#4A90E2',
    },
    background: {
      default: '#0D1117',
      paper: '#161B22',
    },
  },
  typography: {
    fontFamily: 'Inter, sans-serif',
  },
});

// Starknet configuration
const chains = [sepolia, mainnet];
const provider = publicProvider();

function App() {
  const { connectors } = useInjectedConnectors({
    // All injected wallets
    recommended: [],
    includeRecommended: "onlyIfNoConnectors",
    order: "random",
  });

  return (
    <StarknetConfig
      chains={chains}
      provider={provider}
      connectors={connectors}
      autoConnect
    >
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Router>
          <div className="App">
            <Navigation />
            <main style={{ paddingTop: '80px', minHeight: '100vh' }}>
              <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/wallet" element={<WalletConnection />} />
                <Route path="/payments" element={<PaymentsPage />} />
                <Route path="/gaming" element={<GamingPage />} />
                <Route path="/privacy" element={<PrivacyPage />} />
                <Route path="/bitcoin" element={<BitcoinPage />} />
                <Route path="/mobile" element={<MobilePage />} />
              </Routes>
            </main>
          </div>
        </Router>
      </ThemeProvider>
    </StarknetConfig>
  );
}

export default App;