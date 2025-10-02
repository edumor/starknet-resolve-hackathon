# Mobile Track Documentation

## Overview

The Mobile track features a cross-platform mobile wallet application built with React Native and Expo, providing users with a seamless way to interact with Starknet on their smartphones.

## Features

### 1. Account Abstraction

Simplify user experience with smart contract wallets:

- **Social Recovery**: Recover wallet via friends/family
- **Session Keys**: Pre-approve transactions for games/apps
- **Gas Abstraction**: Pay gas fees in any token
- **Multi-Call**: Batch multiple transactions
- **Upgradeable**: Update wallet logic without changing address

### 2. Biometric Authentication

Secure access with device biometrics:

```typescript
import * as LocalAuthentication from 'expo-local-authentication';

async function authenticateUser() {
  const result = await LocalAuthentication.authenticateAsync({
    promptMessage: 'Unlock Starknet Wallet',
    fallbackLabel: 'Use Passcode',
  });
  
  if (result.success) {
    // Load wallet
    return await loadWallet();
  }
}
```

Supports:
- Face ID (iOS)
- Touch ID (iOS)
- Fingerprint (Android)
- Iris scanner (Android)

### 3. QR Code Scanner

Scan QR codes for easy payments:

```typescript
import { BarCodeScanner } from 'expo-barcode-scanner';

function QRScanner() {
  const handleBarCodeScanned = ({ type, data }) => {
    // Parse payment request
    const payment = parsePaymentQR(data);
    // Show confirmation
    showPaymentConfirmation(payment);
  };
  
  return (
    <BarCodeScanner
      onBarCodeScanned={handleBarCodeScanned}
      style={StyleSheet.absoluteFillObject}
    />
  );
}
```

QR Code Format:
```
starknet:0x1234...5678?amount=1.5&token=ETH&memo=Payment
```

### 4. Push Notifications

Stay informed with real-time alerts:

```typescript
import * as Notifications from 'expo-notifications';

// Setup notifications
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: false,
  }),
});

// Send notification
await Notifications.scheduleNotificationAsync({
  content: {
    title: 'Transaction Confirmed',
    body: 'Received 1.5 ETH',
    data: { tx_hash: '0x...' },
  },
  trigger: null,
});
```

Notification Types:
- Transaction confirmations
- Incoming payments
- Price alerts
- Security warnings
- App updates

### 5. Multi-Account Management

Manage multiple wallets:

```typescript
interface Wallet {
  address: string;
  name: string;
  type: 'standard' | 'multisig' | 'social';
  balance: TokenBalance[];
  lastSynced: number;
}

function AccountSwitcher() {
  const [wallets, setWallets] = useState<Wallet[]>([]);
  const [activeWallet, setActiveWallet] = useState<string>();
  
  return (
    <View>
      {wallets.map(wallet => (
        <TouchableOpacity
          key={wallet.address}
          onPress={() => setActiveWallet(wallet.address)}
        >
          <WalletCard wallet={wallet} />
        </TouchableOpacity>
      ))}
    </View>
  );
}
```

### 6. WalletConnect Integration

Connect to dApps:

```typescript
import WalletConnect from '@walletconnect/client';

const connector = new WalletConnect({
  bridge: 'https://bridge.walletconnect.org',
});

// Subscribe to connection requests
connector.on('session_request', (error, payload) => {
  if (error) throw error;
  
  // Display approval request
  showApprovalModal(payload.params[0]);
});

// Approve session
connector.approveSession({
  accounts: [address],
  chainId: STARKNET_CHAIN_ID,
});
```

### 7. In-App DApp Browser

Browse Starknet dApps:

```typescript
import { WebView } from 'react-native-webview';

function DAppBrowser({ url }) {
  const handleMessage = (event) => {
    const message = JSON.parse(event.nativeEvent.data);
    
    if (message.type === 'transaction') {
      // Show transaction confirmation
      confirmTransaction(message.payload);
    }
  };
  
  return (
    <WebView
      source={{ uri: url }}
      onMessage={handleMessage}
      injectedJavaScript={STARKNET_PROVIDER_SCRIPT}
    />
  );
}
```

## Architecture

### App Structure

```
mobile/
├── src/
│   ├── screens/
│   │   ├── HomeScreen.tsx
│   │   ├── SendScreen.tsx
│   │   ├── ReceiveScreen.tsx
│   │   ├── SettingsScreen.tsx
│   │   └── DAppBrowserScreen.tsx
│   ├── components/
│   │   ├── WalletCard.tsx
│   │   ├── TransactionList.tsx
│   │   ├── TokenBalance.tsx
│   │   └── QRScanner.tsx
│   ├── services/
│   │   ├── starknet.ts
│   │   ├── storage.ts
│   │   ├── biometrics.ts
│   │   └── notifications.ts
│   ├── hooks/
│   │   ├── useWallet.ts
│   │   ├── useBalance.ts
│   │   └── useTransactions.ts
│   └── utils/
│       ├── crypto.ts
│       └── formatting.ts
└── assets/
```

### Data Flow

```
User Action → Screen → Hook → Service → Starknet RPC
                ↓
             Update UI
```

## Security

### Secure Key Storage

```typescript
import * as SecureStore from 'expo-secure-store';

// Store private key
await SecureStore.setItemAsync('private_key', encryptedKey, {
  keychainAccessible: SecureStore.WHEN_UNLOCKED,
});

// Retrieve private key
const encryptedKey = await SecureStore.getItemAsync('private_key');
const privateKey = decrypt(encryptedKey, biometricToken);
```

Security Layers:
1. **Device Encryption**: OS-level encryption
2. **Biometric Lock**: Face/Touch ID required
3. **App Pin**: Backup authentication
4. **Transaction Signing**: Confirm each tx
5. **Session Timeout**: Auto-lock after inactivity

### Hardware Wallet Support

Integrate with Ledger:

```typescript
import TransportBLE from '@ledgerhq/react-native-hw-transport-ble';
import Starknet from '@ledgerhq/hw-app-starknet';

async function signWithLedger(transaction) {
  const transport = await TransportBLE.create();
  const starknet = new Starknet(transport);
  
  const signature = await starknet.signTransaction(
    "m/44'/9004'/0'/0/0",
    transaction
  );
  
  return signature;
}
```

## Screens

### Home Screen

- Portfolio overview
- Token balances
- Recent transactions
- Quick actions (Send, Receive, Swap)

### Send Screen

```typescript
function SendScreen() {
  const [recipient, setRecipient] = useState('');
  const [amount, setAmount] = useState('');
  const [token, setToken] = useState('ETH');
  
  const handleSend = async () => {
    // Validate inputs
    if (!isValidAddress(recipient)) {
      showError('Invalid address');
      return;
    }
    
    // Show confirmation
    const confirmed = await showConfirmation({
      recipient,
      amount,
      token,
      fee: estimatedFee,
    });
    
    if (confirmed) {
      // Execute transaction
      const tx = await sendTransaction({
        to: recipient,
        amount: parseUnits(amount),
        token,
      });
      
      // Show success
      showSuccess(`Sent ${amount} ${token}`);
      
      // Navigate home
      navigation.navigate('Home');
    }
  };
  
  return (
    <View>
      <TextInput
        placeholder="Recipient Address"
        value={recipient}
        onChangeText={setRecipient}
      />
      <TextInput
        placeholder="Amount"
        value={amount}
        onChangeText={setAmount}
        keyboardType="decimal-pad"
      />
      <Button title="Send" onPress={handleSend} />
    </View>
  );
}
```

### Receive Screen

```typescript
function ReceiveScreen() {
  const { address } = useWallet();
  
  return (
    <View>
      <QRCode value={address} size={250} />
      <Text>{formatAddress(address)}</Text>
      <Button
        title="Copy Address"
        onPress={() => {
          Clipboard.setString(address);
          showToast('Address copied');
        }}
      />
      <Button
        title="Share"
        onPress={() => {
          Share.share({ message: address });
        }}
      />
    </View>
  );
}
```

## State Management

Using React Context + Hooks:

```typescript
interface WalletState {
  address: string | null;
  balance: TokenBalance[];
  transactions: Transaction[];
  loading: boolean;
}

const WalletContext = createContext<WalletState | null>(null);

export function WalletProvider({ children }) {
  const [state, setState] = useState<WalletState>({
    address: null,
    balance: [],
    transactions: [],
    loading: true,
  });
  
  useEffect(() => {
    loadWallet();
  }, []);
  
  return (
    <WalletContext.Provider value={state}>
      {children}
    </WalletContext.Provider>
  );
}

export function useWallet() {
  const context = useContext(WalletContext);
  if (!context) throw new Error('useWallet must be used within WalletProvider');
  return context;
}
```

## Performance Optimization

### Lazy Loading

```typescript
const DAppBrowser = lazy(() => import('./screens/DAppBrowserScreen'));

function App() {
  return (
    <Suspense fallback={<LoadingScreen />}>
      <DAppBrowser />
    </Suspense>
  );
}
```

### Caching

```typescript
import AsyncStorage from '@react-native-async-storage/async-storage';

// Cache balance
await AsyncStorage.setItem(
  `balance_${address}`,
  JSON.stringify(balance)
);

// Retrieve cached balance
const cached = await AsyncStorage.getItem(`balance_${address}`);
if (cached && !isStale(cached)) {
  return JSON.parse(cached);
}
```

### Image Optimization

```typescript
import FastImage from 'react-native-fast-image';

<FastImage
  source={{ uri: tokenIcon }}
  style={{ width: 40, height: 40 }}
  resizeMode={FastImage.resizeMode.contain}
/>
```

## Testing

### Unit Tests

```typescript
import { render, fireEvent } from '@testing-library/react-native';

test('Send button is disabled with invalid input', () => {
  const { getByText, getByPlaceholderText } = render(<SendScreen />);
  
  const sendButton = getByText('Send');
  expect(sendButton).toBeDisabled();
  
  const amountInput = getByPlaceholderText('Amount');
  fireEvent.changeText(amountInput, '10');
  
  expect(sendButton).toBeEnabled();
});
```

### E2E Tests

```typescript
import { by, device, element, expect } from 'detox';

describe('Wallet Flow', () => {
  it('should create new wallet', async () => {
    await element(by.id('create-wallet-button')).tap();
    await element(by.id('seed-phrase')).swipe('down');
    await element(by.id('confirm-button')).tap();
    await expect(element(by.id('home-screen'))).toBeVisible();
  });
  
  it('should send transaction', async () => {
    await element(by.id('send-button')).tap();
    await element(by.id('recipient-input')).typeText('0x123...');
    await element(by.id('amount-input')).typeText('1.5');
    await element(by.id('confirm-button')).tap();
    await expect(element(by.text('Transaction sent'))).toBeVisible();
  });
});
```

## Deployment

### iOS

```bash
cd mobile
eas build --platform ios
eas submit --platform ios
```

### Android

```bash
cd mobile
eas build --platform android
eas submit --platform android
```

## Future Enhancements

- [ ] Multi-signature wallet support
- [ ] NFT gallery and management
- [ ] DeFi integration (swap, lend, farm)
- [ ] Social features (contacts, chat)
- [ ] Portfolio analytics
- [ ] Price charts
- [ ] News feed
- [ ] Advanced security (2FA, whitelist)
- [ ] Fiat on/off ramp
- [ ] Cross-chain bridge UI

## Resources

- [React Native Docs](https://reactnative.dev/)
- [Expo Documentation](https://docs.expo.dev/)
- [Starknet.js](https://www.starknetjs.com/)
- [WalletConnect](https://walletconnect.com/)
