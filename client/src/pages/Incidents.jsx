import { useEffect, useState } from 'react';
import { getIncidents, updateIncident, getIncidentsByOrganization } from '../api/incidentApi';
import { getUserActiveTeams } from '../api/teamMembershipApi.js';
import IncidentModal from '../components/modal/IncidentModal';
import { Box, Typography, List, ListItem, IconButton, Chip, Paper, TextField, MenuItem, InputAdornment } from '@mui/material';
import EditIcon from '@mui/icons-material/Edit';
import SearchIcon from '@mui/icons-material/Search';

export default function Incidents({ user }) {
    const [incidents, setIncidents] = useState([]);
    const [editIncident, setEditIncident] = useState(null);
    const [modalOpen, setModalOpen] = useState(false);
    const [activeTeams, setActiveTeams] = useState([]);
    const [statusFilter, setStatusFilter] = useState('');
    const [titleFilter, setTitleFilter] = useState('');
    const [loadingIncidents, setLoadingIncidents] = useState(false);

    const isAdmin = user?.unsafeMetadata?.role === 'admin';
    const isMember = user?.unsafeMetadata?.role === 'member';

    useEffect(() => {
        fetchIncidents();
        if (user?.id && isMember) {
            getUserActiveTeams(user.id).then(setActiveTeams);
        }
    }, [user]);

    const fetchIncidents = async () => {
        try {
            setLoadingIncidents(true);
            console.log('fetching incidents', user.unsafeMetadata.organizationId);
            const data = await getIncidentsByOrganization(user.unsafeMetadata.organizationId);
            setIncidents(data);
        } finally {
            setLoadingIncidents(false);
        }
    };

    const handleEdit = (incident) => {
        setEditIncident(incident);
        setModalOpen(true);
    };

    const handleUpdateIncident = async (incidentData) => {
        await updateIncident(incidentData.id, incidentData);
        setModalOpen(false);
        setEditIncident(null);
        fetchIncidents();
    };

    const visibleIncidents = (isAdmin
        ? incidents
        : incidents.filter(incident => activeTeams.includes(incident.service?.team_id))
    ).filter(incident =>
        (statusFilter === '' || incident.status === statusFilter) &&
        (titleFilter === '' || incident.title.toLowerCase().includes(titleFilter.toLowerCase()))
    );

    const getStatusColor = (status) => {
        switch (status) {
            case 'Open': return 'warning';
            case 'Resolved': return 'success';
            case 'In Progress': return 'info';
            default: return 'default';
        }
    };

    if (loadingIncidents) {
        return <div>Loading incidents...</div>;
    }

    return (
        <Box sx={{ p: { xs: 1, md: 3 } }}>
            <Typography variant="h4" mb={3} color="primary" sx={{ fontWeight: 600 }}>Incidents</Typography>
            <Box sx={{ display: 'flex', gap: 2, mb: 2, flexWrap: 'wrap' }}>
                <TextField
                    label="Filter by Title"
                    value={titleFilter}
                    onChange={e => setTitleFilter(e.target.value)}
                    size="small"
                    sx={{ minWidth: 200, bgcolor: '#fff', borderRadius: 2 }}
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        ),
                    }}
                />
                <TextField
                    label="Filter by Status"
                    value={statusFilter}
                    onChange={e => setStatusFilter(e.target.value)}
                    select
                    size="small"
                    sx={{ minWidth: 180, bgcolor: '#fff', borderRadius: 2 }}
                >
                    <MenuItem value="">All</MenuItem>
                    <MenuItem value="Open">Open</MenuItem>
                    <MenuItem value="Resolved">Resolved</MenuItem>
                    <MenuItem value="In Progress">In Progress</MenuItem>
                </TextField>
            </Box>
            <List sx={{ width: '100%', maxWidth: '100%'}}>
                <ListItem sx={{ fontWeight: 'bold', bgcolor: '#030027', color: '#fff', display: { xs: 'none', md: 'flex' } }}>
                    <Box sx={{ display: 'flex', width: '100%' }}>
                        <Box sx={{ flex: 2 }}>Title</Box>
                        <Box sx={{ flex: 3 }}>Description</Box>
                        <Box sx={{ flex: 2 }}>Service</Box>
                        <Box sx={{ flex: 2 }}>Status</Box>
                        <Box sx={{ flex: 2 }}>Scheduled</Box>
                        <Box sx={{ flex: 2 }}>Start</Box>
                        <Box sx={{ flex: 2 }}>End</Box>
                        <Box sx={{ flex: 1 }}>Actions</Box>
                    </Box>
                </ListItem>
                {visibleIncidents.map((incident) => (
                    <Paper key={incident.id} elevation={2} sx={{ mb: 2, p: { xs: 1, md: 0 }}}>
                        <ListItem divider sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, alignItems: 'center', gap: 1 }}>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>{incident.title}</Box>
                            <Box sx={{ flex: 3, width: { xs: '100%', md: 'auto' } }}>{incident.description}</Box>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>{incident.service?.name}</Box>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>
                                <Chip label={incident.status} color={getStatusColor(incident.status)} />
                            </Box>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>{incident.is_scheduled_maintenance ? 'Yes' : 'No'}</Box>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>{incident.start_time}</Box>
                            <Box sx={{ flex: 2, width: { xs: '100%', md: 'auto' } }}>{incident.end_time}</Box>
                            <Box sx={{ flex: 1, width: { xs: '100%', md: 'auto' } }}>
                                <IconButton onClick={() => handleEdit(incident)}><EditIcon /></IconButton>
                            </Box>
                        </ListItem>
                    </Paper>
                ))}
            </List>
            {modalOpen && editIncident && (
                <IncidentModal
                    open={modalOpen}
                    onClose={() => setModalOpen(false)}
                    service={{
                        id: editIncident.service_id,
                        name: editIncident.service?.name
                    }}
                    onReportIncident={handleUpdateIncident}
                    organizationId={user.unsafeMetadata.organizationId}
                    createdByUserId={user.id}
                    initialData={editIncident}
                    mode="edit"
                />
            )}
        </Box>
    );
} 