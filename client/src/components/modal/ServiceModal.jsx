import { useState, useEffect } from 'react';
import {
    Modal, Box, Typography, TextField, Button, MenuItem, Select, InputLabel, FormControl
} from '@mui/material';

export default function ServiceModal({ open, onClose, onSubmit, teams, mode = 'add', initialData = {}, activeTeams = [], user }) {
    const [name, setName] = useState('');
    const [status, setStatus] = useState('');
    const [description, setDescription] = useState('');
    const [teamId, setTeamId] = useState('');

    // Set fields when modal opens/closes or initialData changes
    useEffect(() => {
        if (open) {
            setName(initialData.name || '');
            setStatus(initialData.current_status || '');
            setDescription(initialData.description || '');
            setTeamId(initialData.team_id || '');
        }
    }, [open]);

    const handleSubmit = (e) => {
        e.preventDefault();
        if (name && status && teamId) {
            onSubmit({
                ...initialData,
                name,
                current_status: status,
                description,
                team_id: teamId,
            });
        }
    };

    const statusOptions = [
        'Operational',
        'Degraded Performance',
        'Partial Outage',
        'Major Outage'
    ];

    // Find the team name for display
    const teamName = teams.find(team => team.id === teamId)?.name || '';

    // Determine which teams the user can add to
    const isAdmin = user?.unsafeMetadata?.role === 'admin';
    const isMember = user?.unsafeMetadata?.role === 'member';
    const allowedTeams = isAdmin ? teams : teams.filter(team => activeTeams.includes(team.id));

    return (
        <Modal open={open} onClose={onClose}>
            <Box sx={{
                position: 'absolute',
                top: '50%',
                left: '50%',
                transform: 'translate(-50%, -50%)',
                bgcolor: 'background.paper',
                boxShadow: 24,
                p: 4,
                borderRadius: 0,
                minWidth: 350,
                maxWidth: '90vw',
            }}>
                <Typography variant="h6" mb={2} color="primary" sx={{ fontWeight: 600 }}>
                    {mode === 'edit' ? 'Edit Service' : mode === 'view' ? 'View Service' : 'Add New Service'}
                </Typography>
                {mode === 'view' ? (
                    <Box>
                        <Typography variant="subtitle2">Service Name</Typography>
                        <Typography>{name}</Typography>
                        <Typography variant="subtitle2">Status</Typography>
                        <Typography>{status}</Typography>
                        <Typography variant="subtitle2">Description</Typography>
                        <Typography>{description}</Typography>
                        <Typography variant="subtitle2">Team</Typography>
                        <Typography>{teamName}</Typography>
                        <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                            <Button onClick={onClose} variant="contained" sx={{ borderRadius: 0.625, bgcolor: 'primary.main', color: '#fff' }}>Close</Button>
                        </Box>
                    </Box>
                ) : (
                    <form onSubmit={handleSubmit}>
                        <TextField
                            label="Service Name"
                            value={name}
                            onChange={e => setName(e.target.value)}
                            fullWidth
                            required
                            sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                        />
                        <FormControl fullWidth required sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}>
                            <InputLabel>Status</InputLabel>
                            <Select
                                value={status}
                                label="Status"
                                onChange={e => setStatus(e.target.value)}
                            >
                                {statusOptions.map(opt => (
                                    <MenuItem key={opt} value={opt}>{opt}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <TextField
                            label="Description"
                            value={description}
                            onChange={e => setDescription(e.target.value)}
                            fullWidth
                            multiline
                            rows={3}
                            sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                        />
                        <FormControl fullWidth required sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}>
                            <InputLabel>Team</InputLabel>
                            <Select
                                value={teamId}
                                label="Team"
                                onChange={e => setTeamId(e.target.value)}
                            >
                                {allowedTeams.map(team => (
                                    <MenuItem key={team.id} value={team.id}>{team.name}</MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                        <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                            <Button onClick={onClose} sx={{ mr: 1, borderRadius: 0.625 }}>Cancel</Button>
                            <Button type="submit" variant="contained" sx={{ borderRadius: 0.625, bgcolor: 'primary.main', color: '#fff' }}>{mode === 'edit' ? 'Save' : 'Add'}</Button>
                        </Box>
                    </form>
                )}
            </Box>
        </Modal>
    );
} 