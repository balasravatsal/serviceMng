import { SignedIn, SignedOut, SignInButton, UserButton, useUser } from '@clerk/clerk-react';
import { BrowserRouter as Router, Routes, Route, Navigate, Link } from 'react-router-dom';
import Landing from './pages/Landing';
import Home from './pages/Home';
import Incidents from './pages/Incidents';
import Notifications from './pages/Notifications';
import PublicStatusPage from './pages/PublicStatus';
import { ThemeProvider, createTheme, CssBaseline } from '@mui/material';

const theme = createTheme({
  palette: {
    primary: { main: '#030027' },
    secondary: { main: '#0a81d1' },
    background: { default: '#f5f6fa', paper: '#fff' },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 5,
        },
        contained: {
          backgroundColor: '#0a81d1',
          color: '#fff',
          '&:hover': {
            backgroundColor: '#0866a0',
          },
        },
      },
    },
    MuiChip: { styleOverrides: { root: { borderRadius: 5 } } },
  },
});

export default function App() {
  const { user } = useUser();
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <SignedOut>
          <Routes>
            <Route path="/status" element={<PublicStatusPage />} />
            <Route path="*" element={<Landing />} />
          </Routes>
        </SignedOut>
        <SignedIn>
          <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: theme.palette.primary.main, color: '#fff', padding: 16 }}>
            <h2 style={{ margin: 0 }}>Service Management</h2>
            <nav>
              <Link to="/" style={{ marginRight: 16, color: '#fff', textDecoration: 'none', fontWeight: 500 }}>Home</Link>
              <Link to="/incidents" style={{ marginRight: 16, color: '#fff', textDecoration: 'none', fontWeight: 500 }}>Incidents</Link>
              <Link to="/notifications" style={{ marginRight: 16, color: '#fff', textDecoration: 'none', fontWeight: 500 }}>Notifications</Link>
              <Link to="/status" style={{ marginRight: 16, color: '#fff', textDecoration: 'none', fontWeight: 500 }}>Status</Link>
            </nav>
            <UserButton />
          </header>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/incidents" element={<Incidents user={user} />} />
            <Route path="/notifications" element={<Notifications user={user} />} />
            <Route path="/status" element={<PublicStatusPage />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </SignedIn>
      </Router>
    </ThemeProvider>
  );
}