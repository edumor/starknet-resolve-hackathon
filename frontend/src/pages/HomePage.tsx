import React from 'react';
import { Container, Grid, Card, CardContent, Typography, Box, Chip } from '@mui/material';

const HomePage: React.FC = () => {
  const tracks = [
    {
      title: 'Next-Gen Payments',
      description: 'Ultra-low fees payment solutions on Starknet',
      prize: '$4,000',
      features: ['Sub-cent fees', 'Instant settlements', 'Global reach'],
      color: '#FF6B35',
    },
    {
      title: 'Mobile-First dApps',
      description: 'Mobile applications built for Starknet',
      prize: '$3,000',
      features: ['React Native', 'Mobile wallets', 'Offline support'],
      color: '#4A90E2',
    },
    {
      title: 'On-Chain Gaming',
      description: 'Gaming using Dojo framework',
      prize: '$5,000',
      features: ['Dojo framework', 'Real-time multiplayer', 'NFT integration'],
      color: '#50E3C2',
    },
    {
      title: 'Privacy & Identity',
      description: 'Privacy-focused applications with ZK proofs',
      prize: '$6,000+',
      features: ['Zero-knowledge', 'Anonymous credentials', 'Identity verification'],
      color: '#BD10E0',
    },
    {
      title: 'Bitcoin Unleashed',
      description: 'Bitcoin integration with Starknet',
      prize: '$19,500+',
      features: ['Cross-chain', 'Lightning Network', 'DeFi integration'],
      color: '#F5A623',
    },
    {
      title: 'Open Innovation',
      description: 'Creative and experimental projects',
      prize: '$7,000',
      features: ['Experimental', 'Creative solutions', 'New frontiers'],
      color: '#7ED321',
    },
  ];

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Box textAlign="center" mb={6}>
        <Typography variant="h2" component="h1" gutterBottom sx={{ fontWeight: 'bold', mb: 2 }}>
          Starknet Re{'{'}Solve{'}'} Hackathon
        </Typography>
        <Typography variant="h5" color="text.secondary" gutterBottom>
          Unlock tomorrow's apps: Ultra-low fees, Ethereum security, Bitcoin power
        </Typography>
        <Box sx={{ mt: 3 }}>
          <Chip label="$43,500+ in prizes" color="primary" size="medium" sx={{ mr: 2, fontSize: '1.1rem', padding: '8px 16px' }} />
          <Chip label="Multi-track project" color="secondary" size="medium" sx={{ fontSize: '1.1rem', padding: '8px 16px' }} />
        </Box>
      </Box>

      <Grid container spacing={4}>
        {tracks.map((track, index) => (
          <Grid item xs={12} md={6} lg={4} key={index}>
            <Card 
              sx={{ 
                height: '100%',
                background: `linear-gradient(135deg, ${track.color}15, ${track.color}05)`,
                border: `2px solid ${track.color}30`,
                transition: 'transform 0.2s, box-shadow 0.2s',
                '&:hover': {
                  transform: 'translateY(-4px)',
                  boxShadow: `0 8px 25px ${track.color}40`,
                }
              }}
            >
              <CardContent sx={{ p: 3 }}>
                <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
                  <Typography variant="h5" component="h2" sx={{ fontWeight: 'bold', color: track.color }}>
                    {track.title}
                  </Typography>
                  <Chip 
                    label={track.prize}
                    sx={{ 
                      backgroundColor: `${track.color}20`,
                      color: track.color,
                      fontWeight: 'bold'
                    }}
                  />
                </Box>
                
                <Typography variant="body1" color="text.secondary" paragraph>
                  {track.description}
                </Typography>

                <Box>
                  <Typography variant="subtitle2" sx={{ mb: 1, color: track.color }}>
                    Key Features:
                  </Typography>
                  {track.features.map((feature, idx) => (
                    <Chip
                      key={idx}
                      label={feature}
                      size="small"
                      variant="outlined"
                      sx={{ 
                        mr: 1, 
                        mb: 1,
                        borderColor: `${track.color}50`,
                        color: track.color
                      }}
                    />
                  ))}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      <Box textAlign="center" mt={6} p={4} sx={{ background: 'rgba(255, 107, 53, 0.1)', borderRadius: 2 }}>
        <Typography variant="h4" gutterBottom>
          🏗️ Multi-Track Implementation
        </Typography>
        <Typography variant="body1" color="text.secondary">
          This project implements features for ALL hackathon tracks in a single comprehensive solution.
          Each track has dedicated smart contracts, frontend components, and integration examples.
        </Typography>
      </Box>
    </Container>
  );
};

export default HomePage;