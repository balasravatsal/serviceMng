import { Box, Button, List, ListItem, Typography, IconButton, Chip, Paper, useTheme, TextField, MenuItem, InputAdornment, FormControl, InputLabel, Select } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import VisibilityIcon from '@mui/icons-material/Visibility';
import ServiceModal from './modal/ServiceModal';
import { useState, useEffect } from 'react';
import ReportProblemIcon from '@mui/icons-material/ReportProblem';
import IncidentModal from './modal/IncidentModal';
import { createIncident } from '../api/incidentApi';
import { getUserActiveTeams } from '../api/teamMembershipApi.js';
import SearchIcon from '@mui/icons-material/Search';

export default function ServicesGrid({
    services,
    onEdit,
    onDelete,
    onView,
    teams,
    onAddService,
    onEditService,
    selectedTeam,
    onReportIncident,
    user
}) {
    const [open, setOpen] = useState(false);
    const [editService, setEditService] = useState(null);
    const [viewOpen, setViewOpen] = useState(false);
    const [serviceToView, setServiceToView] = useState(null);
    const [incidentOpen, setIncidentOpen] = useState(false);
    const [incidentService, setIncidentService] = useState(null);
    const [activeTeams, setActiveTeams] = useState([]);
    const [statusFilter, setStatusFilter] = useState('');
    const [titleFilter, setTitleFilter] = useState('');
    const theme = useTheme();

    useEffect(() => {
        if (user?.id) {
            getUserActiveTeams(user.id).then(setActiveTeams);
        }
    }, [user]);

    const isActiveMember = selectedTeam ? activeTeams.includes(selectedTeam) : true;
    const isAdmin = user?.unsafeMetadata?.role === 'admin';
    const isMember = user?.unsafeMetadata?.role === 'member';
    const canEdit = isAdmin || (isMember && isActiveMember);

    // Filtered services by selectedTeam, status, and title
    const filteredServices = (selectedTeam
        ? services.filter(service => service.team_id === selectedTeam)
        : services
    ).filter(service =>
        (statusFilter === '' || service.current_status === statusFilter) &&
        (titleFilter === '' || service.name.toLowerCase().includes(titleFilter.toLowerCase()))
    );

    // Helper for status chip color
    const getStatusColor = (status) => {
        switch (status) {
            case 'Operational': return 'success';
            case 'Degraded Performance': return 'warning';
            case 'Partial Outage': return 'info';
            case 'Major Outage': return 'error';
            default: return 'default';
        }
    };

    return (
        <Box sx={{ flex: 1, p: { xs: 1, md: 3 } }}>
            <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h5" color="primary" sx={{ fontWeight: 600 }}>Services</Typography>
                {canEdit && (
                    <Button
                        variant="contained"
                        startIcon={<AddIcon />}
                        onClick={() => setOpen(true)}
                        sx={{ borderRadius: 3, bgcolor: 'primary.main', color: '#fff', '&:hover': { bgcolor: 'primary.dark' } }}
                    >
                        Add Service
                    </Button>
                )}
            </Box>
            <Box sx={{ display: 'flex', gap: 2, mb: 2, flexWrap: 'wrap' }}>
                <TextField
                    label="Filter by Status"
                    value={statusFilter}
                    onChange={e => setStatusFilter(e.target.value)}
                    select
                    size="small"
                    sx={{ minWidth: 180, bgcolor: '#fff', borderRadius: 2 }}
                >
                    <MenuItem value="">All</MenuItem>
                    <MenuItem value="Operational">Operational</MenuItem>
                    <MenuItem value="Degraded Performance">Degraded Performance</MenuItem>
                    <MenuItem value="Partial Outage">Partial Outage</MenuItem>
                    <MenuItem value="Major Outage">Major Outage</MenuItem>
                </TextField>
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
            </Box>
            <List >
                <ListItem sx={{ fontWeight: 'bold', bgcolor: '#030027', color: '#fff', borderRadius: 0, display: { xs: 'none', md: 'flex' }, alignItems: 'center' }}>
                    <Box sx={{ display: 'flex', width: '100%', alignItems: 'center' }}>
                        <Box sx={{ flex: 2 }}><Typography variant="subtitle2">Name</Typography></Box>
                        <Box sx={{ flex: 2 }}><Typography variant="subtitle2">Team</Typography></Box>
                        <Box sx={{ flex: 2 }}><Typography variant="subtitle2">Status</Typography></Box>
                        <Box sx={{ flex: 4 }}><Typography variant="subtitle2">Description</Typography></Box>
                        <Box sx={{ flex: 1, textAlign: 'right' }}><Typography variant="subtitle2">Actions</Typography></Box>
                    </Box>
                </ListItem>
                {/* Data Rows */}
                {filteredServices.map((service) => {
                    const canEditRow = isAdmin || (isMember && activeTeams.includes(service.team_id));
                    return (
                        <Paper key={service.id} elevation={2} sx={{ mb: 2, borderRadius: 0, p: { xs: 1, md: 0 }, bgcolor: '#fff' }}>
                            <ListItem divider sx={{ borderRadius: 0, display: 'flex', alignItems: 'center', flexDirection: 'row', gap: 1 }}>
                                <Box sx={{ flex: 2, display: 'flex', alignItems: 'center' }}><Typography>{service.name}</Typography></Box>
                                <Box sx={{ flex: 2, display: 'flex', alignItems: 'center' }}><Typography>{teams.find(team => team.id === service.team_id)?.name || ''}</Typography></Box>
                                <Box sx={{ flex: 2, display: 'flex', alignItems: 'center' }}><Chip label={service.current_status} color={getStatusColor(service.current_status)} /></Box>
                                <Box sx={{ flex: 4, display: 'flex', alignItems: 'center' }}><Typography variant="body2">{service.description}</Typography></Box>
                                <Box sx={{ flex: 1, display: 'flex', justifyContent: 'flex-end', gap: 1, alignItems: 'center' }}>
                                    <IconButton size="small" onClick={() => {
                                        onView && onView(service)
                                        setViewOpen(true)
                                        setServiceToView(service)
                                    }}>
                                        <VisibilityIcon />
                                    </IconButton>
                                    {canEditRow && (
                                        <IconButton size="small" onClick={() => {
                                            if (onEdit) onEdit(service);
                                            setEditService(service);
                                        }}>
                                            <EditIcon />
                                        </IconButton>
                                    )}
                                    {canEditRow && (
                                        <IconButton size="small" color="error" onClick={() => onDelete && onDelete(service)}>
                                            <DeleteIcon />
                                        </IconButton>
                                    )}
                                    <IconButton size="small" color="warning" onClick={() => {
                                        setIncidentService(service);
                                        setIncidentOpen(true);
                                    }} title="Report Incident / Maintenance">
                                        <ReportProblemIcon />
                                    </IconButton>
                                </Box>
                            </ListItem>
                        </Paper>
                    );
                })}
            </List>
            {open && <ServiceModal 
                open={open} 
                onClose={() => setOpen(false)} 
                onSubmit={async (serviceData) => {
                    await onAddService(serviceData);
                    setOpen(false);
                }} 
                teams={teams}
                mode="add"
                activeTeams={activeTeams}
                user={user}
            />}
            {editService && <ServiceModal
                open={!!editService}
                onClose={() => setEditService(null)}
                onSubmit={async (serviceData) => {
                    await onEditService(serviceData);
                    setEditService(null);
                }}
                teams={teams}
                mode="edit"
                initialData={editService}
                activeTeams={activeTeams}
                user={user}
            />}
            {viewOpen && <ServiceModal
                open={viewOpen}
                onClose={() => setViewOpen(false)}
                teams={teams}
                mode="view"
                initialData={serviceToView}
            />}
            {incidentOpen && incidentService && (
                <IncidentModal
                    open={incidentOpen}
                    onClose={() => setIncidentOpen(false)}
                    service={incidentService}
                    onReportIncident={async (incidentData) => {
                        await createIncident(incidentData);
                        setIncidentOpen(false);
                        if (onReportIncident) onReportIncident();
                    }}
                    organizationId={user.organization?.id || user.unsafeMetadata?.organizationId}
                    createdByUserId={user.id}
                    mode="add"
                    initialData={{}}
                />
            )}
        </Box>
    );
}
