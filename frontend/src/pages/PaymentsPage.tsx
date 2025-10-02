import React, { useState } from 'react';
import { Container, Typography, Card, CardContent, TextField, Button, Box, Grid, Alert } from '@mui/material';

const PaymentsPage: React.FC = () => {
  const [amount, setAmount] = useState('');
  const [recipient, setRecipient] = useState('');
  const [loading, setLoading] = useState(false);

  const handlePayment = async () => {
    setLoading(true);
    // Simulate payment processing
    setTimeout(() => {
      setLoading(false);
      alert('Payment processed with ultra-low fees!');
    }, 2000);
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h3" gutterBottom align="center">
        💳 Next-Gen Payments
      </Typography>
      <Typography variant="body1" color="text.secondary" align="center" paragraph>
        Ultra-low fee payment system on Starknet
      </Typography>

      <Grid container spacing={4}>
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h5" gutterBottom>
                Send Payment
              </Typography>
              
              <TextField
                fullWidth
                label="Recipient Address"
                value={recipient}
                onChange={(e) => setRecipient(e.target.value)}
                margin="normal"
                placeholder="0x..."
              />
              
              <TextField
                fullWidth
                label="Amount (STRK)"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                margin="normal"
                type="number"
              />
              
              <Button
                fullWidth
                variant="contained"
                onClick={handlePayment}
                disabled={loading || !amount || !recipient}
                sx={{ mt: 2 }}
              >
                {loading ? 'Processing...' : 'Send Payment'}
              </Button>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Payment Features
              </Typography>
              
              <Alert severity="success" sx={{ mb: 2 }}>
                <strong>Fee: 0.1%</strong><br />
                Ultra-low transaction costs
              </Alert>
              
              <Box sx={{ mb: 2 }}>
                <Typography variant="body2" color="text.secondary">
                  • Instant settlements
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  • Global accessibility
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  • Ethereum security
                </Typography>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default PaymentsPage;