import React from 'react';
import { SignInButton } from '@clerk/clerk-react';
import { Button, Container, Typography, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';
export default function Landing() {
  const navigate = useNavigate();

  return (
    <Container maxWidth="md" sx={{ textAlign: 'center', mt: 10 }}>
      <Typography variant="h3" fontWeight={700} gutterBottom>
        Welcome to Service Management
      </Typography>

      <Typography variant="h6" color="text.secondary" gutterBottom>
        A platform to manage services across your organization and teams with ease.
        Track updates, handle incidents, and stay informed in real-time.
      </Typography>

      <Typography variant="body1" color="text.secondary" sx={{ mt: 2 }}>
        Empower your teams with streamlined service visibility and seamless collaboration.
        Get clear insights into system health and service subscriptions within your organization.
      </Typography>

      <Box sx={{ mt: 4, display: 'flex', justifyContent: 'center', gap: 2 }}>
        <Button
          variant="contained"
          color="primary"
          onClick={() => {
            navigate('/status');
          }}
        >
          Check Service Status
        </Button>
        <SignInButton mode="modal">
          <Button variant="outlined" color="primary">
            Sign In
          </Button>
        </SignInButton>
      </Box>
    </Container>
  );
}
