import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { Link, useLocation } from 'react-router-dom';
import { useAccount, useConnect, useDisconnect } from '@starknet-react/core';

const Navigation: React.FC = () => {
  const { address, isConnected } = useAccount();
  const { connect, connectors } = useConnect();
  const { disconnect } = useDisconnect();
  const location = useLocation();

  const navItems = [
    { label: 'Home', path: '/' },
    { label: 'Wallet', path: '/wallet' },
    { label: 'Payments', path: '/payments' },
    { label: 'Gaming', path: '/gaming' },
    { label: 'Privacy', path: '/privacy' },
    { label: 'Bitcoin', path: '/bitcoin' },
    { label: 'Mobile', path: '/mobile' },
  ];

  return (
    <AppBar position="fixed" sx={{ background: 'rgba(13, 17, 23, 0.95)', backdropFilter: 'blur(10px)' }}>
      <Toolbar>
        <Typography variant="h6" sx={{ flexGrow: 1, fontWeight: 'bold' }}>
          🚀 Starknet Re{'{'}Solve{'}'}
        </Typography>
        
        <Box sx={{ display: 'flex', gap: 2, mr: 3 }}>
          {navItems.map((item) => (
            <Button
              key={item.path}
              component={Link}
              to={item.path}
              color={location.pathname === item.path ? 'primary' : 'inherit'}
              sx={{ 
                minWidth: 'auto',
                textTransform: 'none',
                fontWeight: location.pathname === item.path ? 'bold' : 'normal'
              }}
            >
              {item.label}
            </Button>
          ))}
        </Box>

        {isConnected ? (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Typography variant="body2" sx={{ fontSize: '0.8rem' }}>
              {`${address?.slice(0, 6)}...${address?.slice(-4)}`}
            </Typography>
            <Button variant="outlined" size="small" onClick={() => disconnect()}>
              Disconnect
            </Button>
          </Box>
        ) : (
          <Button 
            variant="contained" 
            onClick={() => connectors.length > 0 && connect({ connector: connectors[0] })}
          >
            Connect Wallet
          </Button>
        )}
      </Toolbar>
    </AppBar>
  );
};

export default Navigation;