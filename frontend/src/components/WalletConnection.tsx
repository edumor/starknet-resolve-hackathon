import React, { useEffect, useState } from 'react';
import { Container, Typography, Card, CardContent, Button, Box, Alert, Divider } from '@mui/material';
import { useAccount, useConnect, useDisconnect } from '@starknet-react/core';

const WalletConnection: React.FC = () => {
  const { address, isConnected, status } = useAccount();
  const { connect, connectors, error, isPending } = useConnect();
  const { disconnect } = useDisconnect();
  
  const [walletDetected, setWalletDetected] = useState(false);
  
  useEffect(() => {
    // Check for injected wallets
    const checkWallets = () => {
      const hasArgentX = typeof window !== 'undefined' && (window as any).starknet_argentX;
      const hasBraavos = typeof window !== 'undefined' && (window as any).starknet_braavos;
      const hasStarknet = typeof window !== 'undefined' && (window as any).starknet;
      setWalletDetected(hasArgentX || hasBraavos || hasStarknet);
    };
    
    checkWallets();
    // Recheck after a delay to allow extensions to load
    setTimeout(checkWallets, 2000);
  }, []);

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h3" gutterBottom align="center">
        🔗 Conexión de Wallet
      </Typography>
      
      <Card sx={{ mb: 3 }}>
        <CardContent>
          <>
            <Typography variant="h5" gutterBottom>
              Estado de Conexión
            </Typography>
            
            {/* Debug Information */}
            <Box sx={{ mb: 2, p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
              <Typography variant="body2" gutterBottom>
                <strong>🔍 Debug Info:</strong>
              </Typography>
              <Typography variant="body2">Status: {status}</Typography>
              <Typography variant="body2">Conectores encontrados: {connectors.length}</Typography>
              <Typography variant="body2">Wallet detectada: {walletDetected ? 'Sí' : 'No'}</Typography>
              <Typography variant="body2">Conectando: {isPending ? 'Sí' : 'No'}</Typography>
            </Box>

            {error && (
              <Alert severity="error" sx={{ mb: 2 }}>
                ❌ Error de conexión: {error instanceof Error ? error.message : 'Error desconocido'}
              </Alert>
            )}
          </>

          {isConnected ? (
            <Box>
              <Typography variant="body1" gutterBottom color="success.main">
                ✅ Wallet Conectado Exitosamente
              </Typography>
              <Typography variant="body2" sx={{ fontFamily: 'monospace', wordBreak: 'break-all', mb: 2, p: 2, bgcolor: 'grey.100', borderRadius: 1 }}>
                {address}
              </Typography>
              <Button variant="outlined" onClick={() => disconnect()}>
                Desconectar Wallet
              </Button>
            </Box>
          ) : (
            <Box>
              <Typography variant="body1" gutterBottom color="warning.main">
                ⚠️ Wallet No Conectado
              </Typography>
              
              {!walletDetected && (
                <Alert severity="warning" sx={{ mb: 2 }}>
                  🚨 No se detectó ninguna wallet de Starknet instalada. Instala Argent X o Braavos primero.
                </Alert>
              )}
              
              <Typography variant="body2" color="text.secondary" paragraph>
                Conecta tu wallet de Starknet para acceder a todas las funcionalidades del hackathon
              </Typography>
              
              {connectors.length > 0 ? (
                <Box>
                  <Typography variant="body2" gutterBottom>
                    📱 Conectores disponibles:
                  </Typography>
                  {connectors.map((connector, index) => (
                    <Button
                      key={connector.id}
                      variant="contained"
                      size="large"
                      onClick={() => connect({ connector })}
                      disabled={isPending}
                      sx={{ mr: 1, mb: 1 }}
                    >
                      {isPending ? '⏳ Conectando...' : `🔗 ${connector.name || `Conector ${index + 1}`}`}
                    </Button>
                  ))}
                </Box>
              ) : (
                <Alert severity="error" sx={{ mb: 2 }}>
                  ❌ No se encontraron wallets compatibles instaladas
                </Alert>
              )}
            </Box>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardContent>
          <Typography variant="h5" gutterBottom>
            🛠️ Guía de Solución de Problemas
          </Typography>
          
          <Alert severity="info" sx={{ mb: 3 }}>
            <Typography variant="body2">
              <strong>Si no puedes conectar tu wallet, sigue estos pasos:</strong>
            </Typography>
          </Alert>
          
          <Box sx={{ mb: 3 }}>
            <Typography variant="h6" gutterBottom color="primary.main">
              1. 📦 Verificar Instalación
            </Typography>
            <Typography variant="body2" paragraph>
              • Instala <strong>Argent X</strong> desde Chrome Web Store
            </Typography>
            <Typography variant="body2" paragraph>
              • O instala <strong>Braavos</strong> como alternativa
            </Typography>
            <Typography variant="body2" paragraph>
              • Reinicia el navegador después de instalar
            </Typography>
          </Box>

          <Divider sx={{ my: 2 }} />

          <Box sx={{ mb: 3 }}>
            <Typography variant="h6" gutterBottom color="primary.main">
              2. ⚙️ Configurar Red
            </Typography>
            <Typography variant="body2" paragraph>
              • Abre tu wallet → Settings/Configuración
            </Typography>
            <Typography variant="body2" paragraph>
              • Selecciona <strong>"Starknet Sepolia Testnet"</strong>
            </Typography>
            <Typography variant="body2" paragraph>
              • ⚠️ NO uses Mainnet para desarrollo
            </Typography>
          </Box>

          <Divider sx={{ my: 2 }} />

          <Box sx={{ mb: 3 }}>
            <Typography variant="h6" gutterBottom color="primary.main">
              3. 🔓 Desbloquear y Conectar
            </Typography>
            <Typography variant="body2" paragraph>
              • Introduce tu contraseña en la wallet
            </Typography>
            <Typography variant="body2" paragraph>
              • Recarga esta página (F5)
            </Typography>
            <Typography variant="body2" paragraph>
              • Haz clic en "Conectar Wallet"
            </Typography>
            <Typography variant="body2" paragraph>
              • Acepta la conexión en el popup
            </Typography>
          </Box>

          <Alert severity="warning" sx={{ mb: 2 }}>
            <Typography variant="body2">
              � <strong>Problemas comunes:</strong><br/>
              • Si tienes MetaMask u otras wallets, deshabilítalas temporalmente<br/>
              • Asegúrate de estar en Sepolia testnet, no Mainnet<br/>
              • Prueba en modo incógnito si sigues teniendo problemas
            </Typography>
          </Alert>

          <Box sx={{ p: 2, bgcolor: 'success.light', borderRadius: 1 }}>
            <Typography variant="body2" color="success.contrastText">
              💰 <strong>¡Recuerda!</strong> Una vez conectado podrás competir por $43,500+ en premios del hackathon
            </Typography>
          </Box>
        </CardContent>
      </Card>
    </Container>
  );
};

export default WalletConnection;