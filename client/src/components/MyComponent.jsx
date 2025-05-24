import { useUser } from '@clerk/clerk-react';
import { Paper, Typography } from '@mui/material';

export function MyComponent() {
  const { isLoaded, isSignedIn, user } = useUser();

  if (!isLoaded) {
    return <div>Loading...</div>;
  }

  if (!isSignedIn) {
    return <div>User is not signed in</div>;
  }

  return (
    <Paper elevation={3} sx={{ p: 3, mb: 2, bgcolor: '#bcedf6', borderRadius: 0, textAlign: 'center', maxWidth: 400, mx: 'auto', mt: 2 }}>
      <Typography variant="h5" color="primary" sx={{ fontWeight: 600 }}>Welcome, {user.firstName}!</Typography>
      <Typography variant="body1" sx={{ color: 'text.secondary', mt: 1 }}>Email: {user.emailAddresses[0].emailAddress}</Typography>
      {/* You can access more user properties here */}
    </Paper>
  );
}