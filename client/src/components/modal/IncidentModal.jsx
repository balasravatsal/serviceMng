import { useState, useEffect } from 'react';
import {
    Modal, Box, Typography, TextField, Button, Checkbox, FormControlLabel
} from '@mui/material';

export default function IncidentModal({ open, onClose, service, onReportIncident, organizationId, createdByUserId, initialData = {}, mode = 'add' }) {
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const [isScheduled, setIsScheduled] = useState(false);
    const [startTime, setStartTime] = useState('');
    const [endTime, setEndTime] = useState('');
    const [status, setStatus] = useState('Open');

    useEffect(() => {
        if (mode === 'edit' && initialData) {
            setTitle(initialData.title || '');
            setDescription(initialData.description || '');
            setIsScheduled(initialData.is_scheduled_maintenance || false);
            setStartTime(initialData.start_time ? initialData.start_time.slice(0, 16) : '');
            setEndTime(initialData.end_time ? initialData.end_time.slice(0, 16) : '');
            setStatus(initialData.status || 'Open');
        } else if (mode === 'add' && open) {
            setTitle('');
            setDescription('');
            setIsScheduled(false);
            setStartTime('');
            setEndTime('');
            setStatus('Open');
        }
    }, [initialData, open, mode]);

    const handleSubmit = (e) => {
        e.preventDefault();
        const payload = {
            title,
            description,
            organization_id: organizationId,
            status,
            is_scheduled_maintenance: isScheduled,
            start_time: startTime || null,
            end_time: endTime || null,
            created_by_user_id: createdByUserId,
            service_id: service.id,
        };
        if (mode === 'edit' && initialData.id) {
            payload.id = initialData.id;
        }
        onReportIncident(payload);
        onClose();
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
                borderRadius: 0,
                minWidth: 350,
                maxWidth: '90vw',
            }}>
                <Typography variant="h6" mb={2} color="primary" sx={{ fontWeight: 600 }}>{mode === 'edit' ? 'Edit Incident / Maintenance' : 'Report Incident / Maintenance'}</Typography>
                <form onSubmit={handleSubmit}>
                    <TextField
                        label="Service"
                        value={service?.name || ''}
                        fullWidth
                        disabled
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                    />
                    <TextField
                        label="Title"
                        value={title}
                        onChange={e => setTitle(e.target.value)}
                        fullWidth
                        required
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                    />
                    <TextField
                        label="Description"
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                        fullWidth
                        multiline
                        rows={3}
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                    />
                    <FormControlLabel
                        control={<Checkbox checked={isScheduled} onChange={e => setIsScheduled(e.target.checked)} />}
                        label="Scheduled Maintenance"
                        sx={{ mb: 2 }}
                    />
                    <TextField
                        label="Start Time"
                        type="datetime-local"
                        value={startTime}
                        onChange={e => setStartTime(e.target.value)}
                        fullWidth
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                        InputLabelProps={{ shrink: true }}
                    />
                    <TextField
                        label="End Time"
                        type="datetime-local"
                        value={endTime}
                        onChange={e => setEndTime(e.target.value)}
                        fullWidth
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                        InputLabelProps={{ shrink: true }}
                    />
                    <TextField
                        label="Status"
                        select
                        value={status}
                        onChange={e => setStatus(e.target.value)}
                        fullWidth
                        sx={{ mb: 2, bgcolor: '#fff', borderRadius: 2 }}
                        SelectProps={{ native: true }}
                    >
                        <option value="Open">Open</option>
                        <option value="Resolved">Resolved</option>
                        <option value="In Progress">In Progress</option>
                    </TextField>
                    <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                        <Button onClick={onClose} sx={{ mr: 1, borderRadius: 0.625 }}>Cancel</Button>
                        <Button type="submit" variant="contained" sx={{ borderRadius: 0.625, bgcolor: 'primary.main', color: '#fff' }}>{mode === 'edit' ? 'Update' : 'Report'}</Button>
                    </Box>
                </form>
            </Box>
        </Modal>
    );
} 