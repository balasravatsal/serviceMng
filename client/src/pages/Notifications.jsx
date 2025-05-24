import { useEffect, useState } from 'react';
import { getPendingRequestsForAdmin, approveRequest, rejectRequest } from '../api/teamMembershipApi.js';
import { Paper, Typography, Button, Box, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, List, ListItem, ListItemText } from '@mui/material';
import axios from 'axios';
import { useUser } from '@clerk/clerk-react';

export default function NotificationsPage() {
    const [notifications, setNotifications] = useState([]);
    const { user } = useUser();
    const [pending, setPending] = useState([]);
    const isAdmin = user?.unsafeMetadata?.role === 'admin';

    useEffect(() => {
        const fetchNotifications = async () => {
            try {
                const res = await axios.get(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/notifications/${user.id}`);
                const sortedNotifications = res.data.notifications.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
                setNotifications(sortedNotifications);
            } catch (error) {
                console.error('Error fetching notifications:', error);
            }
        };

        if (user) {
            fetchNotifications();
        }
    }, [user]);

    useEffect(() => {
        if (user?.id && isAdmin) {
            getPendingRequestsForAdmin(user.id).then(setPending);
        }
    }, [user, isAdmin]);

    const handleApprove = async (id) => {
        await approveRequest(id);
        setPending(pending.filter(req => req.id !== id));
    };

    const handleReject = async (id) => {
        await rejectRequest(id);
        setPending(pending.filter(req => req.id !== id));
    };

    return (
        <Box sx={{ p: { xs: 1, md: 3 }, maxWidth: 900, mx: 'auto' }}>
            <Typography variant="h3" color="primary" sx={{ fontWeight: 700, mb: 3, textAlign: 'center' }}>Notifications</Typography>
            {isAdmin &&
                <Paper elevation={3} sx={{ mt: 4, p: 3, borderRadius: 2 }}>
                    <Typography variant="h6" color="secondary" sx={{ mb: 2 }}>Pending Team Join Requests</Typography>
                    {pending.length === 0 && <Typography>No pending requests.</Typography>}
                    <Box component="ul" sx={{ listStyle: 'none', p: 0, m: 0 }}>
                        {pending.map(req => (
                            <Paper key={req.id} elevation={1} sx={{ mb: 2, p: 2, display: 'flex', alignItems: 'center', justifyContent: 'space-between', borderRadius: 1 }}>
                                <Box>
                                    <Typography variant="body1" sx={{ fontWeight: 500 }}>
                                        User: <b>{req.user_name}</b> wants to join Team: <b>{req.team_name}</b>
                                    </Typography>
                                </Box>
                                <Box sx={{ display: 'flex', gap: 1 }}>
                                    <Button variant="contained" color="secondary" size="small" onClick={() => handleApprove(req.id)} sx={{ borderRadius: 0.625 }}>Approve</Button>
                                    <Button variant="outlined" color="primary" size="small" onClick={() => handleReject(req.id)} sx={{ borderRadius: 0.625 }}>Reject</Button>
                                </Box>
                            </Paper>
                        ))}
                    </Box>
                </Paper>
            }
            {(notifications.length > 0 && <List>
                {notifications.map(notification => (
                    <ListItem key={notification.id}>
                        <ListItemText
                            primary={notification.message}
                            secondary={`Service: ${notification.service_name} | Time: ${new Date(notification.created_at).toLocaleString()}`}
                        />
                    </ListItem>
                ))}
            </List>) || <Typography sx={{ textAlign: 'center' }}>No notifications!</Typography>}
        </Box>
    );
}
