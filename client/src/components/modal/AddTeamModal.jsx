import { useState } from 'react';
import { Modal, Box, Typography, TextField, Button } from '@mui/material';

export default function AddTeamModal({ open, onClose, onAdd }) {
    const [teamName, setTeamName] = useState('');

    const handleSubmit = (e) => {
        e.preventDefault();
        if (teamName.trim()) {
            onAdd(teamName);
            setTeamName('');
        }
    };

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
                borderRadius: 2,
                minWidth: 300,
            }}>
                <Typography variant="h6" mb={2}>Add New Team</Typography>
                <form onSubmit={handleSubmit}>
                    <TextField
                        label="Team Name"
                        value={teamName}
                        onChange={e => setTeamName(e.target.value)}
                        fullWidth
                        required
                        sx={{ mb: 2 }}
                    />
                    <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                        <Button onClick={onClose} sx={{ mr: 1 }}>Cancel</Button>
                        <Button type="submit" variant="contained">Add</Button>
                    </Box>
                </form>
            </Box>
        </Modal>
    );
}
